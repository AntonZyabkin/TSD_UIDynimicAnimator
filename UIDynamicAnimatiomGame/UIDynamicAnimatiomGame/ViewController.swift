//
//  ViewController.swift
//  UIDynamicAnimatiomGame
//
//  Created by Anton Zyabkin on 14.07.2022.
//

import UIKit

class ViewController: UIViewController {
    
    var circle : UIView = {
        let figure = UIView (frame:  CGRect (x: 0, y: 0, width: 50, height:  50))
        figure.backgroundColor = .red
        figure.alpha = 0.5
        figure.layer.cornerRadius = 25
        figure.layer.masksToBounds = true
        figure.clipsToBounds = true
        
        return figure
    }()
    var animator = UIDynamicAnimator ()
    var snapBehavior : UISnapBehavior?
    var collition = UICollisionBehavior ()
    
    var leftTobLabel : UILabel = {
        var label = UILabel (frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        label.backgroundColor = .purple
        label.layer.cornerRadius = 25
        label.layer.maskedCorners = .layerMaxXMaxYCorner
        label.layer.masksToBounds = true
        label.text = "START GAME"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.clipsToBounds = true

        return label
    }()
    var leftBottomLabel : UILabel = {
        var label = UILabel (frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        label.backgroundColor = .systemTeal
        label.layer.cornerRadius = 25
        label.layer.maskedCorners = .layerMaxXMinYCorner
        label.layer.masksToBounds = true
        label.clipsToBounds = true

        label.text = "QUITE"
        label.textAlignment = .center

        label.numberOfLines = 0
        return label
    }()
    var rightTopLabel : UILabel = {
        var label = UILabel (frame: CGRect(x: 314, y: 0, width: 100, height: 100))
        label.backgroundColor = .gray
        label.layer.cornerRadius = 25
        label.layer.maskedCorners = .layerMinXMaxYCorner
        label.layer.masksToBounds = true
        label.clipsToBounds = true

        label.text = "RESTART"
        label.textAlignment = .center

        label.numberOfLines = 0

        return label
    }()
    var rightBottomLabel : UILabel = {
        var label = UILabel (frame: CGRect(x: 214, y: 100, width: 100, height: 100))
        label.backgroundColor = .systemPink
        label.layer.cornerRadius = 25
        label.layer.maskedCorners = .layerMinXMinYCorner
        label.layer.masksToBounds = true
        label.clipsToBounds = true

        label.text = "OUT"
        label.textAlignment = .center

        label.numberOfLines = 0

        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        collition.collisionDelegate = self
    }

    
    override func viewDidAppear(_ animated: Bool) {
        view.addSubview(leftTobLabel)
        view.addSubview(leftBottomLabel)
        view.addSubview(rightTopLabel)
        view.addSubview(rightBottomLabel)
        view.addSubview(circle)
        circle.center = view.center
        createGestureRecognizer ()
        creareAnimatorAndBehavior ()
        addCollision ()
    }

    
    func createGestureRecognizer () {
        let tabGesture = UITapGestureRecognizer (target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tabGesture)
    }
    
    
    func creareAnimatorAndBehavior () {
        animator = UIDynamicAnimator (referenceView: view)
        collition = UICollisionBehavior (items: [circle])
        animator.addBehavior(collition)
        snapBehavior = UISnapBehavior (item: circle, snapTo: circle.center)

        snapBehavior?.damping = 0.5

        animator.addBehavior(snapBehavior!)

    }
    
    @objc func handleTap (paramTap : UITapGestureRecognizer) {
        let tapPoint = paramTap.location(in: view)
        if snapBehavior != nil {
            animator.removeBehavior(snapBehavior!)
        }
        
        snapBehavior = UISnapBehavior (item: circle, snapTo: tapPoint)
        snapBehavior?.damping = 0.5
        animator.addBehavior(snapBehavior!)
    }
    
    func addCollision () {
        let collition = UICollisionBehavior (items: [circle, leftBottomLabel, leftTobLabel, rightTopLabel, rightBottomLabel])
        collition.translatesReferenceBoundsIntoBoundary = true
        collition.addBoundary(
            withIdentifier: "bottomBoundary" as NSCopying,
            from: CGPoint(x: 0, y: view.bounds.height - 50),
            to: CGPoint (x: view.bounds.size.width, y: view.bounds.height - 50))
        animator.addBehavior(collition)

        collition.collisionDelegate = self
    }
    
}

extension ViewController : UICollisionBehaviorDelegate {
    
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item1: UIDynamicItem, with item2: UIDynamicItem, at p: CGPoint) {
        let item2Label = item2 as? UILabel
        
        print ((item2Label?.text)!)
        
    }
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        let identifire1 = identifier as? String //связываем идентификатор с входным идентификатором
        let kBottomBoundary = "bottomBoundary"
        if identifire1 == kBottomBoundary { //сравниваем входной идентификатор с тем, который ассоциируется с тредуемым collition
            UIView.animate(withDuration: 1) { //выполняем определенные анимации объектор входящих в поведение collition через метор UIView.animate за заданный интервал
                let view = item as? UIView
                view?.backgroundColor = .red //при столкновении меняем цвет
                view?.alpha = 0  //меняем прозрачность
                view?.transform = CGAffineTransform (scaleX: 0.7, y: 0.7) //меняем масштаб скейл
            } completion: { (finished) in

                let view = item  as? UIView
                behavior.removeItem(item)
                view?.removeFromSuperview()
            }

        }
    }
}
