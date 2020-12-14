//
//  AppDelegate.swift
//  Feed Me
//
/// Copyright (c) 2017 Razeware LLC
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
import GoogleMaps
import Parse
import AVFoundation
//import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  // 1
  let googleMapsApiKey = "AIzaSyBhbDXG8WHyvdYCUWh2BDSmc-U00uX5ksw"
 // let googleKey = "e78fabf1993c030b215e7cb8021828e4401cca4a"
  
//  private func application(application: UIApplication, didFinishLaunchingWithOptions
//    launchOptions: [NSObject: AnyObject]?) -> Bool {
//    // 2
//    GMSServices.provideAPIKey(googleMapsApiKey)
//    GMSPlacesClient.provideAPIKey(googleMapsApiKey)
//
//    return true
//  }
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    
    GMSServices.provideAPIKey(googleMapsApiKey)
//    GMSPlacesClient.provideAPIKey(googleMapsApiKey)

    let parseConfig = ParseClientConfiguration {
      $0.applicationId = "FIuh7nYYVdMlS1MuLOdMLuzyWiRu25IdIG3VbiQx"
      $0.clientKey = "gMXHj0fibh4NkFDm4FSpblrhPIW3Ztoo3gL7mtBs"
      $0.server = "https://parseapi.back4app.com"
    }
    Parse.initialize(with: parseConfig)
    
//    do
//    {
//      try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
//      try AVAudioSession.sharedInstance().setActive(true)
//
//      //!! IMPORTANT !!
//      /*
//       If you're using 3rd party libraries to play sound or generate sound you should
//       set sample rate manually here.
//       Otherwise you wont be able to hear any sound when you lock screen
//       */
//      //try AVAudioSession.sharedInstance().setPreferredSampleRate(4096)
//    } catch {
//      print(error)
//    }
    // This will enable to show nowplaying controls on lock screen
    application.beginReceivingRemoteControlEvents()
    
    return true
  }
  
 
}

