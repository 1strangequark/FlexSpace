//
//  FifthViewController.swift
//  New Flex Space v5
//
//  Created by Admin on 6/28/19.
//  Copyright © 2019 Admin. All rights reserved.
////

import UIKit
import Firebase

var searchBarText = ""

class FifthViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var d1Button: UIButton!
    @IBOutlet weak var d2Button: UIButton!
    @IBOutlet weak var d3Button: UIButton!
    @IBOutlet weak var d4Button: UIButton!
    @IBOutlet weak var d5Button: UIButton!
    @IBOutlet weak var d6Button: UIButton!
    @IBOutlet weak var d7Button: UIButton!
    @IBOutlet weak var d8Button: UIButton!
    @IBOutlet weak var d9Button: UIButton!
    @IBOutlet weak var d10Button: UIButton!
    @IBOutlet weak var translucentCard: UIImageView!
    @IBOutlet weak var officeLabel: UILabel!
    @IBOutlet weak var floorLabel: UILabel!
    @IBOutlet weak var deskLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var unreserveButton: UIButton!
    @IBOutlet weak var checkMark: UIImageView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
   
    var segueDestination = String()
    
    var secondOffices = [String]()
    var btnColors = ["GrayCircle", "GrayCircle", "GrayCircle", "GrayCircle", "GrayCircle", "GrayCircle", "GrayCircle", "GrayCircle", "GrayCircle", "GrayCircle"]
    var curButtonSelected = "d1"
    let grayCircle = UIImage(named: "GrayCircle")
    let blueCircle = UIImage(named: "BlueCircle")
    let dayNameAbbrieviations = ["xx","Su","Mo","Tu","We","Th","Fr","Sa"]
    var dayLabels = [UILabel]()
    
    var uid = "UID Undefined"
    var email = "Email Undefined"
    var name: String = "Name Undefined"
    var url : URL!
    var rememberedOffice = ""
    
    typealias officesReservedClosure = (Array<String>?) -> Void
    typealias floorsReservedClosure = (Array<Int>?) -> Void
    typealias desksReservedClosure = (Array<String>?) -> Void
    
    var officesReserved = [String]()
    var floorsReserved = [Int]()
    var desksReserved = [String]()
    
    var currentButtonSelected = Int()
    
    var date = String()
    var dates = [String]()
    
    var chosenButton = 0
    var chosenDate = String()
    var chosenOffice = String()
    var chosenFloor = Int()
    var chosenDesk = String()
    
    func getDayOfWeek(_ today:String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay
    }
    
    var rO1 : String = " " //We use whether or not this has been set to something other than a space to test to see if loading succeeded
    var rF1 : Int = 0
    var rD1 : String = ""
    var rO2 : String = " "
    var rF2 : Int = 0
    var rD2 : String = ""
    var rO3 : String = " "
    var rF3 : Int = 0
    var rD3 : String = ""
    var rO4 : String = " "
    var rF4 : Int = 0
    var rD4 : String = ""
    var rO5 : String = " "
    var rF5 : Int = 0
    var rD5 : String = ""
    var rO6 : String = " "
    var rF6 : Int = 0
    var rD6 : String = ""
    var rO7 : String = " "
    var rF7 : Int = 0
    var rD7 : String = ""
    var rO8 : String = " "
    var rF8 : Int = 0
    var rD8 : String = ""
    var rO9 : String = " "
    var rF9 : Int = 0
    var rD9 : String = ""
    var rO10 : String = " "
    var rF10 : Int = 0
    var rD10 : String = ""
    
    var date0 = String()
    var date1 = String()
    var date2 = String()
    var date3 = String()
    var date4 = String()
    var date5 = String()
    var date6 = String()
    var date7 = String()
    var date8 = String()
    var date9 = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        searchBar.setText(color: .black)
        searchBar.setSearchImage(color: .black)
        searchBar.setPlaceholderText(color: .black)
        searchBar.setTextField(color: .white)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        translucentCard.layer.cornerRadius = 9
        autoFaceID = false
        
        unreserveButton.layer.cornerRadius = unreserveButton.bounds.size.height / 2
    
        self.searchBar.delegate = self as UISearchBarDelegate
        
        var indexes = [String]()
        
        let weekOption1 = ["Tom.", "Tu", "We", "Th", "Fr", "Mo", "Tu", "We", "Th", "Fr"]
        let weekOption2 = ["Today", "Tu", "We", "Th", "Fr", "Mo", "Tu", "We", "Th", "Fr"]
        let weekOption3 = ["Today", "We", "Th", "Fr", "Mo", "Tu", "We", "Th", "Fr", "Mo"]
        let weekOption4 = ["Today", "Th", "Fr", "Mo", "Tu", "We", "Th", "Fr", "Mo", "Tu"]
        let weekOption5 = ["Today", "Fr", "Mo", "Tu", "We", "Th", "Fr", "Mo", "Tu", "We"]
        let weekOption6 = ["Today", "Mo", "Tu", "We", "Th", "Fr", "Mo", "Tu", "We", "Th"]
        let weekOption7 = ["Mo", "Tu", "We", "Th", "Fr", "Mo", "Tu", "We", "Th", "Fr"]
        
        let dateAdders1 = [1, 2, 3, 4, 5, 8, 9, 10, 11, 12]     //Su
        let dateAdders2 = [0, 1, 2, 3, 4, 7, 8, 9, 10, 11]     //Mo
        let dateAdders3 = [0, 1, 2, 3, 6, 7, 8, 9, 10, 13]
        let dateAdders4 = [0, 1, 2, 5, 6, 7, 8, 9, 12, 13]
        let dateAdders5 = [0, 1, 4, 5, 6, 7, 8, 11, 12, 13]
        let dateAdders6 = [0, 3, 4, 5, 6, 7, 10, 11, 12, 13]
        let dateAdders7 = [2, 3, 4, 5, 6, 9, 10, 11, 12, 13]    //Sa
        
        var dateAdders = [Int]()
        
        
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let myString = formatter.string(from: Date()) // string purpose I add here
            // convert your string to date
            let yourDate = formatter.date(from: myString)
            //then again set the date format whhich type of output you need
            formatter.dateFormat = "yyyy-MM-dd"
            let myStringafd = formatter.string(from: yourDate!)
            
            print(myStringafd)
            
            let dayOfWeek = getDayOfWeek(myStringafd)!
        
            switch dayOfWeek
            {
            case 1:
                dateAdders = dateAdders1
                indexes = weekOption1
            case 2:
                dateAdders = dateAdders2
                indexes = weekOption2
            case 3:
                dateAdders = dateAdders3
                indexes = weekOption3
            case 4:
                dateAdders = dateAdders4
                indexes = weekOption4
            case 5:
                dateAdders = dateAdders5
                indexes = weekOption5
            case 6:
                dateAdders = dateAdders6
                indexes = weekOption6
            case 7:
                dateAdders = dateAdders7
                indexes = weekOption7
            default:
                dateAdders = dateAdders1
                indexes = weekOption1
            }
        //Sets the day of the week on the buttons
        d1Button.setTitle(indexes[0], for: .normal)
        d2Button.setTitle(indexes[1], for: .normal)
        d3Button.setTitle(indexes[2], for: .normal)
        d4Button.setTitle(indexes[3], for: .normal)
        d5Button.setTitle(indexes[4], for: .normal)
        d6Button.setTitle(indexes[5], for: .normal)
        d7Button.setTitle(indexes[6], for: .normal)
        d8Button.setTitle(indexes[7], for: .normal)
        d9Button.setTitle(indexes[8], for: .normal)
        d10Button.setTitle(indexes[9], for: .normal)
        
        //Get the information about the user signed in
        let user = Auth.auth().currentUser
        if let user = user {
            uid = user.uid
            email = user.email!
            name = user.displayName!
            url = user.photoURL!        //phot

            if(url.absoluteString != "http://")
            {
                let s = url.absoluteString
                let r = s.index(s.startIndex, offsetBy: 7)..<s.index(s.endIndex, offsetBy: 0)
                let modifiedOfficeChosen = String(s[r])
                
                for char in modifiedOfficeChosen
                {
                    if (char == "_"){
                        rememberedOffice += String(" ")
                    }
                    else{
                        rememberedOffice += String(char)
                    }
                }
                segueDestination = "newReservation2"
            }
            else
            {
                segueDestination = "newReservation"
            }
            
            print("The users name is: \(String(describing: name))")
            print("The users ID is: \(uid)")
            print("The users email is: \(String(describing: email))")
            print("The users remembered office is: \(String(describing: rememberedOffice))")
        
        }
        floorLabel.text = "Hi, \(name)!"
        deskLabel.text = "Select a Day"
        
        //Set the reservation information for the user for the next 10 workdays
        let db = Firestore.firestore()
        
