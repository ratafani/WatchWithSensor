//
//  InterfaceController.swift
//  watchTry WatchKit Extension
//
//  Created by Muhammad Tafani Rabbani on 11/10/20.
//

import WatchKit
import AVFoundation
import Foundation


extension FileManager{
    func getDocumentDirectorycustom() -> URL{
        let paths = urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

class InterfaceController: WKInterfaceController {

    var audioPlayer : AVAudioPlayer?
    let pathURL : URL = FileManager.default.getDocumentDirectorycustom().appendingPathComponent("1.wav")
    
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }

    @IBAction func recordSound() {
        print("Try Record")
        presentAudioRecorderController(withOutputURL: pathURL, preset: .highQualityAudio) {
            success, error in
            if success{
                print("success recording")
            }else{
                print("Something has happened and error",error)
            }
        }
        
    }
    @IBAction func PlaySound() {
        guard FileManager.default.fileExists(atPath: pathURL.path) else {return}
        
        try? audioPlayer = AVAudioPlayer(contentsOf: pathURL)
        audioPlayer?.play()
        
    }
}


