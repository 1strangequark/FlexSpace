//
//  SecondViewController.swift
//  New Flex Space v5
//
//  Created by Admin on 6/21/19.
//  Copyright © 2019 Admin. All rights reserved.
////

import UIKit
import Firebase
import FirebaseAuth

class SecondViewController: UIViewController {
    @IBOutlet weak var emailAddressField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var retypePasswordField: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var checkMark: UIImageView!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad()
    {
        createAccountButton.layer.cornerRadius = createAccountButton.bounds.size.height / 2
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    var previousNumber = 0
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        emailAddressField.resignFirstResponder()
        passwordField.resignFirstResponder()
        retypePasswordField.resignFirstResponder()
        nameField.resignFirstResponder()
        
    }
    
    @IBAction func createAccount(_ sender: UIButton)
    {
        let name: String? = nameField.text
        let emailAddress: String? = emailAddressField.text
        
        let password: String? = passwordField.text
       
        if (password != retypePasswordField.text)
        {
            print("Passwords in account creation do not match")
            //***Ui Alert saying to retype password***
            let phrases = ["Shucks", "Drat", "Gosh", "Fiddlesticks", "Rats", "Pshaw", "Gee Whiz", "Jeepers"]
            var number = Int.random(in: 0 ..< phrases.count)
            while number == self.previousNumber
            {
                number = Int.random(in: 0 ..< phrases.count)
            }
            let phrase = phrases[number]
            self.previousNumber = number
            let alertController = UIAlertController(title: "Passwords Don't Match", message:
                "Please try again", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: phrase, style: .default))
            
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            Auth.auth().createUser(withEmail: emailAddress!, password: password!)
            { authResult, error in
                if error == nil
                {
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = name!
                    changeRequest?.photoURL = URL(string: "http://")
                    changeRequest?.commitChanges { (error) in
                    }
                    self.db.collection("Names").document(name!).setData([
                        "User created at": Date()
                    ]) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("New Account Created Successfully")
                            
                                self.checkMark.loadGif(name: "CheckMark")
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { // Change `2.0` to the desired number of seconds.
                                    self.checkMark.loadGif(name: "Transparent")
                                    Auth.auth().signIn(withEmail: emailAddress!, password: password!) { [weak self] user, error in
                                        guard self != nil else { return }
                                        if error == nil
                                        {
                                            print("User Signed in Successfully")
                                            self!.performSegue(withIdentifier: "goHome2", sender: self)
                                            
                                        }
                                        else
                                        {
                                            //Deliver at UI alert telling the user their password was incorrect
                                            let phrases = ["Shucks", "Drat", "Gosh", "Fiddlesticks", "Rats", "Pshaw", "Gee Whiz", "Jeepers"]
                                            var number = Int.random(in: 0 ..< phrases.count)
                                            while number == self!.previousNumber
                                            {
                                                number = Int.random(in: 0 ..< phrases.count)
                                            }
                                            let phrase = phrases[number]
                                            self!.previousNumber = number
                                            let alertController = UIAlertController(title: "Error logging you in", message:
                                                "Please try again", preferredStyle: .alert)
                                            alertController.addAction(UIAlertAction(title: phrase, style: .default))
                                            
                                            self?.present(alertController, animated: true, completion: nil)
                                            self!.performSegue(withIdentifier: "goHome2", sender: self)
                                        }
                                    }
                                }

                        
                            }
                            
                        }
                    }
        
//                    self.performSegue(withIdentifier: "goHome", sender: self)
                else
                {
                    print("There was an error creating the account")
                    let phrases = ["Shucks", "Drat", "Gosh", "Fiddlesticks", "Rats", "Pshaw", "Gee Whiz", "Jeepers"]
                    var number = Int.random(in: 0 ..< phrases.count)
                    while number == self.previousNumber
                    {
                        number = Int.random(in: 0 ..< phrases.count)
                    }
                    let phrase = phrases[number]
                    self.previousNumber = number
                    let alertController = UIAlertController(title: "There was an error creating the account", message:
                        "1. Check your internet connection\n2. An account with this email may also already exist\n3. Make sure you used both letters and numbers in your password", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: phrase, style: .default))
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            
        }
    }
    
}
