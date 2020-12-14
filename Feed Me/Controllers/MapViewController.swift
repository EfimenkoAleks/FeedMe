//
//  MapViewController.swift
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
//import Alamofire

//   https://swiftbook.ru/post/tutorials/google-maps-ios-sdk/
//   https://github.com/domesticmouse/places-api-key-proxy
//   https://developers.google.com/places/web-service/search


class MapViewController: UIViewController {
  
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    
  @IBOutlet private weak var mapCenterPinImage: UIImageView!
  @IBOutlet private weak var pinImageVerticalConstraint: NSLayoutConstraint!

    @IBOutlet weak var saveButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var trackButtonOutlet: UIBarButtonItem!
  
  
    var arrayPoint = [Point]()
  var location : CLLocationCoordinate2D?
//  var currentDestination: VacationDestination = VacationDestination(name: "SFQ Airport", location: CLLocationCoordinate2D(latitude: 37.621262, longitude: -122.378945), zoom: 12)
  
//  let locationManager = CLLocationManager()
  weak var timer: Timer?
  var changTimer = false
  
  var silentPlayer: SilencePlayer? = nil
  
  private lazy var locationManager: CLLocationManager = {
    let manager = CLLocationManager()
    manager.desiredAccuracy = kCLLocationAccuracyBest
//    manager.delegate = self
    manager.requestAlwaysAuthorization()
    manager.allowsBackgroundLocationUpdates = true
    return manager
  }()
  
  var label: UILabel = {
    let lb = UILabel()
    lb.textAlignment = .center
    lb.font = UIFont.systemFont(ofSize: 40)
    // lb.font = UIFont(name: "HelveticaNeue-BoldItalic", size: 30)
    lb.backgroundColor = .white
    lb.layer.borderWidth = 1
    //        lb.shadowColor = .purple
    //        let size = CGSize(width: 0, height: -1)
    //        lb.shadowOffset = size
    lb.layer.cornerRadius = 5
    lb.layer.masksToBounds = true
    //      lb.lineBreakMode = .byWordWrapping
    lb.numberOfLines = 0
    lb.translatesAutoresizingMaskIntoConstraints = false
    return lb
  }()
  
  let startButton: UIButton = {
    
    let bt = UIButton()
    bt.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
    bt.setTitle("Start", for: .normal)
    bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
    bt.layer.cornerRadius = 25
    bt.layer.borderWidth = 1
    bt.layer.masksToBounds = true
    bt.translatesAutoresizingMaskIntoConstraints = false
    
    return bt
  }()
  
  let clearButton: UIButton = {
    
    let bt = UIButton()
    bt.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
    bt.setTitle("Clear", for: .normal)
    bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
    bt.layer.cornerRadius = 25
    bt.layer.borderWidth = 1
    bt.layer.masksToBounds = true
    bt.translatesAutoresizingMaskIntoConstraints = false
    
    return bt
  }()
  
  let stopButton: UIButton = {
    
    let bt = UIButton()
    bt.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
    bt.setTitle("Stop", for: .normal)
    bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
    bt.layer.cornerRadius = 25
    bt.layer.borderWidth = 1
    bt.layer.masksToBounds = true
    bt.translatesAutoresizingMaskIntoConstraints = false
    
    return bt
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mapView.delegate = self
    locationManager.delegate = self
//    locationManager.requestAlwaysAuthorization()
//    locationManager.allowsBackgroundLocationUpdates = true
    
//    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(MapViewController.showTreak))
    
//    let start = UIBarButtonItem(title: "Start", style: .plain, target: self, action: #selector(MapViewController.startTreak))
//    let show = UIBarButtonItem(title: "Show", style: .plain, target: self, action: #selector(MapViewController.showTreak))
//    let clear = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(MapViewController.clearTreak))
//    navigationItem.rightBarButtonItems = [show, clear, start]
//    navigationItem.rightBarButtonItems?[0].isEnabled = false
//    navigationItem.rightBarButtonItems?[1].isEnabled = false
    
    self.view.addSubview(label)
    label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
    label.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.bounds.height / 9).isActive = true
    label.trailingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 90).isActive = true