//        var officesReservedClosure:Array<String> = []
//        var floorsReservedClosure:Array<Int> = []
//        var desksReservedClosure:Array<String> = []

            let calendar = Calendar.current
            let today = Date()
            let midnight = calendar.startOfDay(for: today)
            date0 = calendar.date(byAdding: .day, value: dateAdders[0], to: midnight)!.string(format: "MMM d yyyy")
            date1 = calendar.date(byAdding: .day, value: dateAdders[1], to: midnight)!.string(format: "MMM d yyyy")
            date2 = calendar.date(byAdding: .day, value: dateAdders[2], to: midnight)!.string(format: "MMM d yyyy")
            date3 = calendar.date(byAdding: .day, value: dateAdders[3], to: midnight)!.string(format: "MMM d yyyy")
            date4 = calendar.date(byAdding: .day, value: dateAdders[4], to: midnight)!.string(format: "MMM d yyyy")
            date5 = calendar.date(byAdding: .day, value: dateAdders[5], to: midnight)!.string(format: "MMM d yyyy")
            date6 = calendar.date(byAdding: .day, value: dateAdders[6], to: midnight)!.string(format: "MMM d yyyy")
            date7 = calendar.date(byAdding: .day, value: dateAdders[7], to: midnight)!.string(format: "MMM d yyyy")
            date8 = calendar.date(byAdding: .day, value: dateAdders[8], to: midnight)!.string(format: "MMM d yyyy")
            date9 = calendar.date(byAdding: .day, value: dateAdders[9], to: midnight)!.string(format: "MMM d yyyy")

        dayOnetext = date0
        dayTwotext = date1
        
            var docRef = db.collection("Names").document(name).collection("Date").document(date0)
                docRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        print("Reservation found for this day")
                        self.rO1 = document.get("Office") as? String ?? ""
                        self.rF1 = document.get("Floor") as? Int ?? -9999
                        self.rD1 = document.get("Desk") as? String ?? ""
                        self.btnColors[0] = "BlueCircle"
                        self.restoreColors()
                        
                    } else {
                        print("No Reservation for this user on this day.")
                        self.rO1 = ""
                    }
                    if (self.finishedLoading())
                    {
                        self.activityIndicator.stopAnimating()
                    }
                }
        
        docRef = db.collection("Names").document(name).collection("Date").document(date1)
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    print("Reservation found for this day")
                    self.rO2 = document.get("Office") as? String ?? ""
                    self.rF2 = document.get("Floor") as? Int ?? -9999
                    self.rD2 = document.get("Desk") as? String ?? ""
                    self.btnColors[1] = "BlueCircle"
                    self.restoreColors()
                    
                } else {
                    print("No Reservation for this user on this day.")
                    self.rO2 = ""
                }
                if (self.finishedLoading())
                {
                    self.activityIndicator.stopAnimating()
                }
            }
        
        docRef = db.collection("Names").document(name).collection("Date").document(date2)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print("Reservation found for this day")
                self.rO3 = document.get("Office") as? String ?? ""
                self.rF3 = document.get("Floor") as? Int ?? -9999
                self.rD3 = document.get("Desk") as? String ?? ""
                self.btnColors[2] = "BlueCircle"
                self.restoreColors()
                
            } else {
                print("No Reservation for this user on this day.")
                self.rO3 = ""
            }
            if (self.finishedLoading())
            {
                self.activityIndicator.stopAnimating()
            }
        }
        
        docRef = db.collection("Names").document(name).collection("Date").document(date3)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print("Reservation found for this day")
                self.rO4 = document.get("Office") as? String ?? ""
                self.rF4 = document.get("Floor") as? Int ?? -9999
                self.rD4 = document.get("Desk") as? String ?? ""
                self.btnColors[3] = "BlueCircle"
                self.restoreColors()
                
            } else {
                print("No Reservation for this user on this day.")
                self.rO4 = ""
            }
            if (self.finishedLoading())
            {
                self.activityIndicator.stopAnimating()
            }
        }
        
        docRef = db.collection("Names").document(name).collection("Date").document(date4)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print("Reservation found for this day")
                self.rO5 = document.get("Office") as? String ?? ""
                self.rF5 = document.get("Floor") as? Int ?? -9999
                self.rD5 = document.get("Desk") as? String ?? ""
                self.btnColors[4] = "BlueCircle"
                self.restoreColors()
                
            } else {
                print("No Reservation for this user on this day.")
                self.rO5 = ""
            }
            if (self.finishedLoading())
            {
                self.activityIndicator.stopAnimating()
            }
        }
        
        docRef = db.collection("Names").document(name).collection("Date").document(date5)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print("Reservation found for this day")
                self.rO6 = document.get("Office") as? String ?? ""
                self.rF6 = document.get("Floor") as? Int ?? -9999
                self.rD6 = document.get("Desk") as? String ?? ""
                self.btnColors[5] = "BlueCircle"
                self.restoreColors()
                
            } else {
                print("No Reservation for this user on this day.")
                self.rO6 = ""
            }
            if (self.finishedLoading())
            {
                self.activityIndicator.stopAnimating()
            }
        }
        
        docRef = db.collection("Names").document(name).collection("Date").document(date6)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print("Reservation found for this day")
                self.rO7 = document.get("Office") as? String ?? ""
                self.rF7 = document.get("Floor") as? Int ?? -9999
                self.rD7 = document.get("Desk") as? String ?? ""
                self.btnColors[6] = "BlueCircle"
                self.restoreColors()
                
            } else {
                print("No Reservation for this user on this day.")
                self.rO7 = ""
            }
            if (self.finishedLoading())
            {
                self.activityIndicator.stopAnimating()
            }
        }
        
        docRef = db.collection("Names").document(name).collection("Date").document(date7)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print("Reservation found for this day")
                self.rO8 = document.get("Office") as? String ?? ""
                self.rF8 = document.get("Floor") as? Int ?? -9999
                self.rD8 = document.get("Desk") as? String ?? ""
                self.btnColors[7] = "BlueCircle"
                self.restoreColors()
                
            } else {
                print("No Reservation for this user on this day.")
                self.rO8 = ""
            }
            if (self.finishedLoading())
            {
                self.activityIndicator.stopAnimating()
            }
        }
        
        docRef = db.collection("Names").document(name).collection("Date").document(date8)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print("Reservation found for this day")
                self.rO9 = document.get("Office") as? String ?? ""
                self.rF9 = document.get("Floor") as? Int ?? -9999
                self.rD9 = document.get("Desk") as? String ?? ""
                self.btnColors[8] = "BlueCircle"
                self.restoreColors()
                
            } else {
                print("No Reservation for this user on this day.")
                self.rO9 = ""
            }
            if (self.finishedLoading())
            {
                self.activityIndicator.stopAnimating()
            }
        }
        
        docRef = db.collection("Names").document(name).collection("Date").document(date9)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print("Reservation found for this day")
                self.rO10 = document.get("Office") as? String ?? ""
                self.rF10 = document.get("Floor") as? Int ?? -9999
                self.rD10 = document.get("Desk") as? String ?? ""
                self.btnColors[9] = "BlueCircle"
                self.restoreColors()
                
            } else {
                print("No Reservation for this user on this day.")
                self.rO10 = ""
            }
            if (self.finishedLoading())
            {
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        searchBarText = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.performSegue(withIdentifier: "searchResults", sender: UISearchBar.self)
    }
    
    func restoreColors()
    {
        d1Button.setBackgroundImage(UIImage(named: btnColors[0]), for: .normal)
        d2Button.setBackgroundImage(UIImage(named: btnColors[1]), for: .normal)
        d3Button.setBackgroundImage(UIImage(named: btnColors[2]), for: .normal)
        d4Button.setBackgroundImage(UIImage(named: btnColors[3]), for: .normal)
        d5Button.setBackgroundImage(UIImage(named: btnColors[4]), for: .normal)
        d6Button.setBackgroundImage(UIImage(named: btnColors[5]), for: .normal)
        d7Button.setBackgroundImage(UIImage(named: btnColors[6]), for: .normal)
        d8Button.setBackgroundImage(UIImage(named: btnColors[7]), for: .normal)
        d9Button.setBackgroundImage(UIImage(named: btnColors[8]), for: .normal)
        d10Button.setBackgroundImage(UIImage(named: btnColors[9]), for: .normal)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
    }
    
    @IBAction func unreserveButtonTapped(_ sender: Any) {
        // Create the alert controller
        let alertController = UIAlertController(title: "Are you sure you want to remove this reservation?", message: "", preferredStyle: .alert)
        
        // Users confirms that they want to remove their reservation for this date
        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default)
        {
                UIAlertAction in
                print("This Reservation will be cancelled")
                self.activityIndicator.startAnimating()
                let db = Firestore.firestore()
                let locationToPlaceNewReservation = db.collection("Date/\(self.chosenDate)/Office/\(self.chosenOffice)/Floor/\(self.chosenFloor)/Desk")
                let locationForNewReservationRecord = db.collection("Names/\(self.name)/Date/")
                locationToPlaceNewReservation.document(self.chosenDesk).delete{ err in
                    if let err = err {
                        print("Error removing document from database 1: \(err)")
                    } else {
                        print("Reservation successfully removed from database 1!")
                        
                        locationForNewReservationRecord.document(self.chosenDate).delete{ err in
                            if let err = err {
                                print("Error removing document from databse 2: \(err)")
                            } else {
                                print("Reservation record successfully removed from database 2!")
                                self.btnColors[self.currentButtonSelected - 1] = "GrayCircle"
                                self.restoreColors()
                                self.activityIndicator.stopAnimating()
                                self.officeLabel.text = ""
                                self.floorLabel.text = "Desk Unreserved"
                                self.deskLabel.text = "Select Another Day"
                                self.unreserveButton.isHidden = true
                                self.checkMark.loadGif(name: "CheckMark")
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { // Change `2.0` to the desired number of seconds.
                                    self.checkMark.loadGif(name: "Transparent")
                                }
                            }
                        }
                    }
                }
            }
            let cancelAction = UIAlertAction(title: "Nevermind", style: UIAlertAction.Style.cancel) {
                UIAlertAction in
                print("This Reservation will NOT be cancelled")
            }
        
            // Add the actions
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
        
            // Present the controller
            self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func d1ButtonTapped(_ sender: Any) {
        restoreColors()
        if(d1Button.currentBackgroundImage == blueCircle){
            unreserveButton.isHidden = false
            d1Button.setBackgroundImage(UIImage(named: "GreenCircle"), for: .normal)
            officeLabel.text = rO1
            floorLabel.text = "Floor \(rF1)"
            deskLabel.text = "Desk \(rD1)"
            self.chosenDate = date0
            self.chosenOffice = rO1
            self.chosenFloor = rF1
            self.chosenDesk = rD1
            self.currentButtonSelected = 1
        }
        else{
            chosenButton = 0
            self.performSegue(withIdentifier: segueDestination, sender: self)
        }
    }
    
    @IBAction func d2ButtonTapped(_ sender: Any) {
        restoreColors()
        if(d2Button.currentBackgroundImage == blueCircle){
            unreserveButton.isHidden = false
            d2Button.setBackgroundImage(UIImage(named: "GreenCircle"), for: .normal)
            officeLabel.text = rO2
            floorLabel.text = "Floor \(rF2)"
            deskLabel.text = "Desk \(rD2)"
            self.chosenDate = date1
            self.chosenOffice = rO2
            self.chosenFloor = rF2
            self.chosenDesk = rD2
            self.currentButtonSelected = 2
        }
        else{
            chosenButton = 1
            self.performSegue(withIdentifier: segueDestination, sender: self)
        }
    }
    @IBAction func d3ButtonTapped(_ sender: Any) {
        restoreColors()
        if(d3Button.currentBackgroundImage == blueCircle){
            unreserveButton.isHidden = false
            d3Button.setBackgroundImage(UIImage(named: "GreenCircle"), for: .normal)
            officeLabel.text = rO3
            floorLabel.text = "Floor \(rF3)"
            deskLabel.text = "Desk \(rD3)"
            self.chosenDate = date2
            self.chosenOffice = rO3
            self.chosenFloor = rF3
            self.chosenDesk = rD3
            self.currentButtonSelected = 3
        }
        else{
            chosenButton = 2
            self.performSegue(withIdentifier: segueDestination, sender: self)
        }
    }
    @IBAction func d4ButtonTapped(_ sender: Any) {
        restoreColors()
        if(d4Button.currentBackgroundImage == blueCircle){
            unreserveButton.isHidden = false
            d4Button.setBackgroundImage(UIImage(named: "GreenCircle"), for: .normal)
            officeLabel.text = rO4
            floorLabel.text = "Floor \(rF4)"
            deskLabel.text = "Desk \(rD4)"
            self.chosenDate = date3
            self.chosenOffice = rO4
            self.chosenFloor = rF4
            self.chosenDesk = rD4
            self.currentButtonSelected = 4
        }
        else{
            chosenButton = 3
            self.performSegue(withIdentifier: segueDestination, sender: self)
        }
    }
    @IBAction func d5ButtonTapped(_ sender: Any) {
        restoreColors()
        if(d5Button.currentBackgroundImage == blueCircle){
            unreserveButton.isHidden = false
            d5Button.setBackgroundImage(UIImage(named: "GreenCircle"), for: .normal)
            officeLabel.text = rO5
            floorLabel.text = "Floor \(rF5)"
            deskLabel.text = "Desk \(rD5)"
            self.chosenDate = date4
            self.chosenOffice = rO5
            self.chosenFloor = rF5
            self.chosenDesk = rD5
            self.currentButtonSelected = 5
        }
        else{
            chosenButton = 4
            self.performSegue(withIdentifier: segueDestination, sender: self)
        }
    }
    @IBAction func d6ButtonTapped(_ sender: Any) {
        restoreColors()
        if(d6Button.currentBackgroundImage == blueCircle){
            unreserveButton.isHidden = false
            d6Button.setBackgroundImage(UIImage(named: "GreenCircle"), for: .normal)
            officeLabel.text = rO6
            floorLabel.text = "Floor \(rF6)"
            deskLabel.text = "Desk \(rD6)"
            self.chosenDate = date5
            self.chosenOffice = rO6
            self.chosenFloor = rF6
            self.chosenDesk = rD6
            self.currentButtonSelected = 6
        }
        else{
            
            chosenButton = 5
            self.performSegue(withIdentifier: segueDestination, sender: self)
        }
    }
    @IBAction func d7ButtonTapped(_ sender: Any) {
        restoreColors()
        if(d7Button.currentBackgroundImage == blueCircle){
            unreserveButton.isHidden = false
            d7Button.setBackgroundImage(UIImage(named: "GreenCircle"), for: .normal)
            officeLabel.text = rO7
            floorLabel.text = "Floor \(rF7)"
            deskLabel.text = "Desk \(rD7)"
            self.chosenDate = date6
            self.chosenOffice = rO7
            self.chosenFloor = rF7
            self.chosenDesk = rD7
            self.currentButtonSelected = 7
        }
        else{
            chosenButton = 6
            self.performSegue(withIdentifier: segueDestination, sender: self)
        }
    }
    @IBAction func d8ButtonTapped(_ sender: Any) {
        restoreColors()
        if(d8Button.currentBackgroundImage == blueCircle){
            unreserveButton.isHidden = false
            d8Button.setBackgroundImage(UIImage(named: "GreenCircle"), for: .normal)
            officeLabel.text = rO8
            floorLabel.text = "Floor \(rF8)"
            deskLabel.text = "Desk \(rD8)"
            self.chosenDate = date7
            self.chosenOffice = rO8
            self.chosenFloor = rF8
            self.chosenDesk = rD8
            self.currentButtonSelected = 8
        }
        else{
            chosenButton = 7
            self.performSegue(withIdentifier: segueDestination, sender: self)
        }
    }
    @IBAction func d9ButtonTapped(_ sender: Any) {
        restoreColors()
        if(d9Button.currentBackgroundImage == blueCircle){
            unreserveButton.isHidden = false
            d9Button.setBackgroundImage(UIImage(named: "GreenCircle"), for: .normal)
            officeLabel.text = rO9
            floorLabel.text = "Floor \(rF9)"
            deskLabel.text = "Desk \(rD9)"
            self.chosenDate = date8
            self.chosenOffice = rO9
            self.chosenFloor = rF9
            self.chosenDesk = rD9
            self.currentButtonSelected = 9
        }
        else{
            chosenButton = 8
            self.performSegue(withIdentifier: segueDestination, sender: self)
        }
    }
    @IBAction func d10ButtonTapped(_ sender: Any) {
        restoreColors()
        if(d10Button.currentBackgroundImage == blueCircle){
            unreserveButton.isHidden = false
            d10Button.setBackgroundImage(UIImage(named: "GreenCircle"), for: .normal)
            officeLabel.text = rO10
            floorLabel.text = "Floor \(rF10)"
            deskLabel.text = "Desk \(rD10)"
            self.chosenDate = date9
            self.chosenOffice = rO10
            self.chosenFloor = rF10
            self.chosenDesk = rD10
            self.currentButtonSelected = 10
        }
        else{
            chosenButton = 9
            self.performSegue(withIdentifier: segueDestination, sender: self)
        }
    }
    
    func searchBarSearchButtonClicked( searchBar: UISearchBar!) {
        
        self.performSegue(withIdentifier: "showSearch", sender: Any?.self)
    }
    
    func finishedLoading() ->Bool
    {
        if(rO1 != " " && rO2 != " " && rO3 != " " && rO4 != " " && rO5 != " " && rO6 != " " && rO7 != " " && rO8 != " " && rO9 != " " && rO10 != " ")
        {
            return true
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.destination is ThirdViewController)
        {
            let vc = segue.destination as? ThirdViewController

            for office in secondOffices
            {
                vc?.pickerData.append(office)
            }
            vc?.name = self.name
            //Pass the data along to the next view controller
            switch chosenButton
            {
            case 0:
                vc!.date = date0
            case 1:
                vc!.date = date1
            case 2:
                vc!.date = date2
            case 3:
                vc!.date = date3
            case 4:
                vc!.date = date4
            case 5:
                vc!.date = date5
            case 6:
                vc!.date = date6
            case 7:
                vc!.date = date7
            case 8:
                vc!.date = date8
            case 9:
                vc!.date = date9
            default:
                vc!.date = date0
            }
        }
        if(segue.destination is FourthViewController)
        {
            let vc = segue.destination as? FourthViewController
            
            vc?.name = self.name
            //Pass the data along to the next view controller
            vc?.office = rememberedOffice
            
            for office in secondOffices
            {
                vc?.officePickerData.append(office)
            }
            
            switch chosenButton
            {
            case 0:
                vc!.date = date0
            case 1:
                vc!.date = date1
            case 2:
                vc!.date = date2
            case 3:
                vc!.date = date3
            case 4:
                vc!.date = date4
            case 5:
                vc!.date = date5
            case 6:
                vc!.date = date6
            case 7:
                vc!.date = date7
            case 8:
                vc!.date = date8
            case 9:
                vc!.date = date9
            default:
                vc!.date = date0
            }
        }
    }

}

extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

extension UISearchBar {
    
    func getTextField() -> UITextField? { return value(forKey: "searchField") as? UITextField }
    func setText(color: UIColor) { if let textField = getTextField() { textField.textColor = color } }
    func setPlaceholderText(color: UIColor) { getTextField()?.setPlaceholderText(color: color) }
    func setClearButton(color: UIColor) { getTextField()?.setClearButton(color: color) }
    
    func setTextField(color: UIColor) {
        guard let textField = getTextField() else { return }
        switch searchBarStyle {
        case .minimal:
            textField.layer.backgroundColor = color.cgColor
            textField.layer.cornerRadius = 6
        case .prominent, .default: textField.backgroundColor = color
        @unknown default: break
        }
    }
    
    func setSearchImage(color: UIColor) {
        guard let imageView = getTextField()?.leftView as? UIImageView else { return }
        imageView.tintColor = color
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
    }
}

extension UITextField {
    
    private class ClearButtonImage {
        static private var _image: UIImage?
        static private var semaphore = DispatchSemaphore(value: 1)
        static func getImage(closure: @escaping (UIImage?)->()) {
            DispatchQueue.global(qos: .userInteractive).async {
                semaphore.wait()
                DispatchQueue.main.async {
                    if let image = _image { closure(image); semaphore.signal(); return }
                    guard let window = UIApplication.shared.windows.first else { semaphore.signal(); return }
                    let searchBar = UISearchBar(frame: CGRect(x: 0, y: -200, width: UIScreen.main.bounds.width, height: 44))
                    window.rootViewController?.view.addSubview(searchBar)
                    searchBar.text = "txt"
                    searchBar.layoutIfNeeded()
                    _image = searchBar.getTextField()?.getClearButton()?.image(for: .normal)
                    closure(_image)
                    searchBar.removeFromSuperview()
                    semaphore.signal()
                }
            }
        }
    }
    
    func setClearButton(color: UIColor) {
        ClearButtonImage.getImage { [weak self] image in
            guard   let image = image,
                let button = self?.getClearButton() else { return }
            button.imageView?.tintColor = color
            button.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    
    func setPlaceholderText(color: UIColor) {
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ? placeholder! : "", attributes: [.foregroundColor: color])
    }
    
    func getClearButton() -> UIButton? { return value(forKey: "clearButton") as? UIButton }
}
