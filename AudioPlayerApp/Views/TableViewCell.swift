////   /*
//
//  Project: AudioPlayerApp
//  File: TableViewCell.swift
//  Created by: Robert Bikmurzin
//  Date: 15.09.2023
//
//  Status: in progress | Decorated
//
//  */

import UIKit

class TableViewCell: UITableViewCell {

    let title = UILabel()
    let subtitle = UILabel()
    let duration = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell() {
        addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            title.topAnchor.constraint(equalTo: topAnchor, constant: 5)
        ])
        title.font = .boldSystemFont(ofSize: 17)
        
        addSubview(subtitle)
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subtitle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            subtitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15)
        ])
        subtitle.font = .systemFont(ofSize: 12)
        
        addSubview(duration)
        duration.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            duration.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            duration.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

}
