//
//  ViewController.swift
//  New Flex Space v5
//
//  Created by Admin on 6/20/19.
//  Copyright © 2019 Admin. All rights reserved.
////

import UIKit
import LocalAuthentication
import Firebase
import FirebaseAuth
import FirebaseUI

var autoFaceID = true

class ViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var rememberMeSwitch: UISwitch!
    
    var sentFromAnotherViewController = Bool()
    
    var offices = [String]()
    
    /////////////////////////////////// FACE ID STUFF/////////////////////////
    ////// An authentication context stored at class scope so it's available for use during UI updates.
    var context = LAContext()
    
    /// The available states of being logged in or not.
    enum AuthenticationState
    {
        case loggedin, loggedout
    }
    
    
    
    /// The current authentication state.
    var state = AuthenticationState.loggedout
    {
        // Update the UI on a change.
        didSet
        {
        }
    }
    ///////////////////////////////////////////////////////////////////////////////////
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        background.image = UIImage(named: "Mountain")
        
        loginButton.layer.cornerRadius = loginButton.bounds.size.height / 2
        signUpButton.layer.cornerRadius = signUpButton.bounds.size.height / 2
        
        usernameField.text = UserDefaults.standard.string(forKey: "EmailAddress") ?? ""
        passwordField.text = UserDefaults.standard.string(forKey: "Password") ?? ""
        
        context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        state = .loggedout
        
        if state == .loggedin
        {
            
            // Log out immediately.
            state = .loggedout
            
        }
        else if (passwordField.text != "" && autoFaceID)
        {
            context = LAContext()
            
            context.localizedCancelTitle = "Enter Username/Password"
            
            var error: NSError?
            if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)
            {
                
                let reason = "Log in to your account"
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { success, error in
                    
                    if success {
                        
                        // Move to the main thread because a state update triggers UI changes.
                        DispatchQueue.main.async { [unowned self] in
                            self.state = .loggedin
                            self.authenticate()
                        }
                        
                    } else {
                        print(error?.localizedDescription ?? "Failed to authenticate")
                        
                        // Fall back to a asking for username and password.
                        // ...
                    }
                }
            }
            else
            {
                print(error?.localizedDescription ?? "Can't evaluate policy")
                
                // Fall back to a asking for username and password.
                // ...
            }
        }
        
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        authenticate()
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
    var previousNumber: Int = 0
    func authenticate()
    {
        
        //Check login information
        let emailAddress: String? = usernameField.text
        let password: String? = passwordField.text
        
        Auth.auth().signIn(withEmail: emailAddress!, password: password!) { [weak self] user, error in
            guard self != nil else { return }
            
            //change this to if error == nil
            if error == nil
            {
                print("User Signed in Successfully")
                
                if ((self?.rememberMeSwitch.isOn)!)
                {
                    UserDefaults.standard.set(emailAddress, forKey: "EmailAddress")
                    UserDefaults.standard.set(password, forKey: "Password")
                }
                else
                {
                    UserDefaults.standard.set("", forKey: "EmailAddress")
                    UserDefaults.standard.set("", forKey: "Password")
                }
                self!.performSegue(withIdentifier: "goHome", sender: self)
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
                let alertController = UIAlertController(title: "Email or Password Incorrect", message:
                    "Please try again", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: phrase, style: .default))
                
                self?.present(alertController, animated: true, completion: nil)
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is FifthViewController
        {
            let vc = segue.destination as? FifthViewController
            for office in offices
            {
                vc?.secondOffices.append(office)
            }
        }
    }
}

extension ViewController: FUIAuthDelegate
{
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        //Check to see if there was an error
        
        if error != nil {
            //Log the error
            return
        }
        
        //authDataResult?.user.uid
        
        performSegue(withIdentifier: "goHome", sender: self)
    }
}


