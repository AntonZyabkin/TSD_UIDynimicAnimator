//
//  ViewController.swift
//  UIDynimicAnimation
//
//  Created by Anton Zyabkin on 12.07.2022.
//

import UIKit

class ViewController: UIViewController {
    
    let square = UIView ()
    var animation = UIDynamicAnimator ()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        square.frame = CGRect (x: 200, y: 50, width: 30, height: 30)
        square.backgroundColor = .red
        view.addSubview(square)
        
        animation = UIDynamicAnimator(referenceView: square)
        let gravity = UIGravityBehavior (items: [square])
        animation.addBehavior(gravity)
    }


}

