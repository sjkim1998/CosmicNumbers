//
//  LevelTwoTutorial.swift
//  Number Line
//
//  Created by Tian Liu on 5/6/19.
//  Copyright © 2019 Tian Liu. All rights reserved.
//

import UIKit
import AVFoundation

class LevelTwoTutorial: UIViewController {
    
    // This is the tutorial page for level two
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var one: UILabel!
    @IBOutlet weak var two: UILabel!
    @IBOutlet weak var note: UILabel!
    @IBOutlet weak var noteTwo: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var back: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.accessibilityElements = [label, one, two, note, noteTwo, nextBtn, back];
    }
}
