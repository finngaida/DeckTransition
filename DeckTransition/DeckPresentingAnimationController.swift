//
//  DeckPresentingAnimationController.swift
//  DeckTransition
//
//  Created by Harshil Shah on 15/10/16.
//  Copyright © 2016 Harshil Shah. All rights reserved.
//

import UIKit

final class DeckPresentingAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
	
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
        let presentingViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let presentedViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        let containerView = transitionContext.containerView
        presentingViewController.view.layer.masksToBounds = true

        let scale: CGFloat = 1 - (Constants.topInsetForPresentingView * 2 / presentingViewController.view.frame.height)
        let offset: CGFloat = Platform.isEdgeless ? 20 : 0
        
        containerView.addSubview(presentedViewController.view)
        presentedViewController.view.frame = transitionContext.finalFrame(for: presentedViewController)
        presentedViewController.view.transform = CGAffineTransform(translationX: 0, y: containerView.frame.height)
        
        animateLin(duration: transitionDuration(using: transitionContext), delay: 0, completion: { [weak self] in
            transitionContext.completeTransition(true)
            self?.completion?(true)
        }) { [weak self] in
            presentingViewController.view.transform = CGAffineTransform(scaleX: scale, y: scale).concatenating(CGAffineTransform(translationX: 0, y: offset))
            presentingViewController.view.alpha = Constants.alphaForPresentingView
            presentingViewController.view.layer.cornerRadius = Constants.cornerRadius

            presentedViewController.view.transform = .identity

            self?.animation?()
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration ?? Constants.defaultAnimationDuration
    }
    
}
