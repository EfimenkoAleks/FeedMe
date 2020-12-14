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

import Foundation
import Parse

class HelperMetodsPars {
  
  static let shared = HelperMetodsPars()
  
  func saveTrack(track: Track) {
    
    var arrayPoint = [[String]]()
    
    for location in track.points {
      let curentLoc = [location.time, location.location.latitude.description, location.location.longitude.description]
      arrayPoint.append(curentLoc)
    }
    
    let trackPars  = PFObject(className: "Track")
    trackPars["name"] = track.name
    trackPars["points"] = arrayPoint
    
    // Saves the new object.
    trackPars.saveInBackground {
      (success: Bool, error: Error?) in
      if (success) {
        // The object has been saved.
        print("Pars saved")
      } else {
        print("no saved")
        // There was a problem, check error.description
      }
    }
  }
  
  func saveTrackList(name: String) {
    
    let trackList  = PFObject(className: "TrackList")
    var arrayList = [String]()
    arrayList.append(name)
    trackList["list"] = arrayList
    
    // Saves the new object.
    trackList.saveInBackground {
      (success: Bool, error: Error?) in
      if (success) {
        // The object has been saved.
        print("Pars saved")
      } else {
        print("no saved")
        // There was a problem, check error.description
      }
    }
  }
  
  
  func fetchTrack(name: String) {
    
    //    let query = PFQuery(className:"GameScore")
    //    query.whereKey("playerName", equalTo:"Sean Plott")
    //    query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
    
    var track: Track?
    var point: Point?
    var arrayPoint = [Point]()
    var arrayString = [[String]]()
    var location: CLLocationCoordinate2D?
    
    
    //    let predicate = NSPredicate(format: "name = " + name)
    //    let query = PFQuery(className: "Track", predicate: predicate)
    let query = PFQuery(className: "Track")
    query.whereKey("name", equalTo: name)
    
    query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
      if error == nil {
        // There was no error in the fetch
        if let returnedobjects = objects {
          
          
          for object in returnedobjects {
            if name == object.value(forKey: "name") as! String {
              arrayString = object.value(forKey: "points") as! [[String]]
              for curArrayString in arrayString {
                location = CLLocationCoordinate2D(latitude: (curArrayString[1] as NSString).doubleValue, longitude: (curArrayString[2] as NSString).doubleValue)
                if let loc = location {
                  point = Point(time: curArrayString[0], location: loc)
                  arrayPoint.append(point!)
                }
              }
              
              track = Track(name: object.value(forKey: "name") as! String, points: arrayPoint)
              let dictionary = ["featchTrack": track!]
              NotificationCenter.default.post(name: .featchTrackPars, object: nil, userInfo: dictionary)
            }
          }
        }
      }
    }
    
  }
  
  func fetchTrackList() -> [String]? {
    
    var trackList: [String]?
    
    let query = PFQuery(className: "TrackList")
    query.findObjectsInBackground { (objects, error) in
      if error == nil {
        // There was no error in the fetch
        if let returnedobjects = objects {
          
          for object in returnedobjects {
            print("fetchTrackList \(returnedobjects.count)")
            trackList = (object.value(forKey: "list") as! [String])
            
          }
        }
//        let dictionary = ["list": trackList!]
//        NotificationCenter.default.post(name: .loadList, object: nil, userInfo: dictionary)
      }
    }
    return trackList
  }
  
  func deleteTrack(name: String, array: [String]) {
    
//    let predicate = NSPredicate(format: "name = " + name)
//    let query = PFQuery(className: "Track", predicate: predicate)
//    query.findObjectsInBackground { (objects, error) in
    
      let query = PFQuery(className: "Track")
      query.whereKey("name", equalTo: name)
      
      query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
      if error == nil {
        if let returnedobjects = objects {
          for object in returnedobjects {
            object.deleteInBackground()
            print("object delete")
            
//            self.fetchTrackListEscaping(completion: { (arrayLIst) in
//              if var arrays = arrayLIst {
//                let arrayList = arrays
//                var i = 0
//                for nameInList in arrayList {
//                  if nameInList == name {
//                    arrays.remove(at: i)
//                    break
//                  }
//                  i += i
//                }
                self.updatingTrackList(array: array)
//              }
//            })
            break
          }
        }
      }
    }
  }
  
  func deleteAll( completion: @escaping (Bool?) -> Void) {
    
    let query1 = PFQuery(className: "Track")
    query1.findObjectsInBackground { (objects, error) in
      if error == nil {
        if let returnedobjects = objects {
          for object in returnedobjects {
            object.deleteInBackground()
            print("Track delete")
          }
          
          let query2 = PFQuery(className: "TrackList")
          query2.findObjectsInBackground { (objects, error) in
            if error == nil {
              if let returnedobjects = objects {
                for object in returnedobjects {
                  object.deleteInBackground()
                  print("TrackList delete")
                }
                completion(true)
              }
            }
          }
        }
      }
    }
  
  }
  
  func updatingTrackList(array: [String]) {
    
    let query = PFQuery(className:"TrackList")
    query.getFirstObjectInBackground() { (trackList: PFObject?, error: Error?) in
      //    query.getObjectInBackground(withId: "xWMyZEGZ") { (trackList: PFObject?, error: Error?) in
      if let error = error {
        print(error.localizedDescription)
      } else if let trackList = trackList {
        
        //        var arrayList = trackList.value(forKey: "list") as! [String]
        //        arrayList.append(name)
        
        trackList["list"] = array
        
        trackList.saveInBackground()
        
        NotificationCenter.default.post(name: .deletelist, object: nil)
      }
      
    }
  }
  
  func fetchTrackListEscaping( completion: @escaping ([String]?) -> Void) {
    
    var trackList: [String]?
    
    let query = PFQuery(className: "TrackList")
    query.findObjectsInBackground { (objects, error) in
      if error == nil {
        // There was no error in the fetch
        if let returnedobjects = objects {
          
          for object in returnedobjects {
            print("fetchTrackList \(returnedobjects.count)")
            trackList = (object.value(forKey: "list") as! [String])
            
          }
        }
        
        DispatchQueue.main.async {
          completion(trackList)
        }
      }
    }
  }
  
}
