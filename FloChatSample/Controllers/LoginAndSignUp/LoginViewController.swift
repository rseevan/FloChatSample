//
//  LoginViewController.swift
//  FloChatSample
//
//  Created by Seevan Ranka on 28/12/17.
//  Copyright © 2017 Seevan Ranka. All rights reserved.
//

import UIKit
import SQLite
class LoginViewController: UIViewController {
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    var LocalStorage = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func loginBtnClicked(_ sender: Any) {
        if emailTxtFld.text != "" && passwordTxtFld.text != "" {
            let isVerified = DBManager.instance.verifyUser(cemail: emailTxtFld.text!, cpassword: passwordTxtFld.text!)
            if isVerified {
                self.LocalStorage.set(emailTxtFld.text!, forKey: "USER_EMAIL")
                self.LocalStorage.set(true, forKey: "login")
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                let navController = UINavigationController(rootViewController: nextViewController)
                self.present(navController, animated:true, completion:nil)
            } else {
                let alert = UIAlertController(title: "Try Again", message: "Check email or Password", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel,handler: {_ in
                    
                });
                alert.addAction(action)
                self.present(alert, animated: true, completion:nil)
            }
        }
    }
    
    @IBAction func signUpBtnClicked(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
