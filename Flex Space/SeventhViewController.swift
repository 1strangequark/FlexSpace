//
//  SeventhViewController.swift
//  New Flex Space v5
//
//  Created by Admin on 7/15/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import Firebase

class SeventhViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var list = [String]()
    var personSelection = Int()
    var resultMatches = String()
    let db = Firestore.firestore()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Function to get all of the available Offices in the database
        db.collection("Names").getDocuments()
            {
                (querySnapshot, err) in
                if let err = err
                {
                    print("Error getting offices to populate office picker: \(err)");
                }
                else
                {
                    let formattedSearchBarText = self.removeSpecialCharsFromString(text: searchBarText.lowercased())
                    for document in querySnapshot!.documents
                    {
                        let formattedDocumentID = self.removeSpecialCharsFromString(text: document.documentID.lowercased())  //Make the search results independant of capitalization
                        if (formattedDocumentID.contains(formattedSearchBarText) || formattedSearchBarText.contains(formattedDocumentID))
                        {
                            self.list.append(document.documentID);
                        }
                    }
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                }
        }
        
    }
    
    func removeSpecialCharsFromString(text: String) -> String {
        let okayChars : Set<Character> =
            Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ".characters)
        return String(text.characters.filter {okayChars.contains($0) })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "tableCell")
        tableCell.textLabel?.text = list[indexPath.row]
        tableCell.textLabel?.textColor = UIColor.white
        tableCell.backgroundColor = UIColor.clear
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        personSelected = list[indexPath.row]
        self.performSegue(withIdentifier: "showUser", sender: UITableViewCell.self)
        
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
