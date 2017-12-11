//
//  DeviceSelectionViewController.swift
//  CMR-4000 Remote Controller
//
//  Created by Ben Choi on 7/20/17.
//  Copyright © 2017 Jamin514. All rights reserved.
//

import UIKit

class DeviceSelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //STORYBOARD VARIABLES
    
    //Connection from the storyboard to connect the table view to the view controller
    @IBOutlet weak var deviceTable: UITableView!
    @IBOutlet weak var editButton: UIButton!
    //END OF STORYBOARD VARIABLES
    
    //LOCAL VARIABLES
    //Data that will be used to display the selected devices
    var data = [[String]]()
    var selectedData = [String]() //[0] = name, [1] = ip address, [2] = port
    
    //boolean for checking if coming back from AddNewDeviceViewController
    var fromAddNewDevice = false
    
    //Record the row of the deviceTable that needs to be deselected
    var deviceTableSelectedRow = 0
    
    var sortType = 0 //Different sort types for the device table. 0 = name alphabetical
    //END OF LOCAL VARIABLES
    
    
    //OVERRIDDEN FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deviceTable.delegate = self
        deviceTable.dataSource = self
        
        //Load previous saved devices if they exist
        getDevicesArray()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getDevicesArray()
        if (fromAddNewDevice) {
            addData()
        }

        let indexPath = IndexPath(row: deviceTableSelectedRow, section: 0)
        deviceTable.deselectRow(at: indexPath, animated: false) //Deselect the row that was selected when the user backs out to the device selection window
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectionToConnect"
        {
            if let seg = segue.destination as? ConnectScreenViewController
            {
                seg.name = selectedData[0]
                seg.ipAddress = selectedData[1]
                seg.port = selectedData[2]
                seg.deviceTableSelectedRow = deviceTableSelectedRow
            }
        }
    }
    
    
    //Make status bar white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    //END OF OVERRIDDEN FUNCTIONS
    
    
    
    //TABLE VIEW FUNCTIONS
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //How many rows of table should the table make
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    //What the titles of the cells should display
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row][0]
        
        return cell
    }
    
    //Determine which cell was selected by the user
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        selectedData = data[indexPath.row]
        deviceTableSelectedRow = indexPath.row
    }
    
    //When certain action is performed, this function is executed
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        //When the user is deleting the cell, remove the cell with a smooth animation.
        if editingStyle == UITableViewCellEditingStyle.delete
        {
            
            data.remove(at: indexPath.row)
            
            deviceTable.beginUpdates()
            deviceTable.deleteRows(at: [indexPath], with: .automatic)
            deviceTable.endUpdates()
            
            UserDefaults.standard.set(data, forKey: "devicesArray")
            
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    //END OF TABLEVIEW FUNCTIONS
    
    
    
    //BUTTON ACTION FUNCTIONS
    
    //Perform the segue to the AddNewDevice View controller
    @IBAction func addNewDevice(_ sender: UIButton) {
        performSegue(withIdentifier: "selectionToAdd", sender: self)
    }
    
    
    //When the user is editing, the tableView enters the editing mode
    @IBAction func editDeviceTable(_ sender: UIButton) {
        if(!deviceTable.isEditing) {
            deviceTable.isEditing = true
            editButton.setTitle("Done", for: .normal)
        }
        else {
            deviceTable.isEditing = false
            editButton.setTitle("Edit", for: .normal)
        }
    }//END OF BUTTON ACTION FUNCTIONS
    
    
    
    //LOCAL FUNCTIONS
    
    //Function for inserting rows to the table view
    func getDevicesArray () {
        if let devices = UserDefaults.standard.object(forKey: "devicesArray") as? [[String]]
        {
                data = devices
        }
        data = sortArrayAlphabetically()
        deviceTable.reloadData()
    }

    //When adding data, add it to the table view and perform the corresponding animation
    func addData() {
        if let devices = UserDefaults.standard.object(forKey: "devicesArray") as? [[String]]
        {
            //Perform the insertion animation if the devices expanded
            if (devices.count-1 == data.count)
            {
                data.append(devices[devices.count-1])
                let index = IndexPath(row: data.count-1, section: 0)
                
                deviceTable.beginUpdates()
                deviceTable.insertRows(at: [index], with: .automatic)
                deviceTable.endUpdates()
                
                fromAddNewDevice = false
            }
        }
    }
    
    //Sort the devices array alphabetically
    func sortArrayAlphabetically() -> [[String]]{
        return data.sorted() {$0[0] < $1[0]}
    }

}
