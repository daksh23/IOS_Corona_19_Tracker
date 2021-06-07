//
//  InfoVC.swift
//  TakeHome
//
//  Created by Nehal Patel on 06/02/1943 Saka.
//

import UIKit

class InfoVC: UIViewController {

    @IBOutlet weak var qOne: UITextField!
    @IBOutlet weak var qTwo: UITextField!
    @IBOutlet weak var qThree: UITextField!
    @IBOutlet weak var qFour: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    @IBAction func submit(_ sender: UIButton) {
        
        let q1 = qOne.text
        let q2 = qTwo.text
        let q3 = qThree.text
        let q4 = qFour.text
        var message = "takecare"
        
        if(q1 == "YES" && q3 == "YES" && q2 == "YES" && q4 == "YES" ){
            message = "High Risk"
        }
        if(q1 == "NO" && q2 == "NO" && q3 == "YES" && q4 == "NO" ){
            message = "Low Risk"
        }
        if(q1 == "YES" && q3 == "YES" && q2 == "NO" && q4 == "NO"){
            message = "Medium Risk"
        }
        if(q1 == "NO" && q2 == "NO" && q3 == "NO" && q4 == "NO" ){
            message = "Safe"
        }
        
        
        let alert = UIAlertController(title: "Our Prediction", message: message, preferredStyle: .alert)
        
        //ok action
                let actionOK  = UIAlertAction(title: "OK", style: .default) { (action) in }
                
                //add actions
                alert.addAction(actionOK)
               
                //show model of alert
                present(alert, animated: true, completion: nil)
        
    }
    
}
