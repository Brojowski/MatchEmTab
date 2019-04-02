//
//  ConfigViewController.swift
//  MatchEmTab
//
//  Created by Alex Gajowski on 4/1/19.
//  Copyright © 2019 alex. All rights reserved.
//

import UIKit

class ConfigViewController: UIViewController {
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var gameLengthLabel: UILabel!
    
    var gameVC: GameViewController?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        gameVC = self.tabBarController!.viewControllers![0]
            as? GameViewController
        gameVC?.view.backgroundColor = .blue
    }
    
    @IBAction func onRectSpeedChanged(_ sender: UISlider) {
    
    }
    
    @IBAction func onBackgroundColorChanged(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0) {
            gameVC?.view?.backgroundColor = .white
        } else {
            gameVC?.view?.backgroundColor = .black
        }
    }
    
    @IBAction func onGameLengthChanged(_ sender: UISlider) {
        
    }
    
    @IBAction func onMaxSizeChange(_ sender: Any) {
        
    }
}
