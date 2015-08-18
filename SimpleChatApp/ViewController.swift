//
//  ViewController.swift
//  SimpleChatApp
//
//  Created by Toph on 8/11/15.
//  Copyright (c) 2015 Toph. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messageTableView: UITableView!
    
    @IBOutlet weak var dockViewHeight: NSLayoutConstraint!
    
    var messagesArray:[String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.messageTableView.delegate = self
        self.messageTableView.dataSource = self
        
        // Set self as delegate for text field
        self.messageTextField.delegate = self
        
        // Add a tap gesture recognizer to table view
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tableViewTapped")
        self.messageTableView.addGestureRecognizer(tapGesture)
        
        // Retrieve messages from Parse
        self.retrieveMessages()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func sendButtonTapped(sender: AnyObject) {
        
        // Send button is tapped
        
        // Call the end editing method for the text field
        self.messageTextField.endEditing(true)
        
        // Disable the send button and textField
        self.messageTextField.enabled = false
        self.sendButton.enabled = false
        
        // Create a PFObject
        var newMessageObject:PFObject = PFObject(className: "Message")
        
        
        // Set the text key to the text of the message text field
        newMessageObject["Text"] = self.messageTextField.text
        
        // Save the PFObject
        newMessageObject.saveInBackgroundWithBlock { (success:Bool, error:NSError?) -> Void in
            
            if (success == true){
                // Message has been saved! YAY
                // To do: Retrieve the latest messages and reload the table
                self.retrieveMessages()
                NSLog("saved")
            }
            else{
                // Something bad happened
                NSLog(error!.description)
            }
            
            dispatch_async(dispatch_get_main_queue()){
            
            // Enable the textfield and send button
            self.messageTextField.enabled = true
            self.sendButton.enabled = true
            self.messageTextField.text = ""
            }
            
        }
    }
    
    func retrieveMessages() {
        
        // Create a new PFQuery
        var query:PFQuery = PFQuery(className: "Message")
        
        // Call findobjectsinbackground
        query.findObjectsInBackgroundWithBlock { (objects:[AnyObject]?, error:NSError?) -> Void in
            
            // Clear the messages array
            self.messagesArray = [String]()
            
            // Loop through the objects array
            for messageObject in objects! {
                
                // Retrieve the text column value of each PFObject
                let messageText:String? = (messageObject as! PFObject)["Text"] as? String
                
                // Assign it into our messages array
                if messageText != nil {
                    self.messagesArray.append(messageText!)
                }
                
            }
            dispatch_async(dispatch_get_main_queue()){
                // Reload the tableview
                self.messageTableView.reloadData()
            }
        }
    }
    
    func tableViewTapped() {
        
        // Force the textfield to end editing
        self.messageTextField.endEditing(true)
    }
    
    // MARK: TextField Delegate Methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Perform an animation to grow the dock view
        self.view.layoutIfNeeded()
        UIView.animateWithDuration(0.5, animations: {
            
            self.dockViewHeight.constant = 350
            self.view.layoutIfNeeded()
            
            
            }, completion: nil)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        // Perform an animation to shrink the dock view
        self.view.layoutIfNeeded()
        UIView.animateWithDuration(0.5, animations: {
            
            self.dockViewHeight.constant = 60
            self.view.layoutIfNeeded()
            
            
            }, completion: nil)
    }
    
    // MARK: TableView Delegate Methods
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Create a table cell
        let cell = self.messageTableView.dequeueReusableCellWithIdentifier("MessageCell") as! UITableViewCell
        
        // Customize the cell
        cell.textLabel?.text = self.messagesArray[indexPath.row]
        
        // Return the cell
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messagesArray.count
        
    }
    
    


}

