//
//  ViewController.swift
//  pennapps-xx-demo
//
//  Created by Dominic Holmes on 9/6/19.
//  Copyright © 2019 Dominic Holmes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func stepperChanged(_ sender: UIStepper) {
        label.text = "Step: \(sender.value)"
    }
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        label.isEnabled = sender.isOn
    }

}

