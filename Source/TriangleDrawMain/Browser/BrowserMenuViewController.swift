// MIT license. Copyright (c) 2019 TriangleDraw. All rights reserved.
import UIKit
import Foundation
import TriangleDrawLibrary
import RadiantForms

class BrowserMenuViewController: RFFormViewController {
	static func createInsideNavigationController() -> UINavigationController {
		let vc = BrowserMenuViewController()
		let nc = UINavigationController(rootViewController: vc)
		nc.navigationBar.barStyle = .default
		nc.modalTransitionStyle = .crossDissolve
		nc.modalPresentationStyle = .formSheet
		return nc
	}

	override func loadView() {
		super.loadView()
		installDismissButton()
	}

	override func populate(_ builder: RFFormBuilder) {
		builder.navigationTitle = "App"

		builder.demo_showInfo("TriangleDraw is free software!\nYour support is appreciated.")

		builder += RFSectionHeaderTitleFormItem().title("Web")
		builder += twitterButton
		builder += instagramButton

		builder += RFSectionHeaderTitleFormItem().title("Development")
		builder += githubButton
		builder += emailDeveloperButton

		builder += RFSectionHeaderTitleFormItem().title("App")
		builder += app_version
		builder += app_creationDate
		builder += app_runCount
	}

	lazy var twitterButton: RFButtonFormItem = {
		let instance = RFButtonFormItem()
		instance.title = "twitter.com/TriangleDraw"
		instance.action = { [weak self] in
			guard let strongSelf = self else {
				log.error("Expected self to be non-nil, but got nil. Cannot open browser.")
				return
			}
			guard let url: URL = URL(string: "https://twitter.com/TriangleDraw") else {
				log.error("Unable to create url. Cannot open browser.")
				return
			}
			UIApplication.shared.open(url)
		}
		return instance
	}()

	lazy var instagramButton: RFButtonFormItem = {
		let instance = RFButtonFormItem()
		instance.title = "instagram.com/TriangleDraw"
		instance.action = { [weak self] in
			guard let strongSelf = self else {
				log.error("Expected self to be non-nil, but got nil. Cannot open browser.")
				return
			}
			guard let url: URL = URL(string: "https://www.instagram.com/triangledraw/") else {
				log.error("Unable to create url. Cannot open browser.")
				return
			}
			UIApplication.shared.open(url)
		}
		return instance
	}()

	lazy var githubButton: RFButtonFormItem = {
		let instance = RFButtonFormItem()
		instance.title = "github.com/TriangleDraw"
		instance.action = { [weak self] in
			guard let strongSelf = self else {
				log.error("Expected self to be non-nil, but got nil. Cannot open browser.")
				return
			}
			guard let url: URL = URL(string: "https://github.com/triangledraw") else {
				log.error("Unable to create url. Cannot open browser.")
				return
			}
			UIApplication.shared.open(url)
		}
		return instance
	}()

	lazy var emailDeveloperButton: RFButtonFormItem = {
		let instance = RFButtonFormItem()
		instance.title = "Email Developer"
		instance.action = { [weak self] in
			self?.td_presentEmailWithFeedback()
		}
		return instance
	}()

	lazy var app_version: RFStaticTextFormItem = {
		let versionAndCommitString: String = SystemInfo.appVersionAndCommit
		let instance = RFStaticTextFormItem()
		instance.title = "Version"
		instance.value = "\(versionAndCommitString)"
		return instance
	}()

	lazy var app_creationDate: RFStaticTextFormItem = {
		let creationDateString: String = SystemInfo.creationDateString
		let instance = RFStaticTextFormItem()
		instance.title = "Creation Date"
		instance.value = "\(creationDateString)"
		return instance
	}()

	lazy var app_runCount: RFStaticTextFormItem = {
		let count: Int = UserDefaults.standard.td_runCount()
		let instance = RFStaticTextFormItem()
		instance.title = "Run Count"
		instance.value = "\(count)"
		return instance
	}()

	// MARK: - Dismiss Button

	func installDismissButton() {
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "OK", style: .plain, target: self, action: #selector(dismissAction))
	}

	@IBAction func dismissAction() {
		self.dismiss(animated: true)
	}
}