//    label.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
    //    label.widthAnchor.constraint(equalToConstant: self.frame.width * 0.3).isActive = true
    
    self.view.addSubview(startButton)
    self.view.addSubview(clearButton)
    self.view.addSubview(stopButton)
    
    startButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.bounds.height / 9).isActive = true
    startButton.leadingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -60).isActive = true
    startButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
    startButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    self.startButton.addTarget(self, action: #selector(MapViewController.startTreak), for: UIControl.Event.touchUpInside)
   
    clearButton.topAnchor.constraint(equalTo: self.startButton.bottomAnchor, constant: 10).isActive = true
    clearButton.leadingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -60).isActive = true
    clearButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
    clearButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    self.clearButton.addTarget(self, action: #selector(MapViewController.clearTreak), for: UIControl.Event.touchUpInside)
    
    stopButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.bounds.height / 9).isActive = true
    stopButton.leadingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -60).isActive = true
    stopButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
    stopButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    self.stopButton.addTarget(self, action: #selector(MapViewController.showTreak), for: UIControl.Event.touchUpInside)
    
 //   GMSServices.provideAPIKey("AIzaSyBhbDXG8WHyvdYCUWh2BDSmc-U00uX5ksw")
//    let camera = GMSCameraPosition.camera(withLatitude: 37.621262, longitude: -122.378945, zoom: 12)
//    mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//    let curentLocation = CLLocationCoordinate2D(latitude: 37.621262, longitude: -122.378945)
//    let marcer = GMSMarker(position: curentLocation)
//    marcer.title = "SFQ Airport"
//    marcer.map = mapView
//
//    self.setCamera()
    self.label.text = "0"
    
    NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.loadTrack(notification:)), name: .loadTrack, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.featchTrackPars(notification:)), name: .featchTrackPars, object: nil)
    
  }
  
//  private func setCamera() {
//    CATransaction.begin()
//    CATransaction.setValue(2, forKey: kCATransactionAnimationDuration)
//    mapView.animate(to: GMSCameraPosition.camera(withTarget: currentDestination.location, zoom: currentDestination.zoom))
//    CATransaction.commit()
//
//    let marker = GMSMarker(position: currentDestination.location)
//    marker.title = currentDestination.name
//    marker.map = mapView
//  }
  
