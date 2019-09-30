//
//  ThirdViewController.swift
//  New Flex Space v5
//
//  Created by Admin on 6/21/19.
//  Copyright © 2019 Admin. All rights reserved.
////

import UIKit
import Firebase

class ThirdViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
 
    
    @IBOutlet weak var officePicker: UIPickerView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var rememberOfficeSwitch: UISwitch!
    @IBOutlet weak var newReservationLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var translucentCard: UIImageView!
    
    let db = Firestore.firestore()
    
    var pickerData = [String]()
    var floorData = [String]()
    var name = String()
    var date = String()
    var rememberedOffice = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        translucentCard.layer.cornerRadius = 20
        dateLabel.text = "For \(date)"
        self.officePicker.delegate = self
        self.officePicker.dataSource = self
        continueButton.layer.cornerRadius = continueButton.bounds.size.height / 2
        rememberOfficeSwitch.setOn(false, animated: true)
        
        //Function to get all of the available Offices in the database
        db.collection("Offices").getDocuments()
        {
            (querySnapshot, err) in
            if let err = err
            {
                print("Error getting offices to populate office picker: \(err)");
            }
            else
            {
                self.pickerData.removeAll()
                for document in querySnapshot!.documents {
                    self.pickerData.append(document.documentID);
                }
                self.officePicker.reloadInputViews()
                self.officePicker.reloadAllComponents()
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        if(pickerData.count == 0)
//        {
//            pickerData.append("There are no offices in the database")
//        }
//        return pickerData[row]
//    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if(pickerData.count == 0)
        {
            pickerData.append("There are no offices in the database")
        }
    
        let font = UIFont.systemFont(ofSize: 50, weight: UIFont.Weight.black)
//        let shadow = NSShadow()
//        shadow.shadowColor = UIColor.blue
//        shadow.shadowBlurRadius = 5
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.white,
//            .shadow: shadow
        ]
        
        return NSAttributedString(string: pickerData[row], attributes: attributes)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is FourthViewController
        {
            let vc = segue.destination as? FourthViewController
            
            //These next two lines get the current value selected by the officePicker
            let officeIndex = officePicker.selectedRow(inComponent: 0)
            let officeChosen = (pickerView(officePicker, attributedTitleForRow: officeIndex, forComponent: officeIndex))!
            vc?.office = officeChosen.string

            vc?.date = self.date
            vc!.name = self.name
            
            for office in pickerData
            {
                vc?.officePickerData.append(office)
            }
            
            //Sets the users office as part of their profile so it can be remembered
            var urlOfficeChosen = "http://"
            var modifiedOfficeChosen = String()
            for char in officeChosen.string
            {
                if (char == " "){
                    modifiedOfficeChosen.append("_")
                }
                else{
                    modifiedOfficeChosen.append(char)
                }
            }
            if (rememberOfficeSwitch.isOn)
            {
                urlOfficeChosen = "http://" + modifiedOfficeChosen
            }
            let url = URL(string: urlOfficeChosen)
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.photoURL = url
            changeRequest?.commitChanges { (error) in
                print("Error in saving the users remembered office")
            }
            
        }
    }
    
    
    
}
