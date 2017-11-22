//
//  ViewController.swift
//  voiceRecognition
//
//  Created by Andres on 12/11/17.
//  Copyright © 2017 Andres. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController, AVAudioRecorderDelegate {


    @IBOutlet var txtTime: UILabel!
    @IBOutlet var textView: UITextView!
    @IBOutlet var timeSlider: UISlider!
    @IBOutlet var txtTimeLeft: UILabel!
    var audioRecordingSession : AVAudioSession!
    var audioRecorder : AVAudioRecorder!
    let audioFileName: String = "audio-recordered.m4a"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        timeSlider.addTarget(self, action:  #selector(onTimeChanged), for: .valueChanged)
        //recognizeSpeech()
        txtTime.text = String(timeSlider.value)
        txtTimeLeft.text = String(timeSlider.value)		
    }
    @IBAction func onTimeChanged(_ sender: Any) {
        txtTime.text = String(timeSlider.value)
        txtTimeLeft.text = String(timeSlider.value)
    }
    @IBAction func startRecording(_ sender: Any) {
        recordingAudioSetup()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func recognizeSpeech(){
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            if authStatus == SFSpeechRecognizerAuthorizationStatus.authorized{
                let recognizer = SFSpeechRecognizer()
                let request = SFSpeechURLRecognitionRequest(url: self.directoryURL()!)
                recognizer?.recognitionTask(with: request, resultHandler: { (recognitionResult, recognitionError) in
                    if let error = recognitionError {
                        print("Fallò \(error.localizedDescription)")
                    }
                    else{
                        self.textView.text = recognitionResult?.bestTranscription.formattedString
                    }
                })
            }else{
                
            }
        }
    }
    
    func recordingAudioSetup(){
        audioRecordingSession = AVAudioSession.sharedInstance()
        
        do{
           try audioRecordingSession.setCategory(AVAudioSessionCategoryRecord)
            try audioRecordingSession.setActive(true)
            
            audioRecordingSession.requestRecordPermission({[unowned self](result) in
                if result {
                    //INICIA EL PROCESO DE GRABACION
                    self.startRecording()
                }
                else{
                    print("No se otorgaron permisos")
                }
            })
        }
        catch{
            print("Ocurrió un error ")
        }
    }
    func directoryURL() -> URL?{
        
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as URL
        do{
            return try documentDirectory.appendingPathComponent(audioFileName) as URL
        }
        catch{
            print("Error al crear la carpeta del audio")
        }
        return nil

    }
    func startRecording(){
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector:#selector(self.timeRemaining), userInfo: nil, repeats: true)
        let settings = [AVFormatIDKey :Int(kAudioFormatMPEG4AAC),
                        AVSampleRateKey:12000.0,
                        AVNumberOfChannelsKey:1 as NSNumber,
                        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue] as [String : Any]
        
        do{
            audioRecorder = try AVAudioRecorder(url: directoryURL()!, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            let interval = Double(txtTime.text!)
            Timer.scheduledTimer(timeInterval: interval!, target: self, selector:#selector(self.stopRecording), userInfo: nil, repeats: false)
        }catch{
            print("No se pudo grabar el audio correctamente")
        }
    }
    @objc func timeRemaining(){
        txtTimeLeft.text = String(Int(txtTimeLeft.text!)! - 1)
    }
    @objc func stopRecording(){
        audioRecorder.stop()
        audioRecorder = nil
       Timer.scheduledTimer(timeInterval: 1, target: self, selector:#selector(self.recognizeSpeech), userInfo: nil, repeats: false)
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}

