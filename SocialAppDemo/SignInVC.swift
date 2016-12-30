//
//  SigninVC.swift
//  SocialAppDemo
//
//  Created by Andrienne Liew on 30/12/2016.
//  Copyright © 2016 AppDeck. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase

class SigninVC: UIViewController {
    

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func facebookButtonTapped(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            
            if error != nil {
                
                print("MWAILOON: Unable to authenticate with Facebook - \(error)")
                
            } else if result?.isCancelled == true {
                
                print("MWAILOON: User cancelled Facebook authentication")
                
            } else {
                
                print("MWAILOON: Successfully authenticated with Facebook")
                
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
                self.firebaseAuth(credential)
                
            }
            
        }
        
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            
            if error != nil {
                
                print("MWAILOON: Unable to authenticate with Firebase - \(error)")
                
            } else {
                
                print("MWAILOON: Sucessfully authenticated with Firebase")
                
            }
            
        })
        
        
    }
    
    


    @IBAction func SigninTapped(_ sender: FancyButton) {
        
        if let email = emailTextField.text , let password = passwordTextField.text {
            
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                
                if error == nil {
                    
                    print("MWAILOON: Email user successfully signed in Firebase")
                    
                } else {
                    
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        
                        if error != nil {
                            
                            print("MWAILOON: Unable to authenticate with Firebase using email - \(error)")
                            
                        } else {
                            
                            print("MWAILOON: Email user successfully authenticated with Firebase")
                            
                        }
                        
                    })
                    
                }
                
            })
            
        }
    }



}

