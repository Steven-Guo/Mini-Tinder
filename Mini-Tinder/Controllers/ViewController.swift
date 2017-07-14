//
//  ViewController.swift
//  Mini-Tinder
//
//  Created by Minxin Guo on 7/3/17.
//  Copyright © 2017 Minxin Guo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createCards(count: 50)
    }
    
    @IBAction func resetButtonAction(_ sender: Any) {
        createCards(count: 50)
    }
    
    private func createCards(count: Int) {
        for _ in 0..<count {
            let cardView = CardView(frame: CGRect(x: 0, y: 0, width: 300, height: 420))
            cardView.center = view.center
            view.addSubview(cardView)
        }
    }
}

