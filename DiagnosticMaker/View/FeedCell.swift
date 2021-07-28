//
//  FeedCell.swift
//  DiagnosticMaker
//
//  Created by 大江祥太郎 on 2021/07/28.
//

import UIKit

class FeedCell: UITableViewCell {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //丸くする
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = 10.0
        
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 2, height: 4)
        self.layer.shadowRadius = 10.0
        self.layer.shadowOpacity = 0.5
        // Initialization code
        
        let randomDouble1 = CGFloat.random(in: 0.0...1.0)
        let randomDouble2 = CGFloat.random(in: 0.0...1.0)
        let randomDouble3 = CGFloat.random(in: 0.0...1.0)
        self.topView.backgroundColor = UIColor(red: randomDouble1, green: randomDouble2, blue: randomDouble3, alpha: 1.0)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
