//
//  ConnectScreenViewController.swift
//  CMR-4000 Remote Controller
//
//  Created by Ben Choi on 7/20/17.
//  Copyright © 2017 Jamin514. All rights reserved.
//

import UIKit

class ConnectScreenViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    //LOCAL VARIABLES
    let transition = CircularTransition() //Variable for using the custom circular transition
    
    var name = "1st Floor Office Left Corner"   //Placeholder
    var ipAddress = "192.168.10.225"            //Placeholder
    var port = "7777"                           //Placeholder
    var fromConnectionEdit = false              //Indicate if user has returned from the Connection Edit Window to detect if the device information was mutated
    var deviceTableSelectedRow = 0              //The row that was selected. This will decrease the amount of workload CPU will need to do, because we already know which was selected
    //END OF LOCAL VARIABLES
    
    
    //STORYBOARD VARIALBES
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ipAddressLabel: UILabel!
    @IBOutlet weak var portLabel: UILabel!
    @IBOutlet weak var connectButton: UIButton!
    //END OF STORYBOARD VARIABLES
    
    
    //OVERRIDDEN FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()

        updateLabels()  //Update the labels to the current data
        connectButton.layer.cornerRadius = connectButton.frame.size.width / 8       //Make the button rounded
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Function that will prepare and transfer data to the View Controller that will be executed when user presses a button
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? RemoteViewController {
            //Make the circular transition enabled
            vc.transitioningDelegate = self
            vc.modalPresentationStyle = .custom
            
            //Give ipAddress and port to the remoteViewController
            vc.ipAddress = ipAddress
            vc.port = Int(port)!
        }
        else if let vc = segue.destination as? ConnectEditViewController {
            vc.name = name
            vc.ipAddress = ipAddress
            vc.port = port
            vc.deviceTableSelectedRow = deviceTableSelectedRow
        }
    }
    //END OF OVERRIDDEN FUNCTIONS
    
    
    //CUSTOM TRANSITION FUNCTIONS
    //set the transition animation to the custom circulat transition. Present mode
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = connectButton.center
        transition.circleColor = connectButton.backgroundColor!
        
        return transition
    }
    
    //The transition animation. Dismissed mode; returning from the already executed transitioned view controller
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = connectButton.center
        transition.circleColor = connectButton.backgroundColor!
        
        return transition
    }
    //END OF CUSTOM TRANSITION FUNCTIONS

    
    //Make status bar white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //BUTTON ACTION FUNCTIONS
    //Go back to the previous view controller
    @IBAction func cancl(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    //END OF BUTTON ACTION FUNCTIONS
    
    
    //LOCAL FUNCTION
    //Update the labels
    func updateLabels () {
        if let tempArray = UserDefaults.standard.object(forKey: "devicesArray") as? [[String]]{
            name = tempArray[deviceTableSelectedRow][0]
            ipAddress = tempArray[deviceTableSelectedRow][1]
            port = tempArray[deviceTableSelectedRow][2]
        }
        
        nameLabel.text = name
        ipAddressLabel.text = ipAddress
        portLabel.text = port
    }
    //END OF LOCAL FUNCTION
    
}
