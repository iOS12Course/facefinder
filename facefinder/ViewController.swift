//
//  ViewController.swift
//  facefinder
//
//  Created by Ricardo Herrera Petit on 4/3/19.
//  Copyright © 2019 Ricardo Herrera Petit. All rights reserved.
//

import UIKit
import Vision

class ViewController: UIViewController {
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var messagelbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.hidesWhenStopped = true
        setupImageView()
    }
    
    func setupImageView() {
        guard let image = UIImage(named: "faces") else { return }
        
        guard let cgImage = image.cgImage else
        {
            debugPrint("Could not find cgImage")
            return
        }
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        
        let scaledHeight = (view.frame.width / image.size.width) * image.size.height
        
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: scaledHeight)
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2
        view.addSubview(imageView)
        
        spinner.startAnimating()
        
        DispatchQueue.global(qos: .background).async {
             self.performVisionRequest(forImage: cgImage, with: scaledHeight)
        }
       
    }
    
    func createFaceOutline(for rectangle: CGRect) {
        let yellowView = UIView()
        yellowView.backgroundColor = .clear
        yellowView.layer.borderColor = UIColor.yellow.cgColor
        yellowView.layer.borderWidth = 3
        yellowView.layer.cornerRadius = 5
        yellowView.alpha = 0.0
        yellowView.frame = rectangle
        self.view.addSubview(yellowView)
        
        UIView.animate(withDuration: 0.3) {
            yellowView.alpha = 0.75
            self.spinner.alpha = 0.0
            self.messagelbl.alpha = 0.0
        }
        
        self.spinner.stopAnimating()
    }

    func performVisionRequest(forImage image: CGImage, with scaledHeight:CGFloat ) {
        let faceDetectionRequest = VNDetectFaceRectanglesRequest { (request, error) in
            if let error = error {
                debugPrint("Failed to detect face:", error)
                return
            }
            
            request.results?.forEach({ (result) in
                guard let faceObservation = result as? VNFaceObservation else { return }
                DispatchQueue.main.async {
                    let width = self.view.frame.width * faceObservation.boundingBox.width
                    let height = scaledHeight * faceObservation.boundingBox.height
                    let x = self.view.frame.width * faceObservation.boundingBox.origin.x
                    let y = scaledHeight * (1 - faceObservation.boundingBox.origin.y) - height
                    
                    let faceRectangle = CGRect(x: x, y: y, width: width, height: height)
                    self.createFaceOutline(for: faceRectangle)
                }
                
               
            })
        }
        
        let imageRequestHandler = VNImageRequestHandler(cgImage: image, options: [:])
        
        do {
           try imageRequestHandler.perform([faceDetectionRequest])
        } catch {
            debugPrint("Failed to perform Image request", error.localizedDescription)
            return
        }
        
       
    }

}

