//
//  UIView+Extend.swift
//  Pods-Demo
//
//  Created by 邵焕超 on 2017/10/27.
//

import UIKit

extension UIView {
  var x: CGFloat {
    set{ frame.origin.x = x }
    get{ return frame.origin.x }
  }
  
  var y: CGFloat {
    set{ frame.origin.y = y }
    get{ return frame.origin.y }
  }
  
  var width: CGFloat {
    set{ frame.size.width = width }
    get{ return frame.size.width }
  }
  
  var height: CGFloat {
    set{ frame.size.height = height }
    get{ return frame.size.height }
  }
  
  
}
