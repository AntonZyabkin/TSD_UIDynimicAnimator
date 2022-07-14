//
//  ViewController.swift
//  UIDynamicAnimationSnap@
//
//  Created by Anton Zyabkin on 14.07.2022.
//

import UIKit

class ViewController: UIViewController {

    
    var square = UIView ()
    var animatoe = UIDynamicAnimator ()
    var snapBehavior : UISnapBehavior?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    override func viewDidAppear(_ animated: Bool) {
        //все вьюхи надо отрисовывать в ВьюДидАпиар, как  и их анимацию
        createGestureRecognizer ()
        createSmallSquareView ()
        creareAnimatorAndBehavior ()
        
        
    }
    
    
    func createGestureRecognizer () {
        let tabGesture = UITapGestureRecognizer (target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tabGesture)
    }
    
    func createSmallSquareView () {
        square = UIView (frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        square.center = view.center
        square.backgroundColor = .systemMint
        
        view.addSubview(square)
    }
    
    func creareAnimatorAndBehavior () {
        animatoe = UIDynamicAnimator (referenceView: view)
        let collition = UICollisionBehavior (items: [square])
        animatoe.addBehavior(collition)
        snapBehavior = UISnapBehavior (item: square, snapTo: square.center)

        snapBehavior?.damping = 1 //

        animatoe.addBehavior(snapBehavior!)

    }
    
    
    @objc func handleTap (paramTap : UITapGestureRecognizer) {
        let tapPoint = paramTap.location(in: view)
        if snapBehavior != nil {
            animatoe.removeBehavior(snapBehavior!)
        }
        
        snapBehavior = UISnapBehavior (item: square, snapTo: tapPoint)
        snapBehavior?.damping = 0.05
        animatoe.addBehavior(snapBehavior!)
    }
}

