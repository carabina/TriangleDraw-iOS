// MIT license. Copyright (c) 2019 TriangleDraw. All rights reserved.
import UIKit
import MetalKit
import QuartzCore
import TriangleDrawLibrary

protocol CAMetalLayerProtocol: class {
	var contentsScale: CGFloat { get set }
}

enum HCMetalViewCreateError: Error {
    case unableToCreateSystemDefaultDevice
}


class HCMetalView: MTKView {
	static func create(frame frameRect: CGRect) throws -> HCMetalView {
		guard let device: MTLDevice = MTLCreateSystemDefaultDevice() else {
			throw HCMetalViewCreateError.unableToCreateSystemDefaultDevice
		}
		return HCMetalView(frame: frameRect, device: device)
	}

	override init(frame frameRect: CGRect, device: MTLDevice?) {
		assert(device != nil)
		super.init(frame: frameRect, device: device)
		sharedSetup()
	}

	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		sharedSetup()
	}

	private func sharedSetup() {
		log.debug("sharedSetup")
		self.sampleCount = AppConstant.Canvas.rasterSampleCount
	}

	var renderer: HCRenderer?

	private func installRenderer() {
		guard let hcView: HCView = self.hcView else {
			log.error("installRenderer() is missing HCView")
			return
		}
		guard let canvas: E2Canvas = hcView.canvas else {
			log.error("installRenderer() is missing HCView.canvas")
			return
		}
		guard let newRenderer = HCRenderer(metalKitView: self, canvas: canvas) else {
			log.error("HCRenderer cannot be initialized")
			return
		}

		renderer = newRenderer

		renderer?.mtkView(self, drawableSizeWillChange: self.drawableSize)

		self.delegate = renderer
	}

	override func didMoveToWindow() {
		super.didMoveToWindow()
		if let window = self.window {
			log.debug("didMoveToWindow yes")
			updateContentsScale(window: window)
			installRenderer()
		} else {
			log.debug("didMoveToWindow no")
			renderer = nil
		}
	}

	var hcView: HCView? {
		return superview as? HCView
	}

	func updateContentsScale(window: UIWindow) {
		let newContentsScale: CGFloat = window.screen.nativeScale
		log.debug("set contentsScale: \(newContentsScale)")
		self.metalLayer?.contentsScale = newContentsScale
	}

	var metalLayer: CAMetalLayerProtocol? {
		return self.layer as? CAMetalLayerProtocol
	}
}
