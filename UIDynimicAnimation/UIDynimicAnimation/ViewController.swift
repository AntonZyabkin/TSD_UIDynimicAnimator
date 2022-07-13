//
//  ViewController.swift
//  UIDynimicAnimation
//
//  Created by Anton Zyabkin on 12.07.2022.
//

import UIKit

class ViewController: UIViewController {
    
    var squareViews = [UIDynamicItem]()
    var animation = UIDynamicAnimator ()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

         
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let numberOfItems = 2
        squareViews.reserveCapacity(numberOfItems)
        let colors = [UIColor.red, UIColor.systemMint]
        var curentCenterPiont : CGPoint = view.center
        let eachViewSize = CGSize (width: 50, height: 50)
        
        for counter in 0..<numberOfItems {
            let newView = UIView (frame: CGRect (x: 0, y: 0, width: eachViewSize.width, height: eachViewSize.height))
            newView.backgroundColor = colors[counter]
            newView.center = curentCenterPiont
            curentCenterPiont.y += eachViewSize.height + 20
            view.addSubview(newView)
            squareViews.append(newView)
        }
        
        //добавим гравитационное поведение для нашего массива вью
        animation = UIDynamicAnimator(referenceView: view)
        let gravity = UIGravityBehavior (items: squareViews)
        animation.addBehavior(gravity)
        
        
        //добавим столкновение объектов
        let collition = UICollisionBehavior (items: squareViews)
        collition.translatesReferenceBoundsIntoBoundary = true
        collition.addBoundary(withIdentifier: "bottomBoundary" as NSCopying, from: CGPoint(x: 0, y: view.bounds.height - 50), to: CGPoint (x: view.bounds.size.width, y: view.bounds.height - 50))
        animation.addBehavior(collition)


        //
    }
    
}

