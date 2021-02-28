//
//  MedicineCell.swift
//  AssignmentTest
//
//  Created by Angelos Staboulis on 13/2/21.
//

import UIKit
class MedicineCell: UITableViewCell {
    @IBOutlet var medicine: UILabel!
    @IBOutlet var quanity: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
