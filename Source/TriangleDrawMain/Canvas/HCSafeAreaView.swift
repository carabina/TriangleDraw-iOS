// MIT license. Copyright (c) 2019 TriangleDraw. All rights reserved.
import UIKit
import TriangleDrawLibrary

class HCSafeAreaView: UIView {
	var gridView: HCGridView?
	var interactionView: HCInteractionView?

	override func didMoveToWindow() {
		super.didMoveToWindow()
		if window != nil {
			addOurSubviews()
		} else {
			removeOurSubviews()
		}
	}

	func addOurSubviews() {
		let gridView = HCGridView()
		switch AppConstant.Canvas.mode {
		case .production:
			gridView.isHidden = true
		case .developer:
			gridView.isHidden = false
		}
		self.gridView = gridView
		self.addSubview(gridView)

		let interactionView = HCInteractionView(frame: CGRect.zero)
		interactionView.backgroundColor = UIColor.clear
		interactionView.isOpaque = false
		interactionView.installGestures()
		self.interactionView = interactionView
		self.addSubview(interactionView)
	}

	func removeOurSubviews() {
		if let view = gridView {
			view.removeFromSuperview()
			gridView = nil
		}
		if let view = interactionView {
			view.removeFromSuperview()
			interactionView = nil
		}
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		gridView?.frame = bounds
		interactionView?.frame = bounds
	}
}
