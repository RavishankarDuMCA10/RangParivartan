//
//  ViewController.swift
//  RangParivartanExamples
//
//  Created by Ravi Shankar Kushwaha on 01/06/20.
//  Copyright © 2020 Self. All rights reserved.
//

import UIKit
import RangParivartan

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print()
    }
    
    
    @IBAction func openButtonAction(_ sender: Any) {
        let vc = RPViewController(image: UIImage(named: "colorful.jpg")!)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
    }

}

