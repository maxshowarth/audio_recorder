//
//  PhoneNumberSolicitationViewController.swift
//  Audio_Recorder
//
//  Created by Max Howarth on 2018-06-07.
//  Copyright © 2018 Howarth Technologies. All rights reserved.
//

import UIKit
import Foundation

class PhoneNumberSolicitationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.gradientLayer.colors = [ UIConstants.sharedInstance.bottom, UIConstants.sharedInstance.middle, UIConstants.sharedInstance.top]
        view.gradientLayer.gradient = GradientPoint.bottomTop.draw()
    // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBOutlet weak var phoneNumberField: UITextField!
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let viewController = segue.destination as? ViewController {
//            viewController.phoneNumber = phoneNumberField.text
//        }
//    }
    

    
}
