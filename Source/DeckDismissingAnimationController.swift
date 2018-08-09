//
//  DeckDismissingAnimationController.swift
//  DeckTransition
//
//  Created by Harshil Shah on 15/10/16.
//  Copyright © 2016 Harshil Shah. All rights reserved.
//

import UIKit

final class DeckDismissingAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    // MARK:- Private variables

    private let duration: TimeInterval?
    private let animation: (() -> ())?
    private let completion: ((Bool) -> ())?

    // MARK:- Initializers

    init(duration: TimeInterval?, animation: (() -> ())?, completion: ((Bool) -> ())?) {
        self.duration = duration
        self.animation = animation
        self.completion = completion
    }

    // MARK:- UIViewControllerAnimatedTransitioning

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let presentingViewController = transitionContext.viewController(forKey: .to)!
        let presentedViewController = transitionContext.viewController(forKey: .from)!

        let containerView = transitionContext.containerView
        let scale: CGFloat = 1 - (Constants.topInsetForPresentingView * 2 / presentingViewController.view.frame.height)

        presentingViewController.view.layer.masksToBounds = true
        presentingViewController.view.layer.cornerRadius = Constants.cornerRadius

        if presentingViewController.responds(to: NSSelectorFromString("getDragToDismissTransformAtTouchUp")),
            let transformObjc = presentingViewController.perform(NSSelectorFromString("getDragToDismissTransformAtTouchUp")).takeUnretainedValue() as? CGAffineTransform.CGAffineTransformObjc,
            let transform = CGAffineTransform(objcRepresentation: transformObjc) {

            presentingViewController.view.transform = CGAffineTransform(scaleX: scale, y: scale).concatenating(CGAffineTransform(translationX: 0, y: 20)).concatenating(transform)
        } else {
            presentingViewController.view.transform = CGAffineTransform(scaleX: scale, y: scale).concatenating(CGAffineTransform(translationX: 0, y: 20))
        }

        let offScreenFrame = CGRect(x: 0, y: containerView.bounds.height, width: containerView.bounds.width, height: containerView.bounds.height)

        animateLin(duration: transitionDuration(using: transitionContext), delay: 0, completion: { [weak self] in
            transitionContext.completeTransition(true)
            self?.completion?(true)
        }) { [weak self] in
            presentingViewController.view.alpha = 1
            presentingViewController.view.transform = .identity
            presentingViewController.view.layer.cornerRadius = 0

            presentedViewController.view.frame = offScreenFrame
            self?.animation?()
        }
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration ?? Constants.defaultAnimationDuration
    }

}
