//
//  LevelSelectorViewController.swift
//  Number Line
//
//  Created by Karin on 3/29/19.
//  Copyright © 2019 Tian Liu. All rights reserved.
//

import UIKit

class LevelSelectorViewController: UIViewController {

    @IBAction func ExitToStart(_ sender: Any) {
        performSegue(withIdentifier: "LStoStart", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add background image
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "stars.jpg")!)
    }
}
