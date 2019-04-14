//
//  Global.swift
//  SelfTrainer
//
//  Created by Sasha on 4/12/19.
//  Copyright © 2019 alogozinsky.com. All rights reserved.
//

import UIKit

enum State {
	case fullScreen
	case opened
	case closed
	case disable
}

struct NextState {
	let current: State
	let next: State
	
	init(current: State, next: State) {
		self.current = current
		self.next = next
	}
}
