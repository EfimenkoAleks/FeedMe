/// Copyright (c) 2019 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import AVFoundation
import CallKit

enum CallState {
  case Disconnected
  case Dialing
  case Incoming
  case Connected
//  case Failed
}


protocol AudioSessionDelegate: class {
 
  func callObserver(state: CallState)
}

class AudioSessionMng: NSObject {
  //MARK: Variables
  private var audioSession = AVAudioSession.sharedInstance()
  var delegate: AudioSessionDelegate?
//  var currentCategory: String {
//    get {
//      return audioSession.category.rawValue
//    }
//  }
  var callObserver: CXCallObserver?
  
  //MARK:- Methods
  init(delegate: AudioSessionDelegate?) {
    super.init()
    
    self.delegate = delegate
 //   self.setupAVAudioSessionRouteChange()
    if delegate != nil {
      callObserver = CXCallObserver()
      callObserver?.setDelegate(self, queue: nil)
    }
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  //MARK: - Audio Session Setups
  public func setupAudioSessionToPlayback() {
//    do {
//      try audioSession.setCategory(AVAudioSession.Category.playback, with: [Any])
//      try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
//      UIApplication.shared.beginReceivingRemoteControlEvents()
//      setupAVAudioSessionInterruptionObserver()
//      print("AudioSessionMng: ToPlayback")
//    } catch let error {
//      print("AudioSessionMng: setupAudioSessionToPlayback Error. Description: \(error.localizedDescription)")
//      setupAudioSessionToSilencePlayback()
//    }
    
//    let audioSesion = AVAudioSession.sharedInstance()
    
//          do {
////            try audioSession.setCategory(AVAudioSession.Category.playback)
//            try audioSession.setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: [.mixWithOthers, .duckOthers])
//            try audioSession.setActive(true, options: AVAudioSession.SetActiveOptions.notifyOthersOnDeactivation)
//            UIApplication.shared.beginReceivingRemoteControlEvents()
//          }
//          catch {
//            print(error)
//          }
    
    do {
      try audioSession.setCategory(AVAudioSession.Category.playback)
      try audioSession.setCategory(.playback, options: [.mixWithOthers])
      try audioSession.setActive(true, options: [])
    }
    catch {
      print(error)
    }
  }
  
//  public func setupAudioSessionToSilencePlayback() {
//    do {
//      try audioSession.setCategory(AVAudioSessionCategoryPlayback, mode: AVAudioSessionModeDefault, options: [.mixWithOthers, .duckOthers])
//      try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
//      UIApplication.shared.beginReceivingRemoteControlEvents()
//      setupAVAudioSessionInterruptionObserver()
//      print("AudioSessionMng: ToSilencePlayback")
//    } catch let error {
//      print("AudioSessionMng: setupAudioSessionToSilencePlayback Error. Description: \(error.localizedDescription)")
//    }
//  }
  
  public func setupAudioSessionToDefault() {
    do {
      try audioSession.setCategory(AVAudioSession.Category.soloAmbient)
      try audioSession.setActive(true)
      UIApplication.shared.endReceivingRemoteControlEvents()
 //     removeAVAudioSessionInterruptionObserver()
      print("AudioSessionMng: ToDefault")
    } catch let error {
      print("AudioSessionMng: setupAudioSessionToDefault error. Description: \(error.localizedDescription)")
    }
  }
  //
 
}

extension AudioSessionMng: CXCallObserverDelegate {
  func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
    if call.hasEnded == true {
      print("AppDelegate Disconnected")
      self.delegate?.callObserver(state: .Disconnected)
    }
    if call.isOutgoing == true && call.hasConnected == false {
      self.delegate?.callObserver(state: .Dialing)
      print("AppDelegate Dialing")
    }
    if call.isOutgoing == false && call.hasConnected == false && call.hasEnded == false {
      self.delegate?.callObserver(state: .Incoming)
      print("AppDelegate Incoming")
    }
    
    if call.hasConnected == true && call.hasEnded == false {
      self.delegate?.callObserver(state: .Connected)
      print("AppDelegate Connected")
    }
    
//    if call.isOutgoing == true && call.hasConnected == false && call.hasEnded == false {
//      self.delegate?.callObserver(state: .Failed)
//      print("AppDelegate Failed")
//    }
    
  }
}

