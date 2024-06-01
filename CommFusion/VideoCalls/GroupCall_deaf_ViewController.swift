//
//  GroupCall_deaf_ViewController.swift
//  CommFusion
//
//  Created by Umer Farooq on 01/06/2024.
//  Copyright © 2024 n0. All rights reserved.
//

import UIKit
import AVFoundation
class GroupCall_deaf_ViewController: UIViewController, AVCapturePhotoCaptureDelegate {

    var user = User()
    var serverWrapper = APIWrapper()
    var captureTimer: Timer?
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var capturedImage: UIImage?
   
    
    @IBOutlet weak var Profilepic_Firstuser : UIImageView!
    @IBOutlet weak var Profilepic_Seconduser : UIImageView!
    @IBOutlet weak var cameraView : UIView!
    @IBOutlet weak var textMessage : UITextView!
    
    
    
    @IBAction func hangupCall (_ sender : Any)
    {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserData(userid: 2, userno: 1)
        fetchUserData(userid: 1, userno: 2)
        
        setupCamera()
        captureSession.startRunning()
        
        
//        self.captureTimer = Timer.scheduledTimer(timeInterval: 1.0 , target: self, selector: #selector(self.takePicture), userInfo: nil, repeats: true)
        
      
       
    }
    
    func setupCamera() {
           // Setup camera
           captureSession = AVCaptureSession()
           captureSession.sessionPreset = .medium

           guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
               print("Unable to access front camera!")
               return
           }

           do {
               let input = try AVCaptureDeviceInput(device: frontCamera)
               stillImageOutput = AVCapturePhotoOutput()

               if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                   captureSession.addInput(input)
                   captureSession.addOutput(stillImageOutput)
                   setupLivePreview()
               }
           } catch let error  {
               print("Error Unable to initialize front camera:  \(error.localizedDescription)")
           }
       }

    func setupLivePreview() {
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer.videoGravity = .resizeAspectFill
            videoPreviewLayer.connection?.videoOrientation = .portrait

            // Insert the videoPreviewLayer at the lowest level
            cameraView.layer.insertSublayer(videoPreviewLayer, at: 0)

            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession.startRunning()
                DispatchQueue.main.async {
                    self.videoPreviewLayer.frame = self.cameraView.bounds
                    self.videoPreviewLayer.masksToBounds = true
                }
            }
        }

       override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()
           videoPreviewLayer.frame = cameraView.bounds
       }

       @objc func takePicture() {
           let settings = AVCapturePhotoSettings()
           stillImageOutput.capturePhoto(with: settings, delegate: self)
       }

       func stopCamera() {
           captureSession.stopRunning()
       }

       // AVCapturePhotoCaptureDelegate method
       func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
           guard let imageData = photo.fileDataRepresentation() else { return }
           let image = UIImage(data: imageData)

           // Process the image as needed, e.g., assign to an UIImageView
           let imageView = UIImageView(image: image)
           imageView.frame = cameraView.bounds
           imageView.contentMode = .scaleAspectFit
           cameraView.addSubview(imageView)
       }
   
   

    func fetchUserData(userid : Int , userno : Int) {
            let userID = userid
            
            let Url = "\(Constants.serverURL)/user/userdetails/\(userID)"
            print("URL: "+Url)
          
            let url = URL(string: Url)!
            
            self.serverWrapper.fetchUserInfo(baseUrl: url, structure: singleUserInfo.self) { userInfo, error in
                if let error = error {
                    print("inner URL: \(Url)")
                    print("Error in receiving:", error.localizedDescription)
                } else if let userObject = userInfo {
                    print("JSON Data:", userObject)
                    
                    self.processContactsData(userObject , userno: userno)
                } else {
                    print("No data received from the server")
                }
            }
        }

    func processContactsData(_ userObject: singleUserInfo , userno : Int) {
            print("Processing user data")
//            user.Fname = userObject.fname
//            user.Lname = userObject.lname
//
            user.ProfilePicture = userObject.profile_picture

            
            let group = DispatchGroup()
              group.enter()

            let urlString = "\(Constants.serverURL)\(user.ProfilePicture)"

            if let url = URL(string: urlString) {
                
                if userno == 1{
               Profilepic_Firstuser.kf.setImage(with: url, placeholder: UIImage(named: "No image found"))

                   
                }
                else{
                    Profilepic_Seconduser.kf.setImage(with: url, placeholder: UIImage(named: "No image found"))

                        
                    
                }
            } else {
                // Handle invalid URL
                print("Invalid URL:", urlString)
            }
            
            group.leave()
        }


}
