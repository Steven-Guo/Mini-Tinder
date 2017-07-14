//
//  CardView.swift
//  Mini-Tinder
//
//  Created by Minxin Guo on 7/13/17.
//  Copyright © 2017 Minxin Guo. All rights reserved.
//

import UIKit

@IBDesignable
class CardView: UIView {
    
    private struct Constants {
        static let rotationDegreesInRadian = CGFloat(55.0 / 180.0)
    }
    
    private lazy var rotationDivisor: CGFloat = {
        return ((self.superview?.frame.width)! / 2) / Constants.rotationDegreesInRadian
    }()
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet { self.layer.cornerRadius = cornerRadius }
    }
    
    var thumbImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGesture()
        setupUI()
        setupThumbView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGesture()
        setupThumbView()
    }
    
    private func setupUI() {
        backgroundColor = createRandomColor()
        layer.cornerRadius = 22
    }
    
    private func setupThumbView() {
        thumbImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        thumbImageView.center = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        self.addSubview(thumbImageView)
    }
    
    private func setupGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        self.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        let card = gesture.view!
        let point = gesture.translation(in: superview)
        card.center = CGPoint(x: (superview?.center.x)! + point.x, y: (superview?.center.y)! + point.y)
        
        // Use to track whether user drag to left or right
        let xFromCenter = self.center.x - (superview?.center.x)!
        if xFromCenter > 0 {
            thumbImageView.image = UIImage(named: "like")
        } else {
            thumbImageView.image = UIImage(named: "unlike")
        }
        thumbImageView.alpha = abs(xFromCenter) / (superview?.center.x)!
        card.transform = CGAffineTransform(rotationAngle: xFromCenter / rotationDivisor)
        
        switch gesture.state {
        case .ended:
            // Animate off the screen
            if card.center.x < 80 {
                // Move off to the left side
                UIView.animate(withDuration: 0.3, animations: {
                    card.center = CGPoint(x: card.center.x - 300, y: card.center.y + 100)
                    card.alpha = 0
                }, completion: { _ in
                    self.removeFromSuperview()
                })
            } else if card.center.x > UIScreen.main.bounds.width - 80 {
                // Move to right
                UIView.animate(withDuration: 0.3, animations: {
                    card.center = CGPoint(x: card.center.x + 300, y: card.center.y + 100)
                    card.alpha = 0
                }, completion: { _ in
                    self.removeFromSuperview()
                })
            } else {
                // Reset
                UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                    self.center = (self.superview?.center)!
                    self.thumbImageView.alpha = 0
                    self.transform = .identity
                }, completion: nil)
            }
        default:
            break
        }
    }
    
    private func createRandomColor() -> UIColor {
        let r = CGFloat(drand48())
        let g = CGFloat(drand48())
        let b = CGFloat(drand48())
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}
