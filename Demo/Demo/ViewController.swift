//
//  ViewController.swift
//  Demo
//
//  Created by mac on 2022/1/18.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .blue
        
        let button = UIButton(type: .custom)
        button.setTitle("下一步", for: .normal)
        button.frame = CGRect(x: 100, y: 100, width: 150, height: 50)
        button.addTarget(self, action: #selector(nextClick), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc private func nextClick() {
        SlidePopViewController.show(self)
    }

}

