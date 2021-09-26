//
//  AppDelegate.swift
//  GalleryX
//
//  Created by Won Woo Nam on 9/17/21.
//

import UIKit
import Firebase
import UnityFramework

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
        
        
        //MARK:- Unity Methods
    var unityFramework:UnityFramework?
    
    func unityFrameworkLoad() -> UnityFramework? {
        let bundlePath = Bundle.main.bundlePath.appending("/Frameworks/UnityFramework.framework")
        if let unityBundle = Bundle.init(path: bundlePath){
            if let frameworkInstance = unityBundle.principalClass?.getInstance(){
                return frameworkInstance
            }
        }
        return nil
    }
    
    func initAndShowUnity() -> Void {
        if let framework = self.unityFrameworkLoad(){
            self.unityFramework = framework
            self.unityFramework?.setDataBundleId("com.unity3d.framework")
            self.unityFramework?.runEmbedded(withArgc: CommandLine.argc, argv: CommandLine.unsafeArgv, appLaunchOpts: [:])
            self.unityFramework?.showUnityWindow()
            
        }
    }

    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        //initAndShowUnity()
        UnityEmbeddedSwift.setHostMainWindow(window)
        UnityEmbeddedSwift.setLaunchinOptions(launchOptions)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

