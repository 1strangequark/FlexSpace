//
//  ItemCell.swift
//  GridViewExampleApp
//
//  Created by Chandimal, Sameera on 12/22/17.
//  Copyright © 2017 Pearson. All rights reserved.
//

import UIKit

var deskForRes = ""
let graySquare = UIImage(named: "GraySquare")
let blueSquare = UIImage(named: "BlueSquare")
let greenSquare = UIImage(named: "GreenSquare")

var currentButtonSelected = ""
var previousButtonSelected = ItemCell()

class ItemCell: UICollectionViewCell {
    var background = ""

    @IBOutlet weak var deskButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override var isSelected: Bool {
        didSet {
            self.setBackground(imageName: "GreenSquare")
            self.reloadInputViews()
        }
    }

    func setData(text: String) {
        self.deskButton.setTitle(text, for: .normal)
    }
    
    func setBackground(imageName: String) {
        if (imageName != "")
        {
            self.deskButton.setBackgroundImage(UIImage(named: imageName), for: .normal)
        }
        if (imageName != "GreenSquare")
        {
            self.background = imageName
        }
    }
    
    var number = 0
    var previousNumber = 0

    @IBAction func deskButtonTapped(_ sender: Any) {
        deskForRes = self.deskButton.titleLabel!.text!
        
        previousButtonSelected.setBackground(imageName: previousButtonSelected.background)
        previousButtonSelected = self
        
        if(self.background == "BlueSquare")
        {
            self.deskButton.setBackgroundImage(UIImage(named: "GreenSquare"), for: .normal)
            self.reloadInputViews()
        }
        else if (self.deskButton.currentBackgroundImage == graySquare)
        {
            
        }
    }
    
}

