//
//  SlidePopViewController.swift
//  Demo
//
//  Created by mac on 2022/1/21.
//

import Foundation
import UIKit

/**
 左右上下拖动的弹出页
 */
class SlidePopViewController: UIViewController, UIGestureRecognizerDelegate {
    
    private static let windowSize: CGSize = UIScreen.main.bounds.size
    private var keyWindow: UIWindow? {
        if #available(iOS 15.0, *) {
            return UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive}).first(where: {$0 is UIWindowScene}).flatMap({$0 as? UIWindowScene})?.windows.first(where: \.isKeyWindow)
        }else if #available(iOS 13.0, *) {
            return UIApplication.shared.windows.first
        }else {
            return UIApplication.shared.keyWindow
        }
    }
    
    /// 展示
    class func show(_ controller: UIViewController) {
        let vc = SlidePopViewController()
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .overCurrentContext
        controller.present(vc, animated: false) {
            let size = SlidePopViewController.windowSize
            vc.view.frame = CGRect(x: 0, y: size.height, width: size.width, height: vc.groundHeight())
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                vc.view.frame = CGRect(x: 0, y: size.height-vc.groundHeight(), width: size.width, height: vc.groundHeight())
            }, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        addObserver()
    }
    
    /**
     监听
     */
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(touchStatusBar(_:)), name: .DidTapStatusBar, object: nil)
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(slidePanAction(_:)))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
    }
    
    /**
     接收通知
     */
    @objc private func touchStatusBar(_ notice: Notification) {
        if let objc = notice.object as? [String: Any], let touches = objc["touches"] as? Set<UITouch>, let event = objc["event"] as? UIEvent? {
            touchesBegan(touches, with: event)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let point = touches.first?.location(in: keyWindow) {
            if !view.frame.contains(point) {
                /**
                 点击空白处须收回
                 */
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc private func slidePanAction(_ sender: UIPanGestureRecognizer) {
        if let window = keyWindow {
            let offset = sender.translation(in: window),
                velocity = sender.velocity(in: window),
                center = view.center,
                width = SlidePopViewController.windowSize.width,
                height = SlidePopViewController.windowSize.height,
                minY = (height-groundHeight())/2+height/2,
                maxY = (height-groundHeight())/2+height*3/2
            switch sender.state {
            case .ended:
                if center.y > height || center.y+velocity.y > height || velocity.x > 600 {
                    dismiss(animated: true, completion: nil)
                }else {
                    UIView.animate(withDuration: 0.3) {
                        self.view.center = CGPoint(x: center.x, y: minY)
                    }
                }
            case .began, .changed:
                let centerY = minY+offset.x*height/width+offset.y
                if centerY > minY, centerY < maxY {
                    view.center = CGPoint(x: center.x, y: centerY)
                }
            default:
                break
            }
            
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let view = gestureRecognizer.view, view == self.view, let gesture = gestureRecognizer as? UIPanGestureRecognizer {
            let center = touch.location(in: view),
                minY = SlidePopViewController.windowSize.height-(groundHeight())+50
            if gesture.state == .possible {
                if center.x > 50, center.y > minY {
                    return false
                }else if center.x < 50, center.y < minY {
                    return false
                }
            }
        }
        return true
    }
    
    /**
     页面高度
     */
    func groundHeight() -> CGFloat {
        return SlidePopViewController.windowSize.height-100
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
