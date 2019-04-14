//
//  BottomSheetViewController.swift
//  SelfTrainer
//
//  Created by Sasha on 4/11/19.
//  Copyright © 2019 alogozinsky.com. All rights reserved.
//

import UIKit

class BottomSheetViewController: UIViewController {
	
	var state = NextState(current: .disable, next: .closed)
	var runningAnimations: [UIViewPropertyAnimator] = []
	var positionY = UIScreen.main.bounds.height
	var animationProgressWhenInterrupted: CGFloat = 1
	var visualEffectView: UIVisualEffectView!
	lazy var frame = self.view.frame
	
	let contentView: UIView = {
		let view = UIView()
		view.clipsToBounds = true
		view.layer.cornerRadius = 10
		view.backgroundColor = .white
		return view
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.addSubview(self.contentView)
		
		setupLayout()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		presentElementsAnimation(.closed, duration: 0.3) {
			(response) in
			self.toggleState(response)
			self.setupCard()
		}
	}
	
	func presentElementsAnimation(_ state: State, duration: TimeInterval, offset: CGFloat? = nil, completion: @escaping (State) -> Void) {
		print("offset = \(String(describing: offset))")
		let nextState = self.getNextState(state)
		let toggleBackground = UIViewPropertyAnimator(duration: duration, curve: .easeInOut) {
			let dynamicOffset = self.getOffset(state, offset: offset)
			self.view.frame = CGRect(x: 0, y: self.positionY - dynamicOffset, width: self.frame.width, height: self.frame.height)
			print("currentState in presentElementsAnimation: \(state), nextState is \(nextState)")
			
			self.contentView.layoutIfNeeded()
			switch state {
			case .closed:
				self.view.backgroundColor = .black
				self.contentView.fillSuperview(padding: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
			case .opened:
				self.view.backgroundColor = .red
				self.contentView.fillSuperview(padding: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
			case .fullScreen:
				self.view.backgroundColor = .blue
				self.contentView.fillSuperview(padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
			default:
				self.view.backgroundColor = .clear
				self.contentView.fillSuperview(padding: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
			}
		}
		
		toggleBackground.startAnimation()
		runningAnimations.append(toggleBackground)
		
		switch nextState {
		case .fullScreen: completion(.fullScreen)
		case .opened: completion(.opened)
		case .closed: completion(.closed)
		case .disable: completion(.disable)
		}
	}
	
	func startInteractiveTransition(_ state: State, duration: TimeInterval) {
		presentElementsAnimation(state, duration: duration)  {
			(response) in
			let nextState = self.getNextState(response)
			self.state = NextState(current: response, next: nextState)
		}
		
		for animator in runningAnimations {
			animator.pauseAnimation()
			animationProgressWhenInterrupted = animator.fractionComplete
		}
	}
	
	func updateInteractiveTransition(_ fractionCompleted: CGFloat) {
		for animator in runningAnimations {
			animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
		}
	}
	
	func continueInteractiveTransition (){
		for animator in runningAnimations {
			animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
		}
	}
	
	private func setupCard() {
		visualEffectView = UIVisualEffectView()
		visualEffectView.frame = self.view.frame
		self.view.addSubview(visualEffectView)
		
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleCardTap))
		let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleCardPan))
		
		contentView.addGestureRecognizer(tapGestureRecognizer)
		contentView.addGestureRecognizer(panGestureRecognizer)
	}
	
	private func setupLayout() {
		self.view.backgroundColor = .clear
		self.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: self.frame.width, height: self.frame.height)
		self.contentView.fillSuperview(padding: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
	}
	
	private func toggleState(_ state: State) {
		let nextState = getNextState(state)
		self.state = NextState(current: state, next: nextState)
	}
	
	private func getNextState(_ state: State) -> State {
		switch state {
		case .fullScreen: return .closed
		case .opened: return .fullScreen
		case .closed: return .opened
		case .disable: return .closed
		}
	}
	
	private func getOffset(_ state: State, offset: CGFloat? = nil) -> CGFloat {
		switch state {
		case .fullScreen: return offset ?? self.frame.height
		case .opened: return 180
		case .closed: return 80
		case .disable: return 0
		}
	}
	
	@objc func handleCardTap(recognzier: UITapGestureRecognizer) {
		switch recognzier.state {
		case .ended:
			presentElementsAnimation(state.current, duration: 0.5) {
				(response) in
				self.toggleState(response)
			}
		default:
			break
		}
	}
	
	@objc func handleCardPan (recognizer: UIPanGestureRecognizer) {
		let translation = recognizer.translation(in: self.contentView)
		var fractionComplete: CGFloat!
		
		switch recognizer.state {
		case .began:
			if translation.y > 0 {
				startInteractiveTransition(.closed, duration: 0.3)
			} else {
				switch self.state.current {
				case .fullScreen: startInteractiveTransition(.fullScreen, duration: 0.3)
				case .opened: startInteractiveTransition(.opened, duration: 0.3)
				case .closed: startInteractiveTransition(.closed, duration: 0.3)
					
				default:
					break
				}
			}
			
		case .changed:
			fractionComplete = translation.y > 0 ? translation.y / frame.height : -translation.y / frame.height
			updateInteractiveTransition(fractionComplete)
			
		case .ended:
			continueInteractiveTransition()
			
		default:
			break
		}
	}
	
}

