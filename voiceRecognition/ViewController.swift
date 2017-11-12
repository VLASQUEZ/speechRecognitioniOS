//
//  ViewController.swift
//  voiceRecognition
//
//  Created by Andres on 12/11/17.
//  Copyright © 2017 Andres. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController {

    @IBOutlet var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        recognizeSpeech()
    
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func recognizeSpeech(){
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            if authStatus == SFSpeechRecognizerAuthorizationStatus.authorized{
                if let path = Bundle.main.url(forResource: "audio", withExtension: "mp3"){
                    let recognizer = SFSpeechRecognizer()
                    let request = SFSpeechURLRecognitionRequest(url: path)
                    
                    recognizer?.recognitionTask(with: request, resultHandler: { (recognitionResult, recognitionError) in
                        if let error = recognitionError {
                            print("Fallò \(error.localizedDescription)")
                        }
                        else{
                            self.textView.text = recognitionResult?.bestTranscription.formattedString
                        }
                    })
                }
                
                
            }else{
                
            }
        }
    }

}

