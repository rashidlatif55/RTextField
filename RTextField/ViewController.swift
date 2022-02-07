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
        self.emailTextField.setError(errorString: "Incorrect E-mail")
        self.passwordTextField.setError(errorString: "Incorrect Password")
        print(passwordTextField.frame.width)
    }

}
