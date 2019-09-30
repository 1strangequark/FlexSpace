//
//  FourthViewController.swift
//  New Flex Space v5
//
//  Created by Admin on 6/21/19.
//  Copyright © 2019 Admin. All rights reserved.
////

import UIKit
import Firebase

class FourthViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var reserveButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var officeButton: UIButton!
    @IBOutlet weak var checkMark: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var floorPicker: UIPickerView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var translucentCard: UIImageView!
    
    var dataArray = [String]()
    var alreadyReservedDesks = [String]()
    
    var estimateWidth = 93.0
    var cellMarginSize = 0.0
    var gridLineSpacing : CGFloat = 16.0
    
    var deskPickerData: [String] = [String]()
    var floorPickerData: [String] = ["1"]
    var offices = [String]()
    
    var loaded = 0
    
    //data to be used for creation of a new reservation in the database
    var office = ""     //Office is set by previous view controller
    var floor_ : Int = 1
    var date = ""       //date is set by previous view controller
    var name = String()     //name is set by previous view controller
    
    var officePickerData = [String]()
    
    //db is our cloud firestore database!
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.translucentCard.layer.cornerRadius = 9
        
        // Set Delegates
        self.collectionView.delegate = self as UICollectionViewDelegate
        self.collectionView.dataSource = self as UICollectionViewDataSource
        // SetupGrid view
        self.setupGridView()
        
        dateLabel.text = "For \(date)"
        officeButton.setTitle(office, for: .normal)
        reserveButton.layer.cornerRadius = reserveButton.bounds.size.height / 2
        
        // Set up the floor picker data
        self.floorPicker.delegate = self
        self.floorPicker.dataSource = self
        
        //Set the data for the floor picker
        db.collection("Offices").document(office).collection("Floors").getDocuments()
            {
                (querySnapshot, err) in
                if let err = err
                {
                    print("Error getting floors to populate floor picker: \(err)");
                }
                else
                {
                    self.floorPickerData.removeAll()
                    for document in querySnapshot!.documents {
                        self.floorPickerData.append(document.documentID);
                    }
                    self.floorPicker.reloadAllComponents()
                }
        }
        
        //get the data for floor one
        setDataForThisFloor(floor: floor_)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setupGridView()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func setDataForThisFloor(floor : Int)
    {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        print("floor data being loaded for floor \(floor)")
        floor_  = floor
        
        //Get all of the desks in the database
        db.collection("Offices").document(office).collection("Floors").document(String(floor_)).collection("Desks").getDocuments()
            {
                (querySnapshot, err) in
                if let err = err
                {
                    print("Error getting offices to populate desk picker: \(err)");
                }
                else
                {
                    self.dataArray.removeAll()
                    for document in querySnapshot!.documents {
                        self.dataArray.append(document.documentID);
                    }
                    // Register cells
                    self.collectionView.register(UINib(nibName: "ItemCell", bundle: nil), forCellWithReuseIdentifier: "ItemCell")
                    
                    self.alreadyReservedDesks.removeAll()
                    
                    //Grab the aleady reserved desks so we can set the desk colors
                    let locationOfAlreadyTakenDesks = self.db.collection("Date").document(self.date).collection("Office").document(self.office).collection("Floor").document(String(self.floor_)).collection("Desk")
                    locationOfAlreadyTakenDesks.getDocuments()
                    {
                            (querySnapshot, err) in
                            if let err = err
                            {
                                print("Error getting reserved desks to populate desk colors: \(err)");
                            }
                            else
                            {
                                for document in querySnapshot!.documents {
                                    self.alreadyReservedDesks.append(document.documentID)
                                }
                                self.collectionView.reloadData()
                                self.activityIndicator.stopAnimating()
                                self.activityIndicator.isHidden = true
                            }
                    }
                }
            }
    }
    
    func setupGridView() {
        let flow = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        flow.minimumInteritemSpacing = CGFloat(self.cellMarginSize)
        flow.minimumLineSpacing = gridLineSpacing
    }
   
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return floorPickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let font = UIFont.systemFont(ofSize: 50, weight: UIFont.Weight.black)
//        let shadow = NSShadow()
//        shadow.shadowColor = UIColor.blue
//        shadow.shadowBlurRadius = 5
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.white,
//            .shadow: shadow
        ]
        
        return NSAttributedString(string: floorPickerData[row], attributes: attributes)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        setDataForThisFloor(floor: Int(floorPickerData[row])!)
        collectionView.reloadData()
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath
        indexPath: NSIndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath as IndexPath) as! ItemCell
        cell.deskButton.setBackgroundImage(UIImage(named: "GreenSquare"), for: .normal)
        
        cell.contentView.backgroundColor = UIColor(red: 102/256, green: 255/256, blue: 255/256, alpha: 0.66)
        collectionView.reloadItems(at: [indexPath as IndexPath])
    }
    
