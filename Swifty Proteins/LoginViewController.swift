//
//  LoginViewController.swift
//  Swifty Proteins
//
//  Created by Bastien NIZARD on 10/2/17.
//  Copyright © 2017 Bastien NIZARD. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController {

    var context : LAContext = LAContext()
    
    @IBOutlet weak var TouchIdButton: UIButton!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    @IBAction func loginButton(_ sender: Any) {
       if (usernameText.text == "admin" && passwordText.text == "admin")
       {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "showLigandScreen", sender: nil)
            }
        }
        else
       {
            let alertController = UIAlertController(title: "YSNP", message: "Wrong username and/or password", preferredStyle: .alert)
            let myAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(myAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        {
            TouchIdButton.isEnabled = true
        }
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background42")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func TouchIdAction(_ sender: Any) {
        context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "We need your TouchID", reply: {
            (wasSuccessful, error) in
            if wasSuccessful
            {
                print("WAS A SUCCESS")
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "showLigandScreen", sender: nil)
                }
            }
            else
            {
                print("NOT LOGGED IN")
            }
        })
    }
}


