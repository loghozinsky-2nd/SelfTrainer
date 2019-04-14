//
//  ViewController.swift
//  SelfTrainer
//
//  Created by Sasha on 4/11/19.
//  Copyright © 2019 alogozinsky.com. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	let vm = RootViewModel()
	
	let cellId = "cellId"
	let tableView: UITableView = {
		let tableView = UITableView()
		tableView.separatorStyle = .none
		tableView.layer.cornerRadius = 10
		tableView.allowsSelection = false
		tableView.isScrollEnabled = false
		return tableView
	}()
	
	var data: [Excercise] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// TableView protocols
		self.tableView.delegate = self
		self.tableView.dataSource = self
		
		// Do any additional setup after loading the view.
		self.view.addSubview(self.tableView)
		setupLayout()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.tableView.register(ExcerciseTableViewCell.self, forCellReuseIdentifier: cellId)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		vm.getExercises() {
			(response) in
			var index = 0
			
			for item in response {
				self.data.append(item)
				
				let indexPath = IndexPath(item: index, section: 0)
				self.tableView.insertRows(at: [indexPath], with: .automatic)
				index += 1
			}
		}
	}
	
	private func setupLayout() {
		self.view.backgroundColor = .darkGray
		
		self.tableView.backgroundColor = .gray
		self.tableView.fillSuperview(padding: UIEdgeInsets(top: 50, left: 10, bottom: 50, right: 10))
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.data.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! ExcerciseTableViewCell
		cell.configureWithData(name: data[indexPath.item].name, description: data[indexPath.item].description)
		
		return cell
	}
	
}
