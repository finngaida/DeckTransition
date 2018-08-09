//
//  Constants.swift
//  DeckTransition
//
//  Created by Harshil Shah on 04/08/17.
//  Copyright © 2017 Harshil Shah. All rights reserved.
//

struct Constants {
    
    /// Default duration for present and dismiss animations when the user hasn't
    /// specified one
    static let defaultAnimationDuration: TimeInterval = 0.3
    
    /// The corner radius applied to the presenting and presented view
    /// controllers's views
    static let cornerRadius: CGFloat = 8
    
    /// The alpha value of the presented view controller's view
    static let alphaForPresentingView: CGFloat = 0.8
    
    /// The inset of the presenting view controller's view from the top of the
    /// containerView. The same inset is shown at the bottom, however the naming
    /// is explicitly for the top inset to prevent confusion about whether it's
    /// the total inset or just the inset from either edge
    static let topInsetForPresentingView: CGFloat = 20
    
    /// As best as I can tell using my iPhone and a bunch of iOS UI templates I
    /// came across online, 28 points is the distance between the top edge of
    /// the screen and the top edge of the modal view
    static let topOffsetForPresentedView: CGFloat = 28

    static let isX = UIScreen.main.bounds.height == 812

    static let dismissDragThreshold: CGFloat = 200

    static let dismissDragVelocityThreshold: CGFloat = 2000
}

// MARK: helper func
/// Mimic the Principle default animation curve
func animateLin(duration: TimeInterval = 0.25, delay: TimeInterval = 0, completion: (()->())? = nil, animations: @escaping () -> Void) {
    let animator = UIViewPropertyAnimator(duration: duration, controlPoint1: CGPoint(x: 0.25, y: 0.1), controlPoint2: CGPoint(x: 0.25, y: 1), animations: animations)
    if let c = completion {
        animator.addCompletion({ _ in
            c()
        })
    }
    animator.startAnimation(afterDelay: delay)
}
