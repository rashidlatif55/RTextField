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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func showErrors(_ sender: Any) {
        self.emailTextField.showErrorMessage(errorString: "Incorrect email")
        self.passwordTextField.showErrorMessage(errorString: "Incorrect Password")
        
    }

}