//  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    guard let navigationController = segue.destination as? UINavigationController,
//      let controller = navigationController.topViewController as? TypesTableViewController else {
//        return
//    }
//    controller.selectedTypes = searchedTypes
//    controller.delegate = self
//  }
  
  override func viewDidAppear(_ animated: Bool) {

    if gButtonKeyForMap {
      self.startButton.isHidden = false
      self.clearButton.isHidden = true
      self.stopButton.isHidden = true
      self.saveButtonOutlet.isEnabled = false
      self.trackButtonOutlet.isEnabled = true
      self.reloadLabel()
//      AudioSessionMng().setupAudioSessionToPlayback()
    } else {
      self.forSecondControler()
      self.saveButtonOutlet.isEnabled = false
      self.trackButtonOutlet.isEnabled = false
    }
//    self.reloadLabel()
    
  }
  
  @objc func loadTrack(notification: Notification) {
    
    print("loadTrack Notification")

    if let data = notification.userInfo as? [String: String] {
      if let dataLIst = data["track"] {
        print("\(dataLIst)")
        HelperMetodsPars.shared.fetchTrack(name: dataLIst)
//
//        self.arrayPoint = track.points
//        self.showTreak()
      }
    }
    
  }
  
  @objc func featchTrackPars(notification: Notification) {
    
    print("featchTrackPars notification")
    
    if let data = notification.userInfo as? [String: Track] {
      if let dataTrack = data["featchTrack"] {
        print("featchTrackPars \(dataTrack.name)")
        self.arrayPoint = dataTrack.points
        print("\(self.arrayPoint.count)")
        self.changTimer = true
        
        self.showTreak(nil)
        self.label.text = self.arrayPoint.count.description
        
      //  HelperMetodsPars.shared.fetchTrack(name: dataLIst)
        //
        //        self.arrayPoint = track.points
        //        self.showTreak()
      }
    }
    
  }
  
  @objc func startTreak(_ sender: UIButton) {
    
    self.reloadLabel()
    
//    AudioForBackground.shared.play()
//    self.setPlayer(isPlaying: false)
    self.silentPlayer = SilencePlayer()
    self.silentPlayer?.play()
    
    if changTimer == false {
    self.timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(MapViewController.updateTimer), userInfo: nil, repeats: true)
      self.changTimer = true
//      navigationItem.rightBarButtonItems?[0].isEnabled = true
//      navigationItem.rightBarButtonItems?[1].isEnabled = false
//      navigationItem.rightBarButtonItems?[2].isEnabled = false
      
      if gButtonKeyForMap {
        self.startButton.isHidden = true
        self.clearButton.isHidden = true
        self.stopButton.isHidden = false
        self.trackButtonOutlet.isEnabled = false
      } else {
        self.forSecondControler()
      }
    }
  }
  
