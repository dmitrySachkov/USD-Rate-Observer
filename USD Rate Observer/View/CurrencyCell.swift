//
//  CurrencyCell.swift
//  USD Rate Observer
//
//  Created by Dmitry Sachkov on 14.06.2021.
//

import UIKit

class CurrencyCell: UITableViewCell {

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var rateLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func setupCell(date: Date, rate: String) {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yyyy"
        let dateCur = df.string(from: date)
        dateLbl.text = dateCur
        rateLbl.text = rate
    }
}
