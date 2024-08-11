//
//  SigninViewController.swift
//  WtsAcademyProject(21_07_24)
//
//  Created by Mir Ohid Ali on 21/07/24.
//

import UIKit

class SigninViewController: UIViewController {

    @IBOutlet weak var segmentOutlet: UISegmentedControl!
    
    @IBOutlet weak var loginSegmentView: UIView!
    
    @IBOutlet weak var RegisterSegmentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Segment text colour --->>
        let titleText = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentOutlet.setTitleTextAttributes(titleText, for: .normal)
        
        self.view.bringSubviewToFront(loginSegmentView)
    }

    
    @IBAction func SegmentAction(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex{
        case 0:
            self.view.bringSubviewToFront(loginSegmentView)
        case 1:
            self.view.bringSubviewToFront(RegisterSegmentView)
        default:
            break
        }
    }
    
}