//  func setPlayer(isPlaying: Bool) {
//    if silentPlayer == nil {
//      silentPlayer =  SilencePlayer()//подписываемся на получение всяких handler по AudioSessionDelegate от SilencePlayer
//    }
//    print("setSilencePlayerTo", isPlaying )
//    if isPlaying {
////      silentPlayer?.play()
//      silentPlayer?.pause()
//    } else {
////      silentPlayer?.pause()
//      silentPlayer?.play()
//    }
//  }
  
  func stopSilence(){
    silentPlayer?.stop()
    silentPlayer = nil
  }
  
  @objc func clearTreak() {
    
    self.reloadLabel()
    
//    navigationItem.rightBarButtonItems?[0].isEnabled = false
//    navigationItem.rightBarButtonItems?[1].isEnabled = false
//    navigationItem.rightBarButtonItems?[2].isEnabled = true
    
    if gButtonKeyForMap {
      self.startButton.isHidden = false
      self.clearButton.isHidden = true
      self.stopButton.isHidden = true
      self.saveButtonOutlet.isEnabled = false
      self.trackButtonOutlet.isEnabled = true
    } else {
      self.forSecondControler()
    }
  }

  @objc func updateTimer() {
    
    locationManager.startUpdatingLocation()
    
//    if self.arrayPoint.count > 0 {
//      for point in arrayPoint {
//        let marker = GMSMarker(position: point.location)
//        marker.map = nil
//      }
//    }
    
    if let loc = self.location {
      let pointLast = self.arrayPoint.last
      if loc.latitude != pointLast?.location.latitude && loc.longitude != pointLast?.location.longitude {
        
        let date = Date()
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy/MM/dd HH:mm"
        let dateString = dateFormater.string(from: date)
        
        let point = Point(time: dateString, location: loc)
        
        self.arrayPoint.append(point)
      
      }
    }
    
    while self.arrayPoint.count > 200 {
      let pointToRemove = self.arrayPoint.first!
      self.arrayPoint.remove(at: 0)
      
      // Also remove from the map
      let marker = GMSMarker(position: pointToRemove.location)
      marker.map = nil
    }
    self.label.text = self.arrayPoint.count.description
  }
  
  @objc func showTreak(_ sender: UIButton?) {
    
    if changTimer == true {
      
      if self.arrayPoint.count > 0 {
        for point in self.arrayPoint {
          let marker = GMSMarker(position: point.location)
          marker.title = point.time
          marker.map = mapView
        }
        mapView.camera = GMSCameraPosition(target: self.arrayPoint.first!.location, zoom: 15, bearing: 0, viewingAngle: 0)
      }
      self.timer?.invalidate()
      self.timer = nil
      self.changTimer = false
      
      //      navigationItem.rightBarButtonItems?[0].isEnabled = false
      //      navigationItem.rightBarButtonItems?[1].isEnabled = true
      //      navigationItem.rightBarButtonItems?[2].isEnabled = true
      
      if gButtonKeyForMap {
        self.startButton.isHidden = false
        self.clearButton.isHidden = false
        self.stopButton.isHidden = true
        self.saveButtonOutlet.isEnabled = true
        self.trackButtonOutlet.isEnabled = true
//        if let curSender = sender {
//        AudioForBackground.shared.pause(curSender)
//        }
        self.stopSilence()
      } else {
        self.forSecondControler()
      }
    }
  }
  
  @IBAction func saveTrack(_ sender: UIBarButtonItem) {
    
    if self.arrayPoint.count > 0 {
      let track = Track(name: (self.arrayPoint.first!.time + " - " + self.arrayPoint.last!.time), points: self.arrayPoint)
      
      HelperMetodsPars.shared.saveTrack(track: track)
      
      HelperMetodsPars.shared.fetchTrackListEscaping { (arrayTrackList) in
        if var array = arrayTrackList {
          array.append((self.arrayPoint.first!.time + " - " + self.arrayPoint.last!.time))
          HelperMetodsPars.shared.updatingTrackList(array: array)
          self.reloadLabel()
        } else {
          HelperMetodsPars.shared.saveTrackList(name: (self.arrayPoint.first!.time + " - " + self.arrayPoint.last!.time))
         self.reloadLabel()
          
        }
      }
//      self.arrayPoint.removeAll()
    }
      self.clearButton.isHidden = true
      self.saveButtonOutlet.isEnabled = false
  }
  
  func forSecondControler() {
    self.startButton.isHidden = true
    self.clearButton.isHidden = true
    self.stopButton.isHidden = true
  }
  
  func reloadLabel() {
    self.mapView.clear()
    self.arrayPoint.removeAll()
    self.location = nil
    self.label.text = "0"
  }
  
  func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {

    // 1
    let geocoder = GMSGeocoder()

    // 2
    geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
      if let address = response?.firstResult() {

        self.addressLabel.unlock()

        // 3
        if let lines = address.lines {

      var text = ""
          for lin in lines {
            text.append(lin)
          }
          self.addressLabel.text = text
        }

        let labelHeight = self.addressLabel.intrinsicContentSize.height
        self.mapView.padding = UIEdgeInsets(top: self.view.safeAreaInsets.top, left: 0,
                                            bottom: labelHeight, right: 0)

        UIView.animate(withDuration: 0.25) {
          //2
          self.pinImageVerticalConstraint.constant = ((labelHeight - self.view.safeAreaInsets.top) * 0.5)
          self.view.layoutIfNeeded()
        }
      }
    }
  }
  
