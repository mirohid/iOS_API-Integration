//
//  UserModel.swift
//  WtsAcademyProject(21_07_24)
//
//  Created by Mir Ohid Ali on 21/07/24.
//

import Foundation
import Alamofire

struct UserModel {
    let firstName: String
    let lastName: String
    let email: String
    let password: String
    let profilePic: UIImage
    
    // MARK: - API Endpoints
    private static let signupURL = "https://wtsacademy.dedicateddevelopers.us/api/user/signup"
    private static let loginURL = "https://wtsacademy.dedicateddevelopers.us/api/user/signin"
    
    // MARK: - Signup Method
    static func signup(user: UserModel,retryCount: Int = 0, completion: @escaping (Result<String, Error>) -> Void) {
        let retryLimit = 3
        let parameters: [String: String] = [
            "first_name": user.firstName,
            "last_name": user.lastName,
            "email": user.email,
            "password": user.password
        ]
        
        AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                    multipartFormData.append(Data(value.utf8), withName: key)
                }
                if let imageData = user.profilePic.jpegData(compressionQuality: 0.5) {
                    multipartFormData.append(imageData, withName: "profile_pic", fileName: "profile.jpg", mimeType: "image/jpeg")
                }
            },
            to: signupURL
        ).responseJSON { response in
            switch response.result {
            case .success(let value):
                print("signup response: \(value)") // log the full response
                if let json = value as? [String: Any], let token = json["token"] as? String {
                    completion(.success(token))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                }
            case .failure(let error):
                completion(.failure(error))
                print("Signup error: \(error)")
                if retryCount < retryLimit {
                let retryDelay = pow(2.0, Double(retryCount))  // Exponential backoff
                DispatchQueue.global().asyncAfter(deadline: .now() + retryDelay) {
                signup(user: user, retryCount: retryCount + 1, completion: completion)
                    }
                } else {
                    completion(.failure(error))
               }
            }
        }
    }
    
    // MARK: - Login Method
    static func login(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]
        
        AF.request(loginURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any], let token = json["token"] as? String {
                    completion(.success(token))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

