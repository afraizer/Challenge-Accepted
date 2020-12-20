//
//  PasswordlessViewController.swift
//  ChallengeAccepted
//
//  Created by Clare Casey on 12/14/20.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class PasswordlessViewController: UIViewController {
    var score = 0
    var password = "Password"
    var email = "123@gmail.com"
    var db: Firestore!
    
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
    }
    
    func setUpElements() {
        errorLabel.alpha = 0
        
    }
    
    @IBAction func LoginButton(_ sender: Any) {
        print("Login button pressed")
    }
    @IBAction func RegisterButton(_ sender: UIButton) {
        
        let error = validateFields()
        
        if error != nil {
            self.showError(error!)
        }
        
        else {
            
            let myPassword = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let myEmail = emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // create user
            Auth.auth().createUser(withEmail: myEmail, password: myPassword) { (result, err) in
                if let err = err {
                    print(err)
                    self.showError("Error creating user")
                }
                else {
                    let db = Firestore.firestore()
                    db.collection("users").document("user").setData(["score": 0 , "uid": result!.user.uid
                    ]) { (error) in
                        if error != nil {
                            self.showError("user data couldn't be saved")
                        }
                    }
                    self.transitionToHome()
                }
            }
        }
    }
    
    // takes a string, message and shows the error in the error label text
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    // takes a string and checks if it is a valid password
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[0-9])(?=.*[A-Z]).{8,}$")
        return passwordTest.evaluate(with: password)
    }
    
    // makes sure that all of the text entered in the text fields is able to create a valid
    func validateFields() -> String? {
        
        if emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        
        let cleanedPassword = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if PasswordlessViewController.isPasswordValid(cleanedPassword) == false {
            return "Please make sure your password is at least 8 characters long, contains a special character and a number."
        }
        
        return nil
    }
    
    // programmatic segue that makes the tableViewController the root view controller after the user has logged in
    func transitionToHome() {
        let tableViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.tableViewController)
        view.window?.rootViewController = tableViewController
        view.window?.makeKeyAndVisible()
    }
}

