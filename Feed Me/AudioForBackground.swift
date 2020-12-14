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

//import UIKit
//import AVFoundation
//import CallKit
//
//enum CallState {
//  case Disconnected
//  case Dialing
//  case Incoming
//  case Connected
//}
//
//protocol AudioSessionDelegate: class {
//
//  func callObserver(state: CallState)
//}
//
//class AudioForBackground : NSObject {
//
//  static let shared = AudioForBackground()
//  var audioPlayer = AVAudioPlayer()
//  weak var timerBeck: Timer?
//
//  private func load() {
//
//    do{
//      audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "IronBacon", ofType: "mp3")!))
//      audioPlayer.prepareToPlay()
//
//      let audioSesion = AVAudioSession.sharedInstance()
//
//      do {
//        try audioSesion.setCategory(AVAudioSession.Category.playback)
//        try audioSesion.setCategory(.playback, options: [.mixWithOthers])
//        try audioSesion.setActive(true, options: [])
//      }
//      catch {
//        print(error)
//      }
//    }
//    catch {
//      print(error)
//    }
//
//  }
//
//  func play() {
//
//      self.load()
//      audioPlayer.play()
//    audioPlayer.volume = 0.1
//
//     self.timerBeck = Timer.scheduledTimer(timeInterval: 50, target: self, selector: #selector(AudioForBackground.restart), userInfo: nil, repeats: true)
//  }
//
//  func pause(_ sender: UIButton) {
//
//    if audioPlayer.isPlaying {
//      audioPlayer.pause()
//      self.timerBeck?.invalidate()
//      self.timerBeck = nil
//      print("timer nil")
//    }
//  }
//
//  @objc private func restart() {
//
//    if audioPlayer.isPlaying {
//      audioPlayer.currentTime = 0
//      audioPlayer.play()
//    } else {
//      print("error")
//    }
//
//  }
//
//
//}


import Foundation
import AVFoundation
import CallKit

class SilencePlayer: NSObject {
  private var silencePlayer: AVAudioPlayer?
  private var audioSession: AudioSessionMng?
//  private var sessionDelegate: AudioSessionDelegate?
  private var silenceTimer: Timer?
//  private var limitOfSilenceMin: Double = 60.0//через час чтобы отключился
  
  //MARK:- Init & Setup
  override init() {
    super.init()
    self.audioSession = AudioSessionMng(delegate: self)//подписываемся на получение всяких handler от AudioSessionMng
    self.setupSilencePlayer()
    self.audioSession!.setupAudioSessionToPlayback()
    
//    self.sessionDelegate = sessionDelegate
    
//    self.audioSession = AudioSessionMng()
 //   audioSession.delegate = self
  }
  
  deinit {
    stop()
  }
  
  private func setupSilencePlayer(){
    do {
      guard let audioPath = Bundle.main.path(forResource: "IronBacon", ofType: "mp3") else  {
        print("SilencePlayer: Setup silencePlayer faild")
        return
      }
      let fileURL = URL(fileURLWithPath: audioPath)
      silencePlayer = try AVAudioPlayer(contentsOf: fileURL)
      silencePlayer?.numberOfLoops = -1 // Set any negative integer value to loop the sound indefinitely until you call the stop() method. (c) Apple Docs
      silencePlayer?.volume = 0.05
//      silencePlayer?.prepareToPlay()
    } catch let error {
      print("SilencePlayer: Setup silencePlayer faild")
      print("Error: \(error.localizedDescription)")
    }
  }
  
  //MARK:- Interface
  func play() {
//    if silencePlayer == nil {
//      setupSilencePlayer()
//      if audioSession != nil {
//         self.audioSession!.setupAudioSessionToPlayback()
//      }
//    }
    
    if silencePlayer?.isPlaying == false {
    
    silencePlayer?.prepareToPlay()
    silencePlayer?.play()
    self.startTimer()
    print("silencePlayer isPlaying", silencePlayer?.isPlaying ?? "nil")
    }
  }
  
  private func playAfterCall() {
    
    if silencePlayer?.isPlaying == false {
      
      silencePlayer?.prepareToPlay()
      silencePlayer?.play()
      self.removeTimer()
      self.startTimer()
      print("playAfterCall")
    }
  }
  
  func pause(){
    silencePlayer?.pause()
    self.removeTimer()
    print("silentPlayer is pause")
  }
  
  func stop(){
    silencePlayer?.pause()
    silencePlayer?.stop()
    silencePlayer = nil
    removeTimer()
    print("silentPlayer is stop")
  }
  private func removeTimer() {
    if silenceTimer != nil {
       silenceTimer?.invalidate()
       silenceTimer = nil
    }
  }
  private func startTimer(){
    
         self.silenceTimer = Timer.scheduledTimer(timeInterval: 50, target: self, selector: #selector(SilencePlayer.restart), userInfo: nil, repeats: true)
    
   
  }
  
  @objc private func restart() {
    
    if silencePlayer!.isPlaying {
      self.removeTimer()
      silencePlayer?.currentTime = 0
      self.play()
    }
    
//    if let player = silencePlayer {
//        if player.isPlaying {
//           player.currentTime = 0
//           self.play()
//        } else {
//          print("error")
//        }
//    }
      }
}

//MARK:- AudioSessionDelegate Handler
extension SilencePlayer: AudioSessionDelegate{
  
  func callObserver(state: CallState) {
    switch state {
      
    case .Connected, .Incoming:
      //     self.setSilencePlayerTo(isPlaying: true)
//      self.setPlayer(isPlaying: true)
      self.pause()
      
    case .Disconnected, .Dialing:
//      AudioSessionMng().setupAudioSessionToPlayback()
      //      self.setSilencePlayerTo(isPlaying: true)
//      self.setPlayer(isPlaying: true)
      self.playAfterCall()
      
    }
  }
  
}
