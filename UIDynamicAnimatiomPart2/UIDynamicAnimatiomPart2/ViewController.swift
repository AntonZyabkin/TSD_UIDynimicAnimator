//
//  ViewController.swift
//  UIDynamicAnimatiomPart2
//
//  Created by Anton Zyabkin on 14.07.2022.
//

import UIKit

class ViewController: UIViewController {
    
    //В данной части рассмотрим следующие классы:
//    UIAttachmentBehavior
//    UISnapBehavior
    
    var squareView = UIView ()
    var squareViewAnnchorView = UIView ()
    var anchorView = UIView ()
    var animator = UIDynamicAnimator ()
    var attachmernBehavior : UIAttachmentBehavior?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createSmallSquare ()
        createAnchorView ()
        createGestureRecognizer ()
        createAnimationAndBehavior ()
    }
    
    
    //Создаем один квадрат и еще один
    func createSmallSquare () {
        squareView = UIView (frame:  CGRect (x: 0, y: 0, width: 80, height: 80))
        squareView.backgroundColor = .systemPink
        squareView.center = view.center
        squareViewAnnchorView = UIView (frame: CGRect (x: 30, y: 30, width: 20, height: 20))
        squareViewAnnchorView.backgroundColor = .red
        squareView.addSubview(squareViewAnnchorView)
        view.addSubview(squareView)
    }

    
    //Вью с точкой привязки
    func createAnchorView () {
        anchorView = UIView (frame: CGRect(x: 200, y: 200, width: 40, height: 40))
        anchorView.backgroundColor = .blue
        view.addSubview(anchorView)
    }
    
    
    
    //создаем регистратор жеста панорамирования который реагирует на скольжение пальца по экрану и вызывает селектор, мы добавили регистратор на наше Вью целеком, поэтому касания регистрируются по всей площаж=ди экрана:
    func createGestureRecognizer () {
        let panGestureRecognizer = UIPanGestureRecognizer (target: self, action: #selector(handlePan))
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    
    //определяет где палец туда кквадрат передает, а потом привязка к большому
    @objc func handlePan   (paramPan: UIPanGestureRecognizer) {
        let tapPoint = paramPan.location(in: view) //у UIPanGestureRecognizer определяяем положение касания пальца (динамически, когда вызывается селектор UIPanGestureRecognizer
        attachmernBehavior?.anchorPoint = tapPoint
        anchorView.center = tapPoint
        
    }
    
    //создадим столкновение и прикрепление
    func createAnimationAndBehavior () {
        animator = UIDynamicAnimator (referenceView: view)
        //столкновения
         let collision = UICollisionBehavior (items: [squareView])
        collision.translatesReferenceBoundsIntoBoundary = true
        attachmernBehavior = UIAttachmentBehavior (item: squareView, attachedToAnchor: anchorView.center)
        animator.addBehavior(collision)
        animator.addBehavior(attachmernBehavior!)
    }
}

