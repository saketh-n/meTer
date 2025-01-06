//
//  ViewController.swift
//  meTer
//
//  Created by Saketh Nimmagadda on 1/4/25.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBAction func upload(_ sender: Any) {
        let cameraAuthStatus = AVCaptureDevice.authorizationStatus(for: .video)

            switch cameraAuthStatus {
            case .notDetermined:
                // Request permission
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        DispatchQueue.main.async {
                            self.openCamera()
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.showPermissionDeniedAlert()
                        }
                    }
                }
            case .restricted, .denied:
                // Show an alert explaining the need for camera access
                showPermissionDeniedAlert()
            case .authorized:
                // Open the camera
                openCamera()
            @unknown default:
                break
            }
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.cameraDevice = .front
            
            imagePicker.cameraFlashMode = .off
            
            present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Camera Not Available",
                                          message: "This device doesn't have a camera.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }

    
    func showPermissionDeniedAlert() {
        let alert = UIAlertController(
            title: "Camera Access Denied",
            message: "Camera access is required to take a selfie. Please enable camera access in Settings.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        })
        present(alert, animated: true)
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            yourPhoto.image = image
            generateTLevel()
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    
    func generateTLevel() {
        tLabel.text = "Your T Level is 2500 ng/dL GigaChad"
    }
    
    @IBOutlet weak var tLabel: UILabel!
    @IBOutlet weak var yourPhoto: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tLabel.text = ""
    }


}