//    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        
//        
//    }

    
    @IBAction func officeButtonClicked(_ sender: Any) {
        let url = URL(string: "http://")
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.photoURL = url
        changeRequest?.commitChanges { (error) in
            print("Error removing the remembered Office")
        }
        self.performSegue(withIdentifier: "reChooseOffice", sender: Any?.self)
    }

    var previousNumber: Int = 0
    var previousNumber2: Int = 0
    @IBAction func reserveButtonClicked(_ sender: Any)
    {
            //Now we begin the process of actually storing the reservation in the server
            let newReservationDesk = db.collection("Offices/\(office)/Floors/\(floor_)/Desks").document(deskForRes)
            let locationToPlaceNewReservation = db.collection("Date/\(date)/Office/\(office)/Floor/\(floor_)/Desk")
            let locationForNewDeskDocument = db.collection("Date/\(date)/Office/\(office)/Floor/\(floor_)/Desk")
            //First we test to see if the users information (office, floor, deskForRes etc) actually exists in our database
            newReservationDesk.getDocument { (document, error) in
                if let document = document
                {
                    if document.exists  //The deskForRes exists in our database, great
                    {
                        //Now check to see if the deskForRes is taken
                        locationToPlaceNewReservation.getDocuments()
                            {
                                (querySnapshot, err) in
                                
                                if let err = err
                                {
                                    print("Error getting documents: \(err)");
                                }
                                else
                                {
                                    //See if the reservation is available
                                    var isAvailable = true
                                    for document in querySnapshot!.documents {
                                        if (deskForRes == document.documentID)
                                        {
                                            isAvailable = false
                                        }
                                    }
                                    
                                    if(!isAvailable)
                                    {
                                        //Deliver at UI alert telling the desk is not avalable
                                        let phrases = ["Shucks", "Drat", "Gosh", "Fiddlesticks", "Rats", "Pshaw", "Gee Whiz", "Jeepers"]
                                        var number = Int.random(in: 0 ..< phrases.count)
                                        while number == self.previousNumber
                                        {
                                            number = Int.random(in: 0 ..< phrases.count)
                                        }
                                        let phrase = phrases[number]
                                        self.previousNumber = number
                                        let alertController = UIAlertController(title: "Sorry, this desk is not available", message:
                                            "Please choose another desk", preferredStyle: .alert)
                                        alertController.addAction(UIAlertAction(title: phrase, style: .default))
                                        
                                        self.present(alertController, animated: true, completion: nil)
                                    }
                                    else    //Create a new reservation
                                    {
                                        //this first block of code sets the reservation beginning in the Date> pathway
                                        locationForNewDeskDocument.document(deskForRes).setData([
                                            "Desk Created At": Date()
                                        ]) { err in
                                            if let err = err {
                                                print("Error writing document: \(err)")
                                            }
                                            else
                                            {
                                                print("Document successfully written!")
                                            }
                                        }
                                        locationToPlaceNewReservation.document(self.name).setData([
                                            "Reservation created at": Date(),
                                            "Reserved by" : self.name
                                        ]) { err in
                                            if let err = err {
                                                print("Error writing document: \(err)")
                                            }
                                            else {
                                                print("Document successfully written!")
                                                
                                                //This second block of code creates a record of the reservation in the Names> section of the database
                                                self.db.collection("Names").document(self.name).collection("Date").document(self.date).setData([
                                                    "Desk": deskForRes,
                                                    "Floor": self.floor_,
                                                    "Office": self.office
                                                ]) { err in
                                                    if let err = err {
                                                        print("Error writing document: \(err)")
                                                    } else {
                                                        print("Reservation record successfully stored")
                                                        self.checkMark.loadGif(name: "CheckMark")
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { // Change `2.0` to the desired number of seconds.
                                                            self.checkMark.loadGif(name: "Transparent")
                                                            self.performSegue(withIdentifier: "returnHome", sender: Any?.self)
                                                        }
                                                        
                                                    }
                                                }
                                            }
                                        }
                                        
                                    }
                                    
                                }
                        }
                    }
                    else    //The desk does not exist in our database
                    {
                        print("This desk does not exist in the database")
                    }
                }
            }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is ThirdViewController
        {
            let vc = segue.destination as? ThirdViewController
            for office in officePickerData
            {
                vc?.pickerData.append(office)
            }
            vc?.name = self.name
            vc?.date = self.date
            
        }
        if segue.destination is FifthViewController
        {
            let vc = segue.destination as? FifthViewController
            for office in officePickerData
            {
                vc?.secondOffices.append(office)
            }
            vc?.name = self.name
            vc?.date = self.date
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

extension FourthViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        cell.setData(text: self.dataArray[indexPath.row])
        
        if (alreadyReservedDesks.contains(self.dataArray[indexPath.row]))
        {
            cell.setBackground(imageName: "GraySquare")
        }
        else
        {
            cell.setBackground(imageName: "BlueSquare")
        }
        return cell
    }
}

extension FourthViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.calculateWith()
        return CGSize(width: width, height: width)
    }
    
    func calculateWith() -> CGFloat {
        let estimatedWidth = CGFloat(estimateWidth)
        let cellCount = floor(CGFloat(self.view.frame.size.width / estimatedWidth))
        
        let margin = CGFloat(cellMarginSize * 2)
        let width = (self.view.frame.size.width - CGFloat(cellMarginSize) * (cellCount - 1) - margin) / cellCount
        
        return width
    }
}



