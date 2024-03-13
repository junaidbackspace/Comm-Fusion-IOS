//
//  Lessons_LevelsViewController.swift
//  SimpleWebRTC
//
//  Created by Umer Farooq on 27/02/2024.
//  Copyright © 2024 n0. All rights reserved.
//

import UIKit

class Lessons_LevelsViewController: UIViewController {

    @IBAction func btnback(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    @IBOutlet weak var viewNumbers: UIView!
    @IBOutlet weak var viewAlphabets: UIView!

   
    
    var trainingname = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewNumbers.layer.cornerRadius = 20
        viewNumbers.layer.borderWidth = 1.0
        viewNumbers.layer.borderColor = UIColor.black.cgColor
        
        viewAlphabets.layer.cornerRadius = 20
        viewAlphabets.layer.borderWidth = 1.0
        viewAlphabets.layer.borderColor = UIColor.black.cgColor
        
       
    }
    

    
    @IBAction func btn_Numbers(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(identifier: "LessonsGallery") as! LessonsListViewController
        controller.trainingname = "Number"
        controller.lesson_level = "Beginner"
        controller.hidesBottomBarWhenPushed = true
        controller.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func btn_Alphabets(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(identifier: "LessonsGallery") as! LessonsListViewController
        controller.trainingname = "Alphabets"
        controller.lesson_level = "Beginner"
        controller.hidesBottomBarWhenPushed = true
        controller.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(controller, animated: true)
    }
   
    

}
