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

class DetailTableViewCell: UITableViewCell {

//  let nameLabel: UILabel = {
//    let lb = UILabel()
//    //        tv.isEditable = false
//    lb.font = UIFont.systemFont(ofSize: 16)
//    lb.textColor = .black
//    lb.backgroundColor = .clear
//    lb.translatesAutoresizingMaskIntoConstraints = false
//    return lb
//  }()
//
//  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
//
//    self.addSubview(nameLabel)
//
//    nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
//    nameLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
////    nameLabel.widthAnchor.constraint(equalToConstant: self.frame.width * (3 / 5)).isActive = true
//    nameLabel.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
//
//  }
//
//  required init?(coder aDecoder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//  }
  
  override var frame: CGRect {
    get {
      return super.frame
    }
    set (newFrame) {
      var frame =  newFrame
      frame.origin.y += 4
      frame.size.height -= 2 * 2
      super.frame = frame
    }
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    self.selectionStyle = .none
    self.layer.cornerRadius = 10.0
    self.backgroundColor = #colorLiteral(red: 0.840382874, green: 0.9280859828, blue: 0.9567258954, alpha: 1)
    
  }

}