//  func fetchMapData() {
//
//    var destStart : CLLocationCoordinate2D?
//    var destEnd : CLLocationCoordinate2D?
//    var i = 0
//
//    for point in self.arrayPoint {
//
//      if i % 2 == 0 {
//      destStart = point.location
//      } else {
//        destEnd = point.location
//      }
//      if let start = destStart, let end = destEnd {
//
//    let directionURL = "https://maps.googleapis.com/maps/api/directions/json?" +
//      "origin=\(String(describing: start.latitude)),\(String(describing: start.longitude))&destination=\(String(describing: end.latitude)),\(String(describing: end.longitude))&" +
//    "key=AIzaSyBhbDXG8WHyvdYCUWh2BDSmc-U00uX5ksw"
//
//
//
////    request(directionURL).responseJSON
////      { response in
//
//    request(directionURL).responseJSON { (response) in
//
//        if let JSON = response.result.value {
//
//          let mapResponse: [String: AnyObject] = JSON as! [String : AnyObject]
//
//          let routesArray = (mapResponse["routes"] as? Array) ?? []
//
//          let routes = (routesArray.first as? Dictionary<String, AnyObject>) ?? [:]
//
//          let overviewPolyline = (routes["overview_polyline"] as? Dictionary<String,AnyObject>) ?? [:]
//          let polypoints = (overviewPolyline["points"] as? String) ?? ""
//          let line  = polypoints
//
//          self.addPolyLine(encodedString: line)
//        }
//    }
//      }
//      i += 1
//
//    }
//
//  }
//
//  func addPolyLine(encodedString: String) {
//
//    let path = GMSMutablePath(fromEncodedPath: encodedString)
//    let polyline = GMSPolyline(path: path)
//    polyline.strokeWidth = 5
//    polyline.strokeColor = .blue
//    polyline.map = mapView
//    
//  }
  
}

// MARK: - GMSMapViewDelegate
extension MapViewController: GMSMapViewDelegate {

  func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
    reverseGeocodeCoordinate(coordinate: position.target)
 
//    location = position.target
    // position.description
  }

  func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
    addressLabel.lock()
  }
  
  func mapView(_ mapView: GMSMapView, didTapMyLocation location: CLLocationCoordinate2D) {

    guard let lat = mapView.myLocation?.coordinate.latitude,
      let lng = mapView.myLocation?.coordinate.longitude else { return }

    let camera = GMSCameraPosition.camera(withLatitude: lat ,longitude: lng , zoom: 15)
    mapView.animate(to: camera)

//    return true

  }
  
//  func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
//
//    guard let lat = mapView.myLocation?.coordinate.latitude,
//      let lng = mapView.myLocation?.coordinate.longitude else { return false }
//
//    let camera = GMSCameraPosition.camera(withLatitude: lat ,longitude: lng , zoom: 15)
//    mapView.animate(to: camera)
//
//        return true
//  }
  

  
}

// MARK: - TypesTableViewControllerDelegate
//extension MapViewController: TypesTableViewControllerDelegate {
//  func typesController(_ controller: TypesTableViewController, didSelectTypes types: [String]) {
//    searchedTypes = controller.selectedTypes.sorted()
//    dismiss(animated: true)
//  }
//}

// MARK: - CLLocationManagerDelegate
//1
extension MapViewController: CLLocationManagerDelegate {
  // 2
  internal func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    // 3
    if status == .authorizedAlways {

      // 4
      locationManager.startUpdatingLocation()

      //5
      mapView.isMyLocationEnabled = true
      mapView.settings.myLocationButton = true
  //  mapView.settings.indoorPicker = true
    }
  }

  // 6
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.last {

      // 7
      mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
      self.location = location.coordinate

      // 8
      locationManager.stopUpdatingLocation()
      
    }

  }
  

}

extension Notification.Name {
  
  static let loadTrack = Notification.Name("loadTrack")
  static let loadList = Notification.Name("loadList")
  static let featchTrackPars = Notification.Name("featchTrackPars")
  static let deletelist = Notification.Name("deletelist")
}

//extension MapViewController: AudioSessionDelegate {//хватаем тут всякие handler'ы я их обрабатывал тут, чтобы выставить поведение плеера на всякие изменения, а не в самом плере по дефолту, а вообще это можно повыпиливать
//  
//  func callObserver(state: CallState) {
//    switch state {
//    case .Connected, .Dialing, .Incoming:
//      //     self.setSilencePlayerTo(isPlaying: true)
//      self.setPlayer(isPlaying: true)
//    case .Disconnected:
//      AudioSessionMng().setupAudioSessionToPlayback()
//      //      self.setSilencePlayerTo(isPlaying: true)
//      self.setPlayer(isPlaying: true)
//    }
//  }
//}



