//
//  Line.swift
//  Number Line
//
//  Created by Tian Liu on 2/21/19.
//  Copyright © 2019 Tian Liu. All rights reserved.
//

import UIKit

class Line: UIView {
    var line = UIBezierPath()
    var points = [UIBezierPath]()
    var i = 0
    var j = 0
    
    override func draw(_ rec: CGRect) {
        print("attempt draw")
        graph()
        print("done draw")
    }
    
    func graph() {
        // Find the screen width and the distance between points
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let distance = (screenWidth - 200) / 5
        
        line.move(to: .init(x: 100, y: bounds.height / 2))
        line.addLine(to: .init(x: bounds.width - 100, y: bounds.height / 2))
        UIColor.black.setStroke()
        line.lineWidth = 10
        line.stroke()
        
        while (i < 6) {
            points.append(UIBezierPath())
            let xdist = distance*CGFloat(i) + 100
            
            points[i].move(to: .init(x: xdist, y: bounds.height / 2))
            points[i].addLine(to: .init(x: xdist, y: 450))
            UIColor.black.setStroke()
            points[i].lineWidth = 10
            points[i].stroke()
            
            i = i+1
        }
    }
}
