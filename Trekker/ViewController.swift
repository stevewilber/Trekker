//
//  ViewController.swift
//  Trekker
//
//  Created by Steve Wilber on 8/20/20.
//  Copyright © 2020 Firebase. All rights reserved.
//

import UIKit
import FirebaseRemoteConfig
import FirebaseAnalytics

class ViewController: UIViewController {
        let reviewEnabledKey = "review_feature_enabled"
        
        var remoteConfig: RemoteConfig!
        @IBOutlet weak var imageView: UIImageView!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            NotificationCenter.default.addObserver(self, selector:#selector(ViewController.fetchConfig), name: UIApplication.didEnterBackgroundNotification, object: UIApplication.shared)
            Analytics.setUserProperty("swilber@google.com", forName:"username")
            remoteConfig = RemoteConfig.remoteConfig()
            let settings = RemoteConfigSettings()
            settings.minimumFetchInterval = 0
            remoteConfig.configSettings = settings
            remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
            fetchConfig()
        }
        
        @objc func fetchConfig() {
            let expirationDuration = 0

            remoteConfig.fetch(withExpirationDuration: TimeInterval(expirationDuration)) { status, error in
                if status == .success {
                    print("Config fetched!")
                    self.remoteConfig.activate(completionHandler: { (error) in
                        // ...
                    })
                } else {
                    print("Config not fetched")
                    print("Error: \(error?.localizedDescription ?? "No error available.")")
                }
                
                self.displayDriverPage()
            }
        }
        
        func displayDriverPage() {
            let reviewEnabled = remoteConfig[reviewEnabledKey].boolValue
            imageView.image = loadImage(reviewEnabled: reviewEnabled)
        }

        func loadImage(reviewEnabled: Bool) -> UIImage? {
    //        let data: Data? = nil
    //        return UIImage(data: data!)
            if (reviewEnabled) {
                return UIImage(named: "reviews_on.png")
            } else {
                return UIImage(named: "reviews_off.png")
            }
        }
        
        override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
}

