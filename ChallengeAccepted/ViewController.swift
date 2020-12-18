//
//  ViewController.swift
//  ChallengeAccepted
//
//  Created by Clare Casey on 12/7/20.
//

import UIKit
import FirebaseAuth
import Firebase

class PasswordlessViewController: UIViewController {
    var score = 0
    var password = "Password"
    var email = "123@gmail.com"
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        // Do any additional setup after loading the view.
        let db = Firestore.firestore()
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
    
    @IBAction func RegisterButton(_ sender: UIButton) {
        let emailText = unwrapVars(inputString: emailField.text)
        let passwordText = unwrapVars(inputString: passwordField.text)
        Auth.auth().createUser(withEmail: emailText, password: passwordText) { authResult, error in
            if let authResult = authResult {
                print("auth result \(authResult)")
            }
            if let error = error {
                print("error \(error)")
            }
        }
    }
    
    @IBAction func LoginButton(_ sender: UIButton) {
        print("login button pressed")
    }
    
    func unwrapVars(inputString: String?) -> String {
        if let input = inputString {
            return input
        }
        return "password"
    }
}

