//
//  AddNewDeviceViewController.swift
//  CMR-4000 Remote Controller
//
//  Created by Ben Choi on 7/20/17.
//  Copyright © 2017 Jamin514. All rights reserved.
//

import UIKit

class AddNewDeviceViewController: UIViewController, UITextFieldDelegate {

    //LOCAL VARIABLES
    //Place holder for processing text views and then adding them to the tableview on DeviceSelectionViewController
    var name = ""
    var ipAddress = ""
    var port = ""
    
    //STORYBOARD VARIABLES
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ipAddressTextField: UITextField!
    @IBOutlet weak var portTextField: UITextField!
    @IBOutlet weak var completeButton: UIButton!
    
    
    //OVERRIDDEN FUNCTIONS
    //Systematic Overridden functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.nameTextField.becomeFirstResponder()   //Make the keyboard pop up when the view loads
    
        //Disable the complete button
        completeButton.isEnabled = false
        
        ipAddressTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        portTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Disable the complete button
        completeButton.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }//End of systematic overriden functions
    
    
    //Make status bar white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    //When user taps outside the keyboard, the keyboard will be dismissed
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) //This will hide the keyboard

    }
    
    
    //Prepare the view to move to the other view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addToSelection"
        {
            if let seg = segue.destination as? DeviceSelectionViewController
            {
                seg.fromAddNewDevice = true
            }
        }
    }
    //END OF OVERRIDDEN FUNCTIONS
    
    
    //TEXTFIELD FUNCTION
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
    //END OF TEXTFIELD FUNCTION
    
    //BUTTON ACTION FUNCTION
    //Action that will be performed when the "+" button is pressed
    @IBAction func addNewDevice(_ sender: UIButton) {
        var tempArr = [String]()
        var temp2DArr = [[String]]()
        
        if let newName = nameTextField.text
        {
            if newName == ""
            {
                name = "CMR-4000"
            }
            else
            {
                name = newName
            }
            
            tempArr.append(name)
        }
        
        //get IP Address from the ipAddressTextField and then append to the temporary array
        if let newIpAddress = ipAddressTextField.text
        {
            ipAddress = newIpAddress
            tempArr.append(ipAddress)
        }
        
        if let newPort = portTextField.text
        {
            port = newPort
            tempArr.append(port)
        }
        
        
        if let devicesArray = UserDefaults.standard.object(forKey: "devicesArray") as? [[String]]
        {
            temp2DArr = devicesArray
            temp2DArr.append(tempArr)
            UserDefaults.standard.set(temp2DArr, forKey: "devicesArray")
        }
        else
        {
            temp2DArr.append(tempArr)
            UserDefaults.standard.set(temp2DArr, forKey: "devicesArray")
        }
        
        view.endEditing(true)        
    }
    
    //Performed when the back button is pressed. Return to the previous screen when pressed.
    @IBAction func cancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        view.endEditing(true)
    }
    //END OF BUTTON ACTION FUNCTIONS
    
    
}
