//
//  LaundryDetailViewController.swift
//  pennapps-xx-demo
//
//  Created by Dominic Holmes on 9/6/19.
//  Copyright © 2019 Dominic Holmes. All rights reserved.
//

import UIKit

class LaundryDetailViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    var hall: LaundryRoom?
    
    @IBAction func didPressButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sliderDidChangeValue(sender: UISlider) {
        idLabel.text = String(sender.value)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameLabel.text = hall?.hallName
        locationLabel.text = hall?.location
        idLabel.text = "\(hall?.id ?? 0)"
    }
}
