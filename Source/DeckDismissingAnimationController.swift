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
    //    let interactionController: UIViewControllerInteractiveTransitioning?

    // MARK:- Initializers

    init(duration: TimeInterval?, animation: (() -> ())?, completion: ((Bool) -> ())?) { //}, interactionController: UIViewControllerInteractiveTransitioning?) {
        self.duration = duration
        self.animation = animation
        self.completion = completion
        //        self.interactionController = interactionController
    }

    // MARK:- UIViewControllerAnimatedTransitioning

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let presentingViewController = transitionContext.viewController(forKey: .to)!
        let presentedViewController = transitionContext.viewController(forKey: .from)!

        let containerView = transitionContext.containerView
        let scale: CGFloat = 1 - (Constants.topInsetForPresentingView * 2 / presentingViewController.view.frame.height)

        let initialFrameForRoundedPresentingView = CGRect(
            x: presentingViewController.view.frame.origin.x,
            y: presentingViewController.view.frame.origin.y,
            width: presentingViewController.view.frame.width,
            height: Constants.cornerRadius)
        let roundedViewForPresentingView = RoundedView(frame: initialFrameForRoundedPresentingView)
        roundedViewForPresentingView.translatesAutoresizingMaskIntoConstraints = false
        //        containerView.addSubview(roundedViewForPresentingView)

        presentingViewController.view.layer.masksToBounds = true
        presentingViewController.view.layer.cornerRadius = Constants.cornerRadius

        if presentingViewController.responds(to: NSSelectorFromString("getDragToDismissTransformAtTouchUp")),
            let transformObjc = presentingViewController.perform(NSSelectorFromString("getDragToDismissTransformAtTouchUp")).takeUnretainedValue() as? CGAffineTransform.CGAffineTransformObjc,
            let transform = CGAffineTransform(objcRepresentation: transformObjc) {

            presentingViewController.view.transform = CGAffineTransform(scaleX: scale, y: scale).concatenating(CGAffineTransform(translationX: 0, y: 20)).concatenating(transform)
        } else {
            presentingViewController.view.transform = CGAffineTransform(scaleX: scale, y: scale).concatenating(CGAffineTransform(translationX: 0, y: 20))
        }

        let finalFrameForPresentingView = transitionContext.finalFrame(for: presentingViewController)
        let finalFrameForRoundedViewForPresentingView = CGRect(
            x: finalFrameForPresentingView.origin.x,
            y: finalFrameForPresentingView.origin.y,
            width: finalFrameForPresentingView.width,
            height: Constants.cornerRadius)

        let offScreenFrame = CGRect(x: 0, y: containerView.bounds.height, width: containerView.bounds.width, height: containerView.bounds.height)

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: .curveEaseOut,
            animations: { [weak self] in
                //                roundedViewForPresentingView.cornerRadius = 0
                roundedViewForPresentingView.frame = finalFrameForRoundedViewForPresentingView
                presentingViewController.view.alpha = 1
                presentingViewController.view.transform = .identity
                presentingViewController.view.layer.cornerRadius = 0

                presentedViewController.view.frame = offScreenFrame
                self?.animation?()
            }, completion: { [weak self] finished in
                roundedViewForPresentingView.removeFromSuperview()
                transitionContext.completeTransition(finished)
                self?.completion?(finished)
        })
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration ?? Constants.defaultAnimationDuration
    }

}
