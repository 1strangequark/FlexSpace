//
//  SixthViewController.swift
//  New Flex Space v5
//
//  Created by Admin on 7/1/19.
//  Copyright © 2019 Admin. All rights reserved.

import UIKit
import Firebase

var personSelected = String()
var dayOnetext = String()
var dayTwotext = String()

class SixthViewController: UIViewController {
    @IBOutlet weak var goBackButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let db = Firestore.firestore()
    
    var loadsCompleted = 0
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dayOneLabel: UILabel!
    @IBOutlet weak var dayTwoLabel: UILabel!
    @IBOutlet weak var dayOneOfficeLabel: UILabel!
    @IBOutlet weak var dayTwoOfficeLabel: UILabel!
    @IBOutlet weak var dayOneFloorLabel: UILabel!
    @IBOutlet weak var dayTwoFloorLabel: UILabel!
    @IBOutlet weak var dayOneDeskLabel: UILabel!
    @IBOutlet weak var dayTwoDeskLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goBackButton.layer.cornerRadius = goBackButton.bounds.size.height / 2
    
        nameLabel.text = personSelected
        dayOneLabel.text = dayOnetext
        dayTwoLabel.text = dayTwotext
        //populates the first day of results
        
        var docRef = db.collection("Names").document(personSelected).collection("Date").document(dayOnetext)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Search Result One Document data: \(dataDescription)")
                self.dayOneOfficeLabel.text = "Office: " + String(document.get("Office") as? String ?? "")
                self.dayOneFloorLabel.text = "Floor: " + String(document.get("Floor") as? Int ?? 0)
                if(self.dayOneOfficeLabel.text == "")
                {
                    self.dayOneOfficeLabel.text = "No reservation found for this day."
                }
                self.dayOneDeskLabel.text = "Desk: " + String(document.get("Desk") as? String ?? "")
                
            } else {
                print("Search Result One Document does not exist")
                self.dayOneOfficeLabel.text = document?.get("Floor") as? String ?? "No reservation found for this day."
            }
            self.doneLoading()
        }
        
        //populates the second day of results
        docRef = db.collection("Names").document(personSelected).collection("Date").document(dayTwotext)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Search Result Two Document data: \(dataDescription)")
                self.dayTwoOfficeLabel.text = "Office: " + String(document.get("Office") as? String ?? "")
                self.dayTwoFloorLabel.text = "Floor: " + String(document.get("Floor") as? Int ?? 0)
                if(self.dayTwoOfficeLabel.text == "")
                {
                    self.dayTwoOfficeLabel.text = "No reservation found for this day."
                }
                self.dayTwoDeskLabel.text = "Desk: " + String(document.get("Desk") as? String ?? "")
            } else {
                print("Search Result Two Document does not exist")
                self.dayTwoOfficeLabel.text = document?.get("Floor") as? String ?? "No reservation found for this day."
            }
            self.doneLoading()
        }
    }
    
    func doneLoading()
    {
        loadsCompleted += 1
        if loadsCompleted == 2
        {
            self.activityIndicator.stopAnimating()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
