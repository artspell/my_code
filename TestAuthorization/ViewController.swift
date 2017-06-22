//
//  ViewController.swift
//  TestAuthorization
//
//  Copyright © 2017 ArtSpell. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

class ViewController: UIViewController {
    
    let server = Server()
    let alert = UIAlertController()
    
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //default - Log In mode
        self.setLogInMode()
    }
    
    //press main button
    @IBAction func authorizaion(_ sender: UIButton) {
        let login = loginField.text!
        let password = passField.text!
        let email = emailField.text!
        //log in
        if sender.currentTitle == "Log In" {
            server.LogIn(username: login, password: password) {
                (response, error) in
                //if  error executing the request to the server (alamofire)
                if let errorMessage = error {
                    self.alert.presentAlertWithText(self, text: "\(errorMessage)")
                }
                //show alert if user is not found or server returned error
                guard response["key"] != nil else{
                    print("\(response.dictionary?.values.first!)")
                    self.alert.presentAlertWithText(self, text: "\(response.dictionary!.keys.first!) -> \(response.dictionary!.values.first![0])")
                    return
                }
                //if authorization is OK get list of users and show them as a table
                Server().GetAllUsers() { _ in self.presentTableViewController() }
            }
            return
        }
        //registration
        server.Registration(username: login, password: password, email: email) {
            (response,error) in
            //if  error executing the request to the server (alamofire)
            if let errorMessage = error {
                self.alert.presentAlertWithText(self, text: "\(errorMessage)")
            }
            //registration successful
            if response["token"].string != nil {
                self.setLogInMode()
                self.alert.presentAlertWithText(self, text: "Сongratulations! Registration completed successfully! Please try to Log In!")
                return
            }
            //reply from server about error
            self.alert.presentAlertWithText(self, text: (response.dictionary?.values.first?.string)!)
        }
    }
    
    @IBAction func clickRegistrationButton(_ sender: UIButton) {
        //change mode
        if emailField.isHidden {
            self.setSignUpMode()
        } else {
            self.setLogInMode()
        }
    }
    
    //navigation to tableViewController
    func presentTableViewController() {
        let tableViewController = self.storyboard?.instantiateViewController(withIdentifier: "navigationController") as! UINavigationController
        present(tableViewController, animated: false, completion: nil)
    }
    
    //hide email field
    func setLogInMode() {
        emailField.isHidden = true
        emailLabel.isHidden = true
        enterButton.setTitle("Log In", for: .normal)
        registrationButton.setTitle("Sign Up", for: .normal)
    }
    
    //show email field
    func setSignUpMode() {
        emailField.isHidden = false
        emailLabel.isHidden = false
        enterButton.setTitle("Sign Up", for: .normal)
        registrationButton.setTitle("Log In", for: .normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
