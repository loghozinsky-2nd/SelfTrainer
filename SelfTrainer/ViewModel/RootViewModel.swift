//
//  RootViewModel.swift
//  SelfTrainer
//
//  Created by Sasha on 4/12/19.
//  Copyright © 2019 alogozinsky.com. All rights reserved.
//

import Foundation

class RootViewModel {
	
	func getExercises(completion: @escaping ([Excercise]) -> Void) {
		let data = [Excercise(uuid: UUID(), name: "Bars Pull Up", description: "Make Push Up with self weight"),
					Excercise(uuid: UUID(), name: "Pull Up", description: "Make Push Up with self weight"),
					Excercise(uuid: UUID(), name: "Cardio", description: "Walking 25 minutes with heartrate ~125")]
		
		completion(data)
	}
	
}
