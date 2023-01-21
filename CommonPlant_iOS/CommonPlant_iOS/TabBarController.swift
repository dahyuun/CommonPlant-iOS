//
//  TabBarController.swift
//  CommonPlant_iOS
//
//  Created by 이예원 on 2023/01/21.
//

import UIKit

class TabBarController: UITabBarController {
    
    var borderView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setUpTabBar()
    }

    func setUpTabBar() {
        tabBar.frame.size.height = 98
        tabBar.frame.origin.y = view.frame.size.height - 98
        tabBar.layer.borderWidth = 1
        tabBar.layer.borderColor = UIColor(red: 0.879, green: 0.879, blue: 0.879, alpha: 1).cgColor
        
        self.view.layoutIfNeeded()
    }
    
//
//    func sizeThatFits(_ size: CGSize) -> CGSize {
//        var sizeThatFits =  super.sizeThatFits(size)
//        sizeThatFits.height = 64
//        return sizeThatFits
//    }
}