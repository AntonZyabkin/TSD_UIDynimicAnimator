//
//  ViewController.swift
//  UIDynamicAnimatiomGame
//
//  Created by Anton Zyabkin on 14.07.2022.
//

import UIKit

class ViewController: UIViewController {
    
    var animator = UIDynamicAnimator ()
    var snapBehavior : UISnapBehavior?
    var collition = UICollisionBehavior ()
    var curentNumberOfViews = 6
    var arrayOfViewTags : [Int] = []
    

    var circle = UIView()
    var leftTobLabel = UILabel ()
    var leftBottomLabel = UILabel()
    var rightTopLabel = UILabel()
    var rightBottomLabel = UILabel()

    override func viewDidLoad() {
        createVIews ()
        super.viewDidLoad()
        collition.collisionDelegate = self
        arrayOfViewTags.append(contentsOf: [1, 2, 3, 4, 5])
        
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
        addCollision (array: [circle, leftBottomLabel, leftTobLabel, rightTopLabel, rightBottomLabel])
    }

    func createVIews () {
        circle = UIView (frame:  CGRect (x: 0, y: 0, width: 50, height:  50))
        circle.backgroundColor = .red
        circle.alpha = 0.5
        circle.layer.cornerRadius = 25
        circle.layer.masksToBounds = true
        circle.clipsToBounds = true
        circle.tag = 1
        
        leftTobLabel = UILabel (frame: CGRect(x: 214, y: 200, width: 100, height: 100))
        leftTobLabel.backgroundColor = .purple
        leftTobLabel.layer.cornerRadius = 25
        leftTobLabel.layer.maskedCorners = .layerMaxXMaxYCorner
        leftTobLabel.layer.masksToBounds = true
        leftTobLabel.text = "START GAME"
        leftTobLabel.textAlignment = .center
        leftTobLabel.numberOfLines = 0
        leftTobLabel.clipsToBounds = true
        leftTobLabel.tag = 2
        
        
        leftBottomLabel = UILabel (frame: CGRect(x: 214, y: 100, width: 100, height: 100))
        leftBottomLabel.backgroundColor = .systemTeal
        leftBottomLabel.layer.cornerRadius = 25
        leftBottomLabel.layer.maskedCorners = .layerMaxXMinYCorner
        leftBottomLabel.layer.masksToBounds = true
        leftBottomLabel.clipsToBounds = true
        leftBottomLabel.text = "QUITE"
        leftBottomLabel.textAlignment = .center
        leftBottomLabel.tag = 3
        leftBottomLabel.numberOfLines = 0
        
        rightTopLabel = UILabel (frame: CGRect(x: 114, y: 200, width: 100, height: 100))
        rightTopLabel.backgroundColor = .gray
        rightTopLabel.layer.cornerRadius = 25
        rightTopLabel.layer.maskedCorners = .layerMinXMaxYCorner
        rightTopLabel.layer.masksToBounds = true
        rightTopLabel.clipsToBounds = true
        rightTopLabel.text = "RESTART"
        rightTopLabel.textAlignment = .center
        rightTopLabel.numberOfLines = 0
        rightTopLabel.tag = 4
        
        rightBottomLabel = UILabel (frame: CGRect(x: 114, y: 100, width: 100, height: 100))
        rightBottomLabel.backgroundColor = .systemPink
        rightBottomLabel.layer.cornerRadius = 25
        rightBottomLabel.layer.maskedCorners = .layerMinXMinYCorner
        rightBottomLabel.layer.masksToBounds = true
        rightBottomLabel.clipsToBounds = true
        rightBottomLabel.text = "OUT"
        rightBottomLabel.textAlignment = .center
        rightBottomLabel.numberOfLines = 0
        rightBottomLabel.tag = 5
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
    
    func addCollision (array: [UIDynamicItem]) {
        
        collition = UICollisionBehavior (items: array)
        collition.translatesReferenceBoundsIntoBoundary = true
        collition.addBoundary(
            withIdentifier: "bottomBoundary" as NSCopying,
            from: CGPoint(x: 0, y: 850),
            to: CGPoint (x: view.bounds.size.width, y: 850))
        animator.addBehavior(collition)
        collition.collisionDelegate = self
    }
    
    
    
    //создадим функцию генерящую лейбл
    func createLabelAfterCollision (text: String) {
        
        let newLabel = UILabel (frame: CGRect (x: view.center.x, y: 400, width: 200, height: 50))
        newLabel.backgroundColor = .systemYellow
        newLabel.alpha = 0.3
        newLabel.text = text
        newLabel.textAlignment = .center
        newLabel.layer.cornerRadius = 25
        newLabel.layer.masksToBounds = true
        let randomInt = Int.random(in: 100..<314)
        newLabel.center.x = CGFloat(randomInt)

        addCollision (array: [newLabel])
        let gravity = UIGravityBehavior (items: [newLabel])
        animator.addBehavior(gravity)
        view.addSubview(newLabel)
        arrayOfViewTags.append(curentNumberOfViews)
        newLabel.tag = curentNumberOfViews
        curentNumberOfViews += 1
    }
    
    //функция создания кнопки рестарта игры
    func restartGameButton () {
        let restartButton = UIButton (frame: CGRect (x: 0, y: 0, width: 300, height: 100))
        restartButton.backgroundColor = .systemYellow
        restartButton.setTitle("RESTART GAME", for: .normal)
        restartButton.layer.cornerRadius = 30
        restartButton.layer.masksToBounds = true
        restartButton.tintColor = .green
        restartButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
        restartButton.center = view.center
        restartButton.addTarget(self, action: #selector(resrartView(restart:)), for: .touchUpInside)
        view.addSubview(restartButton)
    }
    
    @objc func resrartView (restart: UIButton) {
        createVIews ()
        animateView(restart)
        collition.collisionDelegate = self
        arrayOfViewTags.append(contentsOf: [1, 2, 3, 4, 5])
        view.addSubview(leftTobLabel)
        view.addSubview(leftBottomLabel)
        view.addSubview(rightTopLabel)
        view.addSubview(rightBottomLabel)
        view.addSubview(circle)
        circle.center = view.center
        createGestureRecognizer ()
        creareAnimatorAndBehavior ()
        addCollision (array: [circle, leftBottomLabel, leftTobLabel, rightTopLabel, rightBottomLabel])
        restart.removeFromSuperview()
    }
    
    fileprivate func animateView (_ viewToAnimate : UIView) {
        UIView.animate(withDuration: 0.05, delay: 0, usingSpringWithDamping: 20, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            viewToAnimate.transform = CGAffineTransform (scaleX: 0.95, y: 0.95)
            
        }) { (_) in
            UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 2, options: .curveEaseIn, animations: {
                viewToAnimate.transform = CGAffineTransform (scaleX: 1, y: 1)
                
            }, completion: nil)
            
        }
    }
}

extension ViewController : UICollisionBehaviorDelegate {
    
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item1: UIDynamicItem, with item2: UIDynamicItem, at p: CGPoint) {
        
        let item2Label = item2 as? UILabel
        createLabelAfterCollision (text: (item2Label?.text)!)
        
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
                self.collition.removeItem(item)
            } completion: { (finished) in

                let view = item  as? UIView
                behavior.removeItem(item)
                view?.removeFromSuperview()
            }

            print(self.arrayOfViewTags)
            print(view.subviews.count)
        }
        if view.subviews.count == 1 {
            restartGameButton()
        }

    }
}
