//
//  ViewController.swift
//  mockWKWebView
//
//  Created by mzgk on 2016/10/24.
//  Copyright © 2016年 mzgk. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    var webView: WKWebView!

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // WebViewのATSを無効化
        // Info.plist -> App Transport Security Settings -> Allow Arbitrary Loads in Web Content = YES
        let myURL = URL(string: "http://www.yahoo.co.jp/")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

