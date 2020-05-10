//
//  View.swift
//  MVC_TaskManager
//
//  Created by 植田圭祐 on 2020/05/10.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import Foundation
import UIKit

class TaskListCell: UITableViewCell {
    
    private var taskLabel: UILabel!
    private var deadlineLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        taskLabel = UILabel()
        taskLabel.textColor = .black
        taskLabel.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(taskLabel)
        
        deadlineLabel = UILabel()
        deadlineLabel.textColor = .black
        deadlineLabel.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(deadlineLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(corder:) has not been implememted")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        taskLabel.frame = CGRect(x: 15.0, y: 15.0, width: contentView.frame.width - (15.0 * 2), height: 15)
        deadlineLabel.frame = CGRect(x: taskLabel.frame.origin.x, y: taskLabel.frame.origin.y, width: taskLabel.frame.width, height: 15)
    }
    
    var task: Task? {
        didSet {
            guard let t = task else { return }
            taskLabel.text = t.text
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/mm/dd"
            
            deadlineLabel.text = formatter.string(from: t.deadline)
        }
    }
}
