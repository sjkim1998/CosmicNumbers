//
//  ViewController.swift
//  COMP585Number
//
//  Created by user914671 on 2/22/19.
//  Copyright © 2019 user914671. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var i = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the background image
        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"background.jpg")!)
        
        // Find the screen width and distance between points
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let distance = (screenWidth - 200) / 5
        
        // Defines the question
        let question = UILabel(frame: CGRect(x: 200, y: 200, width: 800, height: 40))
        question.isAccessibilityElement = true
        question.text = "What is the answer to 1+2 = "
        question.font = UIFont(name: "Arial-BoldMT", size: 55)
        self.view.addSubview(question)
        question.accessibilityTraits = UIAccessibilityTraits.playsSound
        question.isUserInteractionEnabled = true
        question.accessibilityLabel = "What is the answer to 1+2 = "
        question.accessibilityHint = "Describes the question"
        
        let answer = UITextField(frame: CGRect(x: 945, y: 195, width: 200, height: 50))
        answer.placeholder = "Enter text here"
        answer.font = UIFont(name: "Arial-BoldMT", size: 25)
        answer.borderStyle = UITextField.BorderStyle.roundedRect
        answer.keyboardType = UIKeyboardType.default
        answer.returnKeyType = UIReturnKeyType.done
        self.view.addSubview(answer)
        
        // Tap - interaction
//        let tap = UITapGestureRecognizer(target: self, action: Selector("boySelect:"))
        
        // Create 5 labels and make them accessible
        while (i < 6) {
            let xdist = distance*CGFloat(i) + 87.5
            let label = UILabel(frame: CGRect(x: xdist, y: 550, width: 40, height: 40))
            label.isAccessibilityElement = true
            label.text = String(i)
            label.font = UIFont(name: "Arial-BoldMT", size: 45)
            self.view.addSubview(label)
            label.accessibilityTraits = UIAccessibilityTraits.playsSound
            label.isUserInteractionEnabled = true
            label.accessibilityLabel = String(i)
            label.accessibilityHint = "Describes the number"
//            label.addGestureRecognizer(tap)
            i = i+1
        }
    }
    
//    func boySelect(sender:UITapGestureRecognizer) {
//
//    }
}
