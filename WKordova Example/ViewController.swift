// ViewController.swift

import UIKit
import WebKit
import WKdova

class ViewController: UIViewController, WKNavigationDelegate {
	var contentOffsetForKeyboard: CGFloat = 0
	var launchScreenView: UIView?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// A cute hack, we display the LaunchScreen content until the webView is finished loading.
		let storyboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
		let controller = storyboard.instantiateInitialViewController()!
		//self.addChild(controller)
		self.view.addSubview(controller.view)
		launchScreenView = controller.view
		
		let webView = WKWebView(frame: .zero)
		webView.scrollView.contentInsetAdjustmentBehavior = .never; // Disable the safe area behaviour.
		webView.scrollView.bounces = false
		webView.isOpaque = false // Prevents flashing of the white view
		webView.backgroundColor = UIColor.clear // Prevents flashing of the white view
		webView.alpha = 0
		view.addSubview(webView)
		webView.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			webView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
			webView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
			webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
			webView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
		])
		guard let url = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "") else {
			fatalError("Passed in invalid URL")
		}
		webView.navigationDelegate = self
		webView.load(URLRequest(url: url))
		
		let wkd = WKdova(webView)
		wkd.DEBUG = false
		
		// Bug where keyboard moves layout, https://stackoverflow.com/a/47519415/279890
		NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { (notification) in
			self.contentOffsetForKeyboard = webView.scrollView.contentOffset.y
		}
		NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { (notification) in
			webView.scrollView.contentOffset.y = self.contentOffsetForKeyboard
			self.contentOffsetForKeyboard = 0
		}
	}
	
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		print("Finished navigating to url \(String(describing: webView.url))");
		UIView.animate(withDuration: 1.5, animations: {
			webView.alpha = 1
		}) { (finished) in
			if self.launchScreenView != nil {
				self.launchScreenView?.removeFromSuperview()
			}
		}
	}
}
