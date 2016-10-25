//
//  ViewController.swift
//  mockWKWebView
//
//  Created by mzgk on 2016/10/24.
//  Copyright © 2016年 mzgk. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, UIPopoverPresentationControllerDelegate {

    var webView: WKWebView!
    var targetURL: String!

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

    // リンク等の長押しで表示されるアクションシートをハックする
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        if let orgActionSheet = viewControllerToPresent as? UIAlertController {
            let url = orgActionSheet.title!

            let newActionSheet = UIAlertController(title: orgActionSheet.title, message: orgActionSheet.message, preferredStyle: orgActionSheet.preferredStyle)
            newActionSheet.addAction(UIAlertAction(title: "新規タブで開く", style: .destructive, handler: { (action) -> Void in
                // url に対して何かする -> JavaScript : window.openなのか？
                print("新規タブで開く: URL=\(url)")
                self.targetURL = url
                self.webView.evaluateJavaScript("window.open('\(self.targetURL)', '_blank')", completionHandler: nil)
            }))

            // 既存のアクションシート項目を追加
            for action in orgActionSheet.actions {
                newActionSheet.addAction(action)
            }

            super.present(newActionSheet, animated: true, completion: {
            })
            // iPad用（画面の中央に表示させる）
            newActionSheet.popoverPresentationController?.sourceView = self.view
            newActionSheet.popoverPresentationController?.sourceRect = self.view.bounds
            newActionSheet.popoverPresentationController?.permittedArrowDirections = .init(rawValue: 0)
        }
        return
    }

    // self.webView.evaluateJavaScript("window.open('\(self.targetURL)')", completionHandler: nil)からCallされている
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {

        // 新しいViewを作成する
        let myURL = URL(string: targetURL)
        let myRequest = URLRequest(url: myURL!)
        let tabView = WKWebView(frame: view.frame, configuration: configuration)
        tabView.load(myRequest)
        self.view.addSubview(tabView)
        self.view.bringSubview(toFront: tabView)    // わかりやすく最前面にもってくる（確認用）

        return tabView
        // これで元のViewの上に新たなViewが出来上がる（あとは新規Tabとして表示させる方法を考える）
        // もしかして、表示する用のViewは１つだけで、loadまでしたWKWebViewのインスタンスを配列に追加
        // 同じくTabに見立てたViewを画面に追加していって、タップされたTabに紐づくWKWebViewインスタンスを
        // 配列から取り出して、Viewに入れ込んでるだけか？
    }
}

