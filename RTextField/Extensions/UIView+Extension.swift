// UIView_Extension
// Created by Rashid Latif on 09/02/2022.
// Email:- rashid.latif93@gmail.com
// https://stackoverflow.com/users/10383865/rashid-latif
// https://github.com/rashidlatif55

import UIKit

extension UIView {
   
   func shake(offset: CGFloat = 10) {
       let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
       animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
       animation.duration = 0.5
       animation.values = [-offset, offset, -offset, offset, -offset/2, offset/2, -offset/4, offset/4, offset/4 ]
       layer.add(animation, forKey: "shake")
   }
}

extension UIView {

  func  addTapGesture(action : @escaping ()->Void ){
      let tap = MyTapGestureRecognizer(target: self , action: #selector(self.handleTap(_:)))
      tap.action = action
      tap.numberOfTapsRequired = 1

      self.addGestureRecognizer(tap)
      self.isUserInteractionEnabled = true

  }
  @objc func handleTap(_ sender: MyTapGestureRecognizer) {
      sender.action!()
  }
}

class MyTapGestureRecognizer: UITapGestureRecognizer {
  var action : (()->Void)? = nil
}

