//
//  DeckSegue.swift
//  DeckTransition
//
//  Created by Harshil Shah on 15/10/16.
//  Copyright © 2016 Harshil Shah. All rights reserved.
//

import UIKit

/// A segue to implement the deck transition via Storyboards
public final class DeckSegue: UIStoryboardSegue {

    public var dismissAnimation: (() -> ())?
    public var dismissCompletion: ((Bool) -> ())?
    var transition: UIViewControllerTransitioningDelegate!

    override public func perform() {
        transition = DeckTransitioningDelegate(dismissAnimation: dismissAnimation, dismissCompletion: dismissCompletion)
        destination.transitioningDelegate = transition
        destination.modalPresentationStyle = .custom
        source.present(destination, animated: true, completion: nil)
    }

}
