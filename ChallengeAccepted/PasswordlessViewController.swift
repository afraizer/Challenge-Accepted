//
//  PasswordlessViewController.swift
//  ChallengeAccepted
//
//  Created by Clare Casey on 12/14/20.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class ViewController: UIViewController {
    var score = 0
    var password = "Password"
    var email = "123@gmail.com"
    var db: Firestore!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        
        db = Firestore.firestore()
    }
    
    @IBAction func LoginButton(_ sender: Any) {
    }
    @IBAction func RegisterButton(_ sender: UIButton) {
        addAdaLovelace()
    }
    
    private func addAdaLovelace() {
        // [START add_ada_lovelace]
        // Add a new document with a generated ID
        var ref: DocumentReference? = nil
        ref = db.collection("users").addDocument(data: [
            "email": "Ada@gmail.com",
            "password": "Lovelace",
            "score": 1815
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        // [END add_ada_lovelace]
    }
}

