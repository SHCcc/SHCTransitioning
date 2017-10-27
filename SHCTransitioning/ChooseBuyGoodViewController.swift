 //
//  ChooseBuyGoodViewController.swift
//  textTransitioning
//
//  Created by 邵焕超 on 2017/6/12.
//  Copyright © 2017年 邵焕超. All rights reserved.
//

import UIKit

protocol ChooseBuyGoodViewControllerDelegate: NSObjectProtocol {
  func chooseBuyGoodViewController(dissmiss model: GoodModel?)
}

class ChooseBuyGoodViewController: UIViewController {
  // public
  weak var delegate: ChooseBuyGoodViewControllerDelegate?
  
  // private
  fileprivate let viewModel = ChooseBuyGoodViewModel()
  
  fileprivate var presentingVC = UIViewController()
  
  fileprivate var topBtn = UIButton()
  fileprivate var buyGoodView = BuyGoodView()
  
  /// 不允许横屏
  override var shouldAutorotate: Bool{ return false }
  
  //初始化方法
  class func show(vc: UIViewController,
                  spu: SpuModel,
                  delegate: ChooseBuyGoodViewControllerDelegate?,
                  model: GoodModel? = nil) {
    NetWork.goods.listForSku(spu: spu) { (item) in
      guard item.action else{
        HUD.show(false: item.error.description)
        return
      }
      if vc.navigationController != nil {
        if vc.navigationController?.viewControllers.last != vc { return }
      }
      let choseVC = ChooseBuyGoodViewController(delegate: delegate)
      choseVC.viewModel.spu = spu
      choseVC.show(goodDetailModel: nil, model: model)
    }
  }
  
  init(delegate: ChooseBuyGoodViewControllerDelegate?) {
    super.init(nibName: nil, bundle: nil)
    guard let vc = Macro.keyWindow?.rootViewController else { return }
    self.presentingVC = vc
    self.delegate = delegate
  }
  
  fileprivate func show(goodDetailModel: GoodDetailModel?, model: GoodModel? = nil) {
    if model != nil {
      viewModel.specStyle = model?.specStyle ?? .none
      viewModel.setGood(model: model!)
    }
    pushVC()
  }
  
  fileprivate func pushVC() {
    self.transitioningDelegate = self
    self.modalTransitionStyle = .crossDissolve
    self.modalPresentationStyle = .overCurrentContext
    self.presentingVC.present(self, animated: true, completion: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    buildUI()
    viewModel.getGoodArrData()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    viewModel.isbanNetwork = true
    let model: GoodModel? = viewModel.isSelectModel ? viewModel.model : nil
    delegate?.chooseBuyGoodViewController(dissmiss: model)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension ChooseBuyGoodViewController {
  fileprivate func buildUI() {
    view.addSubview(topBtn)
    view.addSubview(buyGoodView)
    viewModel.delegate = self
    buyGoodView.delegate = self
    buyGoodView.backgroundColor = UIColor.white
    buildSubView()
    buildLayout()
  }
  
  private func buildSubView() {
    topBtn.alpha = 0.3
    topBtn.setBackgroundColor(color: Color.black,
                              for: .normal)
    topBtn.addTarget(self,
                     action: #selector(topDissmisEvent),
                     for: .touchUpInside)
  }
  
  private func buildLayout() {
    let topHeight = Device.type != .iPhone_SE ? Macro.screenHeight * 0.3 : Macro.screenHeight * 0.25
    topBtn.frame = CGRect(x: 0, y: 0, width: Macro.screenWidth, height: topHeight)
    buyGoodView.frame = CGRect(x: 0, y: topHeight, width: Macro.screenWidth, height: Macro.screenHeight - topHeight)
  }
}

extension ChooseBuyGoodViewController {
  @objc func topDissmisEvent() {
    dismiss(animated: true, completion: nil)
  }
}
// MARK: - 转场代理
extension ChooseBuyGoodViewController: UIViewControllerTransitioningDelegate {
  public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return BuyGoodsTransitioning()
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return BuyGoodsTransitioning()
  }
}
// MARK: - ViewModel代理
extension ChooseBuyGoodViewController: ChooseBuyGoodViewModelDelegate {
  func chooseBuyGoodViewModel(soure: ChooseBuyGoodViewModel, error: String) {
    HUD.show(false: error)
  }
  
  func chooseBuyGoodViewModel(soure: ChooseBuyGoodViewModel) {
    buyGoodView.viewModel = viewModel
  }
}
// MARK: - 底部代理
extension ChooseBuyGoodViewController: BuyGoodViewDelegate {
  /// 点击规格属性
  func buyGoodView(selecSpec type: SpecCellType, model: GoodModel) {
    viewModel.setGood(model: model)
  }
  /// 点击零售批发
  func buyGoodView(retailSwitch type: GoodModel.SpecStyle) {
    viewModel.switchSpec(type: type)
  }
  /// 底部加入购物车按钮
  func buyGoodView(addGoodAnimation iconRect: CGRect, buyNum: Int) {
    viewModel.setCarNum(num: buyNum)
    viewModel.addGoods(startRect: iconRect)
  }
}


