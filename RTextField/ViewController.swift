//
//  ViewController.swift
//  RTextField
//
//  Created by Rashid Latif on 04/02/2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var emailTextField:RTextField!
    @IBOutlet private weak var passwordTextField:RTextField!
    @IBOutlet private weak var phoneTextField:RTextField!
    @IBOutlet private weak var otpTextField:OneTimeCodeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        otpTextField.configure()
    }
    
    @IBAction func showErrors(_ sender: Any) {
        self.emailTextField.showErrorMessage(errorString: "Incorrect email")
        self.passwordTextField.showErrorMessage(errorString: "Incorrect Password")
        self.phoneTextField.showErrorMessage(errorString: "Incorrect phone number")
        
    }

}
