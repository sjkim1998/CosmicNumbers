//
//  StartScreenViewController.swift
//  Number Line
//
//  Created by Karin on 3/20/19.
//  Copyright © 2019 Tian Liu. All rights reserved.
//

import UIKit
import AVFoundation

class StartScreenViewController: UIViewController {

    @IBOutlet weak var startBtn: UIButton!
    
    // Directs player to level selection if he/she clicks start
    @IBAction func StartButton(_ sender: Any) {
        performSegue(withIdentifier: "LevelSelect", sender: self)
    }
    
    // Directs player to setting if he/she clicks start
    @IBAction func SettingsButton(_ sender: Any) {
         performSegue(withIdentifier: "StartToSettings", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

