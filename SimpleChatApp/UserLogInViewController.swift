//
//  UserLogInViewController.swift
//  SimpleChatApp
//
//  Created by Toph on 8/18/15.
//  Copyright (c) 2015 Toph. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class UserLogInViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    
    // Variables
    var logInViewController:PFLogInViewController! = PFLogInViewController()
    var signUpViewController:PFSignUpViewController! = PFSignUpViewController()
    
    // Login Button label
    @IBOutlet weak var loginButtonLabel: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        PFUser.currentUser()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        if (PFUser.currentUser() == nil){
            
            self.logInViewController.fields = PFLogInFields.UsernameAndPassword | PFLogInFields.LogInButton | PFLogInFields.SignUpButton | PFLogInFields.PasswordForgotten | PFLogInFields.DismissButton
            
            // Change default Parse logo in login title
            var logInLogoTitle = UILabel()
            logInLogoTitle.text = "Gnarnian Graveyard"
            
            self.logInViewController.logInView!.logo = logInLogoTitle
            
            self.logInViewController.delegate = self
            
            // Change default Parse logo in sign up title
            var signUpLogoTitle = UILabel()
            signUpLogoTitle.text = "Gnarnian Graveyard"
            
            self.signUpViewController.signUpView!.logo = signUpLogoTitle
            
            self.signUpViewController.delegate = self
            
            self.logInViewController.signUpController = self.signUpViewController
            
            loginButtonLabel.layoutIfNeeded()
            signUpLogoTitle.layoutIfNeeded()
        }
        else{
            loginButtonLabel.layoutIfNeeded()
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Parse Login Delegate Methods
    
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        
        if(!username.isEmpty || !password.isEmpty) {
            return true
        }
        else {
            return false
        }
        
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        // Segue to table view
        self.performSegueWithIdentifier("login", sender: self)
        
        loginButtonLabel.setTitle("Login", forState: .Normal)
        loginButtonLabel.layoutIfNeeded()
        

    }
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        println("Failed to login")
    }
    
    
    // MARK: Parse Sign Up Delegate Methods
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        println("Failed to sign up...")
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
        println("User dismissed sign up.")
    }
    

    
    // MARK: Actions
    
    @IBAction func simpleAction(sender: AnyObject){
        
        if(PFUser.currentUser() == nil){
            self.presentViewController(self.logInViewController, animated: true, completion: nil)
        }
        else{
            loginButtonLabel.setTitle("To chat wall", forState: .Normal)
            loginButtonLabel.layoutIfNeeded()
            self.performSegueWithIdentifier("login", sender: self)
            
        }
        
    }
    
    @IBAction func logoutAction(sender: AnyObject) {
        PFUser.logOut()
        loginButtonLabel.setTitle("Login", forState: .Normal)
        loginButtonLabel.layoutIfNeeded()
    }
    
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}