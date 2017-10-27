//
//  BuyGoodsTransitioning.swift
//  textTransitioning
//
//  Created by 邵焕超 on 2017/6/12.
//  Copyright © 2017年 邵焕超. All rights reserved.
//

import UIKit

class BuyGoodsTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.3
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let formVC = transitionContext.viewController(forKey: .from),
      let toVC = transitionContext.viewController(forKey: .to) else {
        return
    }
    let isPresenting = toVC.presentingViewController == formVC
    
    
    let formView = formVC.view ?? UIView()
    let toView = toVC.view ?? UIView()
    
    // 容器/视图栈
    let container = transitionContext.containerView
    let maskView = UIView()
    maskView.backgroundColor = Color.black
    maskView.alpha = 0.3
    maskView.frame = Macro.keyWindow?.frame ?? CGRect.zero
    if isPresenting {
      maskView.y = 0
    }else {
      maskView.y = -UIScreen.main.bounds.height
    }
    container.addSubview(maskView)

    if isPresenting {
      formView.layer.transform = CATransform3DIdentity
      toView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }else {
      toView.layer.transform = CATransform3DMakeScale(0.85, 0.9, 1)
      formView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
      if isPresenting {
        maskView.y =  -UIScreen.main.bounds.height
        container.addSubview(toView)
        formView.layer.transform = CATransform3DMakeScale(0.85, 0.9, 1)
        toView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
      }else {
        maskView.y = 0
        toView.layer.transform = CATransform3DIdentity
        formView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
      }
      
    }) { (true) in
      maskView.removeFromSuperview()
      // 声明过渡结束时调用 completeTransition: 这个方法
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
  }
}
