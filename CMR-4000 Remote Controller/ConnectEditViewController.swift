//
//  ConnectEditViewController.swift
//  CMR-4000 Remote Controller
//
//  Created by Ben Choi on 7/21/17.
//  Copyright © 2017 Jamin514. All rights reserved.
//

import UIKit

class ConnectEditViewController: UIViewController, UITextFieldDelegate {

    //LOCAL VARIABLES
    var name = "oo"         //Placeholder
    var ipAddress = "oo"    //Placeholder
    var port = "oo"         //Placeholder
    var deviceTableSelectedRow = 0  //Row that the user has selected.
    
    //STORYBOARD VARIABLES
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ipAddressTextField: UITextField!
    @IBOutlet weak var portTextField: UITextField!
    
    @IBOutlet weak var completeButton: UIButton!
    
    
    //OVERRIDDEN FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateTextFields()
        
        //Disable the complete button
        completeButton.isEnabled = false
        
        //Add to the target so that we can check if the user has entered values for ipAddress and port
        ipAddressTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        portTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateTextFields()
        updateCompleteButton()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Prepare the view to move to the other view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "connectionEditToConnection"
        {
            if let seg = segue.destination as? ConnectScreenViewController
            {
                
                if let newName = nameTextField.text
                {
                    
                    //Code for assigning default name if no name is assigned
                    if newName == ""
                    {
                        //"defaultDevicesCount" is a permanent storage for counting how many default named devices are on the device table
                        if let defaultDeviceNum = UserDefaults.standard.object(forKey: "defaultDevicesCount") as? Int
                        {
                            name = "CMR-4000 #\(defaultDeviceNum+1)"
                            UserDefaults.standard.set(defaultDeviceNum+1, forKey: "defaultDevicesCount")
                        }
                        else
                        {
                            name = "CMR-4000 #1"
                            UserDefaults.standard.set(1, forKey: "defaultDevicesCount")
                        }
                    }
                    else
                    {
                        name = newName
                    }
                    
                }

                name = nameTextField.text!
                ipAddress = ipAddressTextField.text!
                port = portTextField.text!
                
                seg.name = name
                seg.ipAddress = ipAddress
                seg.port = port
                seg.fromConnectionEdit = true
            }
        }
    }
    
    //When user taps outside the keyboard, the keyboard will be dismissed
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) //This will hide the keyboard
        
    }
    
    //Make status bar white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //END OF OVERRIDDEN FUNCTIONS
    
    //TEXT FIELD CHECK IF REQUIRED FIELDS ARE FILLED OUT
    //UITextField delegate method to check if the user entered values on the required text fields
    func editingChanged(_ textField: UITextField) {
        if textField.text?.characters.count == 1 {
            if textField.text?.characters.first == " " {
                textField.text = ""
                return
            }
        }
        guard
            let ipAddress = ipAddressTextField.text, !ipAddress.isEmpty,
            let port = portTextField.text, !port.isEmpty
            else {
                completeButton.isEnabled = false
                return
        }
        completeButton.isEnabled = true
    }
    
    
    //BUTTON ACTION FUNCTIONS
    //Go back to the previous view controller.
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        view.endEditing(true)   //Code for hiding the keyboard when transitioning
    }
    
    //Function that will execute when the completeButton is pressed. Add the edited device data to the table
    @IBAction func complete(_ sender: UIButton) {
        updateDeviceVariables()
        
        if var arr = UserDefaults.standard.object(forKey: "devicesArray") as? [[String]]{
            arr[deviceTableSelectedRow][0] = name
            arr[deviceTableSelectedRow][1] = ipAddress
            arr[deviceTableSelectedRow][2] = port
            
            UserDefaults.standard.set(arr, forKey: "devicesArray")
        }
        
        self.dismiss(animated: true, completion: nil)
        view.endEditing(true)
    }
    //END OF BUTTON ACTION FUNCTIONS
    
    
    //LOCAL FUNCTIONS
    //Update the textFields with the device data from the ConnectScreenViewController
    func updateTextFields (){
        nameTextField.text = name
        ipAddressTextField.text = ipAddress
        portTextField.text = port
    }
    
    //Update the local device data variables with the new data that the user has inputted
    func updateDeviceVariables() {
        if let fieldName = nameTextField.text {name = fieldName}
        if let fieldpAddress = ipAddressTextField.text {ipAddress = fieldpAddress}
        if let fieldPort = portTextField.text {port = fieldPort}
    }

    //When the view first loads, determine whether the button should be enabled or not by checking the ipAddress and the port textfield
    func updateCompleteButton(){
        if ipAddressTextField.text != "" && portTextField.text != "" {
            completeButton.isEnabled = true
        }
    }
    
}
