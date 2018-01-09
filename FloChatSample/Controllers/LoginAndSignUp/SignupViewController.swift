//
//  SignupViewController.swift
//  FloChatSample
//
//  Created by Seevan Ranka on 28/12/17.
//  Copyright © 2017 Seevan Ranka. All rights reserved.
//

import UIKit
import SQLite
class SignupViewController: UIViewController {
    var LocalStorage = UserDefaults.standard

    @IBOutlet weak var nameTxtFld: UITextField!
    @IBOutlet weak var emailTxtFld: UITextField!
    
    @IBOutlet weak var passwordTxtFld: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    @IBAction func createUserBtnClicked(_ sender: Any) {
        if emailTxtFld!.text != "" && passwordTxtFld.text != "" && nameTxtFld.text != "" {
            if isValidEmail(testStr: emailTxtFld!.text!)
            {
            } else {
                let alert = UIAlertController(title: "Try Again", message: "Invalid Email.", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel,handler: {_ in
                    
                });
                alert.addAction(action)
                self.present(alert, animated: true, completion:nil)
                return
            }
             let isUserPresent = DBManager.instance.userExists(cemail: emailTxtFld.text!)
            if isUserPresent {
                let alert = UIAlertController(title: "User Already Exists", message: "This email is already registered", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel,handler: {_ in
                });
                alert.addAction(action)
                self.present(alert, animated: true, completion:nil)
                return
            }
           let id = DBManager.instance.addUser(cname: nameTxtFld.text!, cemail: emailTxtFld.text!, cpassword: passwordTxtFld.text!)
            if id != -1 {
                self.LocalStorage.set(emailTxtFld.text!, forKey: "USER_EMAIL")
                self.LocalStorage.set(true, forKey: "login")
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                let navController = UINavigationController(rootViewController: nextViewController)
                self.present(navController, animated:true, completion:nil)
            } else {
                let alert = UIAlertController(title: "Try Again", message: "Something went wrong while adding user", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel,handler: {_ in
                    
                });
                alert.addAction(action)
                self.present(alert, animated: true, completion:nil)
            }
        }
    }
    
    @IBAction func loginBtnClicked(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
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
