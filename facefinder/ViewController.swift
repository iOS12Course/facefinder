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
        guard let image = UIImage(named: "face") else { return }
        
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
        
        performVisionRequest(forImage: cgImage)
    }

    func performVisionRequest(forImage image: CGImage) {
        let faceDetectionRequest = VNDetectFaceRectanglesRequest { (request, error) in
            if let error = error {
                debugPrint("Failed to detect face:", error)
                return
            }
            
            request.results?.forEach({ (result) in
                guard let faceObservation = result as? VNFaceObservation else { return }
                
                debugPrint("Bounding box:" , faceObservation.boundingBox)
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

