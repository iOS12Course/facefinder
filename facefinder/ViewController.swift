//
//  ViewController.swift
//  facefinder
//
//  Created by Ricardo Herrera Petit on 4/3/19.
//  Copyright © 2019 Ricardo Herrera Petit. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var messagelbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.startAnimating()
    }


}

