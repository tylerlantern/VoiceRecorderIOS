//
//  HomeViewModel.swift
//  VoiceRecorder
//
//  Created by Nattapong Unaregul on 08/01/2020.
//  Copyright © 2020 Nattapong Unaregul. All rights reserved.
//

import Foundation
import AVFoundation


public class HomeViewModel : NSObject  {
//  @Published public var audioFiles : [AudioFile] = [AudioFile(name: "test1", url: URL(string: "http://techslides.com/demos/sample-videos/small.mp4")),AudioFile(name: "test2", url: URL(string: "http://techslides.com/demos/sample-videos/small.mp4")) ]
  
  @Published public var audioFiles : [AudioFile] = []
  
  var player : AVAudioPlayer?
  enum AudioActionError : Error {
    case unableToRecord
    ,unableToPlayAudio
  }
  
  let recordingSession = AVAudioSession.sharedInstance()
  var audioRecorder : AVAudioRecorder?
  var isRecording : Bool = false
  
  lazy var setupAudioSession : (_ onError : (Error) -> () ) -> Void  = { onError in
    do {
      try self.recordingSession.setCategory(.playAndRecord)
      try self.recordingSession.setActive(true)
      try self.recordingSession.overrideOutputAudioPort(.speaker)
      self.recordingSession.requestRecordPermission() { [unowned self] allowed in
        DispatchQueue.main.async {
          if allowed {
            // Allow
          } else {
            // failed to record!
            print("fail to record")
          }
        }
      }
    }catch(let error) {
      self.isRecording = false
      onError(error)
    }
  }
  
  func play(url : URL,onError : ((Error)-> Void)?) {
    do {
      player = try AVAudioPlayer(contentsOf: url)
      player?.prepareToPlay()
      let isAbleToPlay = player?.play()
      print("isAbleToPlay:\(isAbleToPlay)")
    }catch(let error) {
      print(error)
      onError?(error)
    }
  }
  
  func stop() {
    player?.stop()
  }
  
  func saveFileToStorage(url : URL) {
    
  }
  
  func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }
  
  func startRecording(onError : ((Error) -> Void)?) {
    isRecording = true
    
    let audioFilename = getDocumentsDirectory().appendingPathComponent("\(self.audioFiles.count + 1).m4a")
    
    let settings = [
      AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
      AVSampleRateKey: 12000,
      AVNumberOfChannelsKey: 1,
      AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]
    
    do {
      audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
      audioRecorder?.delegate = self
      audioRecorder?.record()
    } catch {
      onError?(AudioActionError.unableToRecord)
      finishRecording()
    }
  }
  
  func finishRecording() {
    audioRecorder?.stop()
    audioRecorder = nil
  }
  
}

extension HomeViewModel : AVAudioRecorderDelegate {
  
  public func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    print(recorder.url)
    audioFiles.append(AudioFile(name: "\(audioFiles.count + 1)", url: recorder.url))
    finishRecording()
  }
  
}
