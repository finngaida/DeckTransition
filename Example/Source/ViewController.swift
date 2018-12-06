//
//  ViewController.swift
//  DeckTransition
//
//  Created by Harshil Shah on 10/15/2016.
//  Copyright (c) 2016 Harshil Shah. All rights reserved.
//

import UIKit
import DeckTransition

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 40, weight: UIFontWeightHeavy)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "This is the presenting view controller.\n\nTap anywhere to show the modal."
        view.addSubview(label)
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        label.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.viewWasTappedx))
        view.addGestureRecognizer(tap)

    }

    func viewWasTappedx() {
        self.performSegue(withIdentifier: "x", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dismiss = segue as? DeckSegue else { return }
        dismiss.dismissAnimation = {
            self.view.backgroundColor = .red
        }
    }

    func viewWasTapped() {
        let modal = ModalViewController()
        let transitionDelegate = DeckTransitioningDelegate(dismissAnimation: {
            self.view.backgroundColor = .red
        })
        modal.transitioningDelegate = transitionDelegate
        modal.modalPresentationStyle = .custom
        present(modal, animated: true, completion: nil)
    }
}

