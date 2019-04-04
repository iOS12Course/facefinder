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
        spinner.hidesWhenStopped = true
        setupImageView()
    }
    
    func setupImageView() {
        guard let image = UIImage(named: "face") else { return }
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        
        let scaledHeight = (view.frame.width / image.size.width) * image.size.height
        
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: scaledHeight)
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2
        view.addSubview(imageView)
        
        spinner.startAnimating()
    }


}

