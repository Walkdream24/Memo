//
//  TaskTableViewCell.swift
//  Memo
//
//  Created by 中重歩夢 on 2018/08/25.
//  Copyright © 2018年 Ayumu Nakashige. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    
    static let reuseIdentifier = "TaskCell"
    
    

    @IBOutlet var taskLabel: UIView!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
