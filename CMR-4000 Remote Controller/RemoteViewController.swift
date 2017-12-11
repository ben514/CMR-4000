//
//  RemoteViewController.swift
//  CMR-4000 Remote Controller
//
//  Created by Ben Choi on 7/20/17.
//  Copyright © 2017 Jamin514. All rights reserved.
//

import UIKit

class RemoteViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    //LOCAL VARIABLES
    var ipAddress = ""  //placeholder
    var port = 0000     //placeholder
    var playing = false //determine whether the play button is in playing mode
    
    //STORYBOARD VARIABLES
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var recordPauseButton: UIButton!
    @IBOutlet weak var displayButton: UIButton!
    @IBOutlet weak var threeDimensionalButton: UIButton!
    @IBOutlet weak var studyButton: UIButton!
    @IBOutlet weak var newPatientButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var backToDeviceSelectionButton: UIButton!
    
    //SOCKETMODEL
    var model = SocketModel()   //Initialize the socket model
    
    
    //OVERRIDDEN FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()

        model.setClient(address: ipAddress, port: port) //The client is set to whatever the connect screen was displaying
        
        
        //Set images to the corresponding images when the button is pressed
        menuButton.setImage(UIImage(named: "menu_down.png"), for: .highlighted)
        stopButton.setImage(UIImage(named: "stop_down.png"), for: .highlighted)
        playButton.setImage(UIImage(named: "play_down.png"), for: .highlighted)
        recordPauseButton.setImage(UIImage(named: "rec-pause_down.png"), for: .highlighted)
        captureButton.setImage(UIImage(named: "capture_down.png"), for: .highlighted)
        backButton.setImage(UIImage(named: "back_down.png"), for: .highlighted)
        displayButton.setImage(UIImage(named: "display_down.png"), for: .highlighted)
        threeDimensionalButton.setImage(UIImage(named: "3d_down.png"), for: .highlighted)
        studyButton.setImage(UIImage(named: "study_down.png"), for: .highlighted)
        newPatientButton.setImage(UIImage(named: "new-patient_down.png"), for: .highlighted)
        leftButton.setImage(UIImage(named: "left-button_down.png"), for: .highlighted)
        enterButton.setImage(UIImage(named: "enter_down.png"), for: .highlighted)
        rightButton.setImage(UIImage(named: "right-button_down.png"), for: .highlighted)
        upButton.setImage(UIImage(named: "up-button_down.png"), for: .highlighted)
        downButton.setImage(UIImage(named: "down-button_down.png"), for: .highlighted)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Make status bar white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    //END OF OVERRIDDEN FUNCTIONS
    
    
    //BUTTON ACTION FUNCTIONS
    //Dismiss and return to the previous view
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //executes when any of the button is pressed
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        //Adding delays to the button press. Stay longer on the highligted image
        switch sender.accessibilityLabel!{
        case "20":
            menuButton.setImage(UIImage(named: "menu_down.png"), for: .normal)
        case "21":
            if !playing
            {
                leftButton.setImage(UIImage(named: "left-button_down.png"), for: .normal)
            }
            else
            {
                leftButton.setImage(UIImage(named: "pre-button_down.png"), for: .normal)
            }
        case "22":
            upButton.setImage(UIImage(named: "up-button_down.png"), for: .normal)
        case "23":
            enterButton.setImage(UIImage(named: "enter_down.png"), for: .normal)
        case "24":
            downButton.setImage(UIImage(named: "down-button_down.png"), for: .normal)
        case "25":
            backButton.setImage(UIImage(named: "back_down.png"), for: .normal)
        case "26":
            if !playing
            {
                rightButton.setImage(UIImage(named: "right-button_down.png"), for: .normal)
            }
            else
            {
                rightButton.setImage(UIImage(named: "next-button_down.png"), for: .normal)
            }
        case "27":
            stopButton.setImage(UIImage(named: "stop_down.png"), for: .normal)
        case "28":
            if !playing
            {
                playButton.setImage(UIImage(named: "play_down.png"), for: .normal)
                
                leftButton.setImage(UIImage(named: "pre-button_up.png"), for: .normal)
                leftButton.setImage(UIImage(named: "pre-button_down.png"), for: .highlighted)
                
                rightButton.setImage(UIImage(named: "next-button_up.png"), for: .normal)
                rightButton.setImage(UIImage(named: "next-button_down.png"), for: .highlighted)
                
                playing = true
            }
            else
            {
                playButton.setImage(UIImage(named: "play_up.png"), for: .normal)
                
                leftButton.setImage(UIImage(named: "left-button_up.png"), for: .normal)
                leftButton.setImage(UIImage(named: "left-button_down.png"), for: .highlighted)
                
                rightButton.setImage(UIImage(named: "right-button_up.png"), for: .normal)
                rightButton.setImage(UIImage(named: "right-button_down.png"), for: .highlighted)
                
                playing = false
            }
        case "29":
            recordPauseButton.setImage(UIImage(named: "rec-pause_down.png"), for: .normal)
        case "30":
            captureButton.setImage(UIImage(named: "capture_down.png"), for: .normal)
        case "31":
            newPatientButton.setImage(UIImage(named: "new-patient_down.png"), for: .normal)
        case "32":
            displayButton.setImage(UIImage(named: "display_down.png"), for: .normal)
        case "34":
            threeDimensionalButton.setImage(UIImage(named: "3d_down.png"), for: .normal)
        case "35":
            studyButton.setImage(UIImage(named: "study_down.png"), for: .normal)
        default:
            break
        }
        
        //Make MICOM Packet, and then send it as an array of Bytes
        if let client = model.getClient()
        {
            var micom_packet_array: [Character]
            
            if let label = sender.accessibilityLabel {
                
                if let label_int = Int(label) {
                    if let label_uni = UnicodeScalar(label_int) {
                        
                        micom_packet_array = model.make_MICOMPkt(check_mode: 3, FrontButtonNumberUni: label_uni, data_len: 3)
                        
                        let element_int1 = Byte(Int( UnicodeScalar( String(micom_packet_array[0]) )!.value ))
                        let element_int2 = Byte(Int( UnicodeScalar( String(micom_packet_array[3]) )!.value ))

                        client.send(data: [element_int1, element_int2, 0])
                        
                    }
                }
            }
        }
        
        //Adding delays to the button press. 0.3 second delay on the button pressed image
        let when = DispatchTime.now() + 0.3 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            switch sender.accessibilityLabel!{
            case "20":
                self.menuButton.setImage(UIImage(named: "menu_up.png"), for: .normal)
            case "21":
                if !self.playing
                {
                    self.leftButton.setImage(UIImage(named: "left-button_up.png"), for: .normal)
                }
                else
                {
                    self.leftButton.setImage(UIImage(named: "pre-button_up.png"), for: .normal)
                }
            case "22":
                self.upButton.setImage(UIImage(named: "up-button_up.png"), for: .normal)
            case "23":
                self.enterButton.setImage(UIImage(named: "enter_up.png"), for: .normal)
            case "24":
                self.downButton.setImage(UIImage(named: "down-button_up.png"), for: .normal)
            case "25":
                self.backButton.setImage(UIImage(named: "back_up.png"), for: .normal)
            case "26":
                if !self.playing
                {
                    self.rightButton.setImage(UIImage(named: "right-button_up.png"), for: .normal)
                }
                else
                {
                    self.rightButton.setImage(UIImage(named: "next-button_up.png"), for: .normal)
                }
            case "27":
                self.stopButton.setImage(UIImage(named: "stop_up.png"), for: .normal)
            case "29":
                self.recordPauseButton.setImage(UIImage(named: "rec-pause_up.png"), for: .normal)
            case "30":
                self.captureButton.setImage(UIImage(named: "capture_up.png"), for: .normal)
            case "31":
                self.newPatientButton.setImage(UIImage(named: "new-patient_up.png"), for: .normal)
            case "32":
                self.displayButton.setImage(UIImage(named: "display_up.png"), for: .normal)
            case "34":
                self.threeDimensionalButton.setImage(UIImage(named: "3d_up.png"), for: .normal)
            case "35":
                self.studyButton.setImage(UIImage(named: "study_up.png"), for: .normal)
            default:
                break
            }
        }
    }
    
    //END OF BUTTON ACTION FUNCTIONS
    
    
}
