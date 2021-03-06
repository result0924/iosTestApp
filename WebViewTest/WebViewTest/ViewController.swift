//
//  ViewController.swift
//  WebViewTest
//
//  Created by jlai on 2020/8/28.
//  Copyright © 2020 jlai. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadURL(urlString: "https://dev.health2sync.com/upload/clinic/interactive_article_image/6f4dca07-13a1-444a-8d12-92b970291446.png")
    }
    
    private func loadURL(urlString: String) {
        let url = URL(string: urlString)
        if let url = url {
            let request = URLRequest(url: url)
            webView.navigationDelegate = self
            webView.load(request)
        }
    }

}

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            if challenge.previousFailureCount == 0 {
                let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
                completionHandler(URLSession.AuthChallengeDisposition.useCredential,credential)
            }else{
                completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge,nil)
            }
        }else{
            completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge,nil)
        }
    }
}

extension WKWebView {
    class func clean() {
        guard #available(iOS 9.0, *) else {return}

        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)

        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                #if DEBUG
                    print("WKWebsiteDataStore record deleted:", record)
                #endif
            }
        }
    }
}
