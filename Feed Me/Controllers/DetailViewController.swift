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

// https://parse-dashboard.back4app.com/apps/0189f619-6dad-430e-b301-bca26a7f42a0/browser/_User

// http://docs.parseplatform.org/ios/guide/

import UIKit

class DetailViewController: UIViewController {
  
  
    @IBOutlet weak var detailTable: UITableView!
  
  var arrayList = [String]()
  
  let indicator : UIActivityIndicatorView = {
    let ind = UIActivityIndicatorView(style: .whiteLarge)
    ind.backgroundColor = .lightGray
    ind.translatesAutoresizingMaskIntoConstraints = false
    
    return ind
  }()
  
  let conteinerView: UIView = {
    let view = UIView()
    view.backgroundColor = .lightGray
    view.alpha = 0.7
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let miniConteinerView: UIView = {
    let view = UIView()
    view.backgroundColor = .gray
    view.layer.cornerRadius = 8
    view.layer.masksToBounds = true
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let nameLabel: UILabel = {
    let lb = UILabel()
    lb.font = UIFont.systemFont(ofSize: 17)
    lb.textColor = .white
    lb.backgroundColor = .clear
    lb.text = "Wait for download"
    lb.translatesAutoresizingMaskIntoConstraints = false
    return lb
  }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
      detailTable.delegate = self
      detailTable.dataSource = self
      
      self.view.addSubview(conteinerView)
      
      conteinerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
      conteinerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
      conteinerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
      conteinerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
      
      conteinerView.addSubview(miniConteinerView)
      
      miniConteinerView.centerXAnchor.constraint(equalTo: conteinerView.centerXAnchor).isActive = true
      miniConteinerView.centerYAnchor.constraint(equalTo: conteinerView.centerYAnchor).isActive = true
      miniConteinerView.heightAnchor.constraint(equalToConstant: 44).isActive = true
      miniConteinerView.widthAnchor.constraint(equalToConstant: 220).isActive = true
      
      miniConteinerView.addSubview(indicator)
      miniConteinerView.addSubview(nameLabel)
      
      indicator.leadingAnchor.constraint(equalTo: miniConteinerView.leadingAnchor, constant: 8).isActive = true
      indicator.centerYAnchor.constraint(equalTo: miniConteinerView.centerYAnchor).isActive = true
      
      nameLabel.leadingAnchor.constraint(equalTo: indicator.trailingAnchor, constant: 16).isActive = true
      nameLabel.centerYAnchor.constraint(equalTo: miniConteinerView.centerYAnchor).isActive = true
      indicator.startAnimating()
      
      
//      self.view.addSubview(indicator)
//
//      indicator.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
//      indicator.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
//      indicator.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
//      indicator.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
//      indicator.startAnimating()
      
      navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(DetailViewController.dellAll(_:)))

      
      NotificationCenter.default.addObserver(self, selector: #selector(DetailViewController.loadList(notification:)), name: .deletelist, object: nil)
      
    }
  
  override func viewDidAppear(_ animated: Bool) {
    
    HelperMetodsPars.shared.fetchTrackListEscaping { (array) in
      guard let list = array else { return }
      if list.count > 0 {
        self.arrayList = list
      }
      DispatchQueue.main.async {
        self.conteinerView.removeFromSuperview()
   //     self.indicator.stopAnimating()
        self.detailTable.reloadData()
        
      }
    }
    gButtonKeyForMap = true

  }
  
  @objc func dellAll(_ sender: UIBarButtonItem) {
    
    HelperMetodsPars.shared.deleteAll { (boolDelete) in
      if boolDelete == true {
        
        self.arrayList.removeAll()
        DispatchQueue.main.async {
          self.detailTable.reloadData()
        }
      }
    }
  }
  
  @objc func loadList(notification: Notification) {

   

//    print("loadList Notification")
//    print("\(self.arrayList.count)")
     self.detailTable.reloadData()
  }
  
//    @objc func loadList(notification: Notification) {
//
//      HelperMetodsPars.shared.fetchTrackListEscaping { (arrayList) in
//        if let array = arrayList {
//          if array.count > 0 {
//            self.arrayList = array
//            self.detailTable.reloadData()
//          } else {
//            self.detailTable.reloadData()
//          }
//        }
//      }
//  }
  
}

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.arrayList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell") as! DetailTableViewCell
    
    cell.textLabel?.text = self.arrayList[indexPath.row]
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let track = self.arrayList[indexPath.row]
    let dictionary = ["track": track]
    gButtonKeyForMap = false
   
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let mapViewController = storyBoard.instantiateViewController(withIdentifier: "MapView") as! MapViewController
   // self.present(mapViewController, animated: true, completion: nil)
    self.navigationController?.pushViewController(mapViewController, animated: true)
    
    NotificationCenter.default.post(name: .loadTrack, object: nil, userInfo: dictionary)
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
//    CoreDataManager.sharedManager.deleteCarDetail(self.masivCarStr[indexPath.row])
//    self.masivCarStr = curentCar!.carDetail?.allObjects as! [CarDetail]
//    self.detailCar!.reloadData()
    

    let strTrack = self.arrayList.remove(at: indexPath.row)
    self.detailTable.reloadData()
    HelperMetodsPars.shared.deleteTrack(name: strTrack, array: self.arrayList)
  }
  
}
