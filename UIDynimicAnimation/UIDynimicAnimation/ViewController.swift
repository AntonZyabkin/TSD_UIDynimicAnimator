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
    var pushBeahavior = UIPushBehavior ()
    
    //вторая авриация исполнения
    var squareView2 = UIView ()
    var animator2 = UIDynamicAnimator ()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

         
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let numberOfItems = 2
        squareViews.reserveCapacity(numberOfItems)
        let colors = [UIColor.systemBlue, UIColor.systemMint]
        var curentCenterPiont : CGPoint = CGPoint (x: view.center.x, y: 50)
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
        collition.addBoundary(
            withIdentifier: "bottomBoundary" as NSCopying,
            from: CGPoint(x: 0, y: view.bounds.height - 50),
            to: CGPoint (x: view.bounds.size.width, y: view.bounds.height - 50))
        animation.addBehavior(collition)

        collition.collisionDelegate = self
        //
        
        
        createGestureRecognizer ()
        createSmallSquareView2 ()
        createAnimationBehavior ()
    }
    
    
    
    
    
    
    //____________________ВТОРАЯ ЗАДАЧА
    //создаем квадрат 100Х100
    func createSmallSquareView2 () {
        squareView2 = UIView (frame: CGRect (x: 100, y: 100, width: 100 , height: 100))
        squareView2.backgroundColor = .systemPink
        view.addSubview(squareView2)
    }
    
    //создадим жест
    func createGestureRecognizer () {
        let tabGestureRecognizer = UITapGestureRecognizer (target: self, action: #selector(henrler))
        
        
        view.addGestureRecognizer(tabGestureRecognizer)
    }
    
    
    //зададим столкновение  и толчек у View
    
    func createAnimationBehavior () {
        animator2 = UIDynamicAnimator (referenceView: view)
        
        let collision = UICollisionBehavior (items: [squareView2])
        collision.translatesReferenceBoundsIntoBoundary = true
        pushBeahavior = UIPushBehavior (items: [squareView2], mode: .continuous)
        animator2.addBehavior(collision)
        animator2.addBehavior(pushBeahavior)
    }
    @objc func henrler (paramTap: UITapGestureRecognizer) {
        //Получаем угол ВЬю
        let tapPoint : CGPoint = paramTap.location(in: view)
        let squareViewCenterPoint : CGPoint = squareView2.center
        //определяем угол толчка
        // arcTan 2 * ((p1.x - p2.x), (p1.y - p2.y))
        let deltaX : CGFloat = tapPoint.x - squareViewCenterPoint.x
        let deltaY : CGFloat = tapPoint.y - squareViewCenterPoint.y
        let angel : CGFloat = atan2(deltaY, deltaX)
        pushBeahavior.angle = angel
        
        let distanceBetweenPints : CGFloat = sqrt(pow(tapPoint.x - squareViewCenterPoint.x, 2.0) + pow (tapPoint.y - squareViewCenterPoint.y, 2.0))
        pushBeahavior.magnitude = distanceBetweenPints / 200
    }
    
}












//переопределим наш ВьюКонтроллер чтобы добавить в него метод collisionBehavior делегата UICollisionBehaviorDelegatе. Этот метод будет отслеживать когда объекты с определенным идентификатором поведения "столкновение/collition" коснуться заданной границы
extension ViewController : UICollisionBehaviorDelegate {
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
