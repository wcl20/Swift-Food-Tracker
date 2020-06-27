//
//  RatingController.swift
//  FoodTracker
//
//  Created by LeeAlvis on 22/6/2020.
//

import UIKit

@IBDesignable class RatingController: UIStackView {
    
    // MARK: Properties
    
    private var stars = [UIButton]()
    var rating = 0 {
        didSet { update() }
    }
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet { setup() }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet { setup() }
    }

    // MARK: Initialization
    
    // Programatically initializing the view
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    // Allowing the view to be loaded by storyboard
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: Private Methods
    
    private func setup() {
        // Clear old buttons
        for star in stars {
            removeArrangedSubview(star)
            star.removeFromSuperview()
        }
        stars.removeAll()
        // Load images
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "FilledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "EmptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "HighlightedStar", in: bundle, compatibleWith: self.traitCollection)
        // Create buttons
        for i in 0..<starCount {
            let star = UIButton()
            star.setImage(emptyStar, for: .normal)
            star.setImage(filledStar, for: .selected)
            star.setImage(highlightedStar, for: .highlighted)
            star.setImage(highlightedStar, for: [.highlighted, .selected])
            // Disable automatically generated constraints
            star.translatesAutoresizingMaskIntoConstraints = false
            // Define button height and width
            star.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            star.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            // Define accessibility label
            star.accessibilityLabel = "Set \(i+1) star rating"
            // Define button action
            star.addTarget(self, action: #selector(RatingController.onClick(button:)), for: .touchUpInside)
            // Add button to horizontal stack view
            addArrangedSubview(star)
            // Add button to buttons
            stars.append(star)
        }
        update()
    }
    
    private func update() {
        for (i, star) in stars.enumerated() {
            star.isSelected = i < rating
            // Define accessibility hint
            let hint: String?
            hint = i + 1 == rating ? "Tap to reset rating to 0" : nil
            star.accessibilityHint = hint
            // Define accessibility value
            let value: String
            switch (rating) {
            case 0:
                value = "No rating set"
            case 1:
                value = "1 star set"
            default:
                value = "\(rating) stars set"
            }
            star.accessibilityValue = value
        }
    }
    
    // Called when user taps on one of the stars
    @objc func onClick(button: UIButton) {
        // Get index of the tapped star
        guard let index = stars.firstIndex(of: button) else {
            fatalError("\(button) is not in array")
        }
        // Update rating
        rating = index + 1 == rating ? 0 : index + 1
    }

}
