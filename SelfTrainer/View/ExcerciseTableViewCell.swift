//
//  ExcerciseTableViewCell.swift
//  SelfTrainer
//
//  Created by Sasha on 4/11/19.
//  Copyright © 2019 alogozinsky.com. All rights reserved.
//

import UIKit

class ExcerciseTableViewCell: UITableViewCell {
	
	let nameLabel: UILabel = {
		let label = UILabel()
		label.textColor = .white
		return label
	}()
	
	let descriptionLabel: UILabel = {
		let label = UILabel()
		label.textColor = .lightGray
		return label
	}()
	
	func configureWithData(name: String? = nil, description: String? = nil) {
		// Configure the view
		contentView.addSubview(nameLabel)
		nameLabel.text = name
		
//		contentView.addSubview(descriptionLabel)
//		descriptionLabel.text = description
		
		// Do additional setup
		setupLayout()
	}
	
	private func setupLayout() {
		self.backgroundColor = .clear
		
		self.nameLabel.anchor(top: self.contentView.topAnchor, leading: self.contentView.leadingAnchor, bottom: self.contentView.bottomAnchor, trailing: self.contentView.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
	}
	
}
