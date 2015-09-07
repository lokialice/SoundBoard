//
//  NewSoundViewController.swift
//  SoundBoard
//
//  Created by Macbook Pro MD102 on 8/21/15.
//  Copyright (c) 2015 Loki. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class NewSoundViewController:UIViewController {

    required init(coder aDecoder: NSCoder) {
        var baseString:String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as! String
        self.audioURL = NSUUID().UUIDString + ".m4a"
        
        var pathComponents = [baseString,self.audioURL]
        var audioNSURL = NSURL.fileURLWithPathComponents(pathComponents)!
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        var recordSettings:[NSObject:AnyObject] = Dictionary()
        recordSettings[AVFormatIDKey] = kAudioFormatMPEG4AAC
        recordSettings[AVSampleRateKey] = 44100.0
        recordSettings[AVNumberOfChannelsKey] = 2
        
        self.audioRecorder = AVAudioRecorder(URL: audioNSURL, settings: recordSettings, error: nil)
        self.audioRecorder.meteringEnabled = true
        self.audioRecorder.prepareToRecord()
        //Super init is below
        super.init(coder: aDecoder)
    }
    
    @IBOutlet var txtName: UITextField!
    
    @IBOutlet var recordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Roll tide...
    }
    var soundListViewController = SoundListViewController()
    var audioRecorder:AVAudioRecorder
    var audioURL:String
    @IBAction func cancelTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func saveTapped(sender: UIBarButtonItem) {
        var context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
        
        //Create a sound object
        var sound = NSEntityDescription.insertNewObjectForEntityForName("Sound", inManagedObjectContext: context) as! Sound
        sound.name = self.txtName.text
        sound.url = self.audioURL
       //Save soudn to CoreData
       context.save(nil)
        
        //Dismiss ViewController
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func recordTapped(sender: UIButton) {
        if self.audioRecorder.recording {
            self.audioRecorder.stop()
            self.recordButton.setTitle("RECORD", forState: UIControlState.Normal)
        }else {
            var session = AVAudioSession.sharedInstance()
            session.setActive(true, error: nil)
            self.audioRecorder.record()
            self.recordButton.setTitle("Finish Recording", forState: UIControlState.Normal)
        }
        
        
    }
    
    
}