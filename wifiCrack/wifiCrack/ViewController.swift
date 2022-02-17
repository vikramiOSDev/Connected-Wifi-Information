//
//  ViewController.swift
//  wifiCrack
//
//  Created by apple on 06/01/22.
//

import UIKit
import Foundation
import SystemConfiguration.CaptiveNetwork
import CoreLocation

enum AppKeys: String {
    case foregroundView         = "foregroundView"
    case numberOfActiveBars     = "numberOfActiveBars"
    case statusBar              = "statusBar"
    case wifiStrengthRaw        = "wifiStrengthRaw"
}



enum WiFISignalStrength: Int {
    case weak = 0
    case ok = 1
    case veryGood = 2
    case excellent = 3

    func convertBarsToDBM() -> Int {
        switch self {
        case .weak:
            return -90
        case .ok:
            return -70
        case .veryGood:
            return -50
        case .excellent:
            return -30
        }
    }
}

struct WiFiInfo {
    var rssi: String
    var networkName: String
    var macAddress: String
}


class ViewController: UIViewController {
//    var locationManager = CLLocationManager()
//    var currentNetworkInfos: Array<NetworkInfo>? {
//        get {
//            return SSID.fetchNetworkInfo()
//        }
//    }
//    @IBOutlet weak var ssidLabel: UILabel!
//    @IBOutlet weak var bssidLabel: UILabel!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let manager = CLLocationManager()
//        let authorizationStatus: CLAuthorizationStatus
//
//        if #available(iOS 14, *) {
//            authorizationStatus = manager.authorizationStatus
//        } else {
//            authorizationStatus = CLLocationManager.authorizationStatus()
//            updateWiFi()
//        }
//
//        switch authorizationStatus {
//        case .restricted, .denied:
//            locationManager.delegate = self
//            locationManager.requestWhenInUseAuthorization()
//        default:
//            updateWiFi()
//        }
//
//
//
//    }
//
//    func updateWiFi() {
//        print("SSID: \(currentNetworkInfos?.first?.ssid ?? "")")
//        print(currentNetworkInfos?.first?.ssid)
////        ssidLabel.text = currentNetworkInfos?.first?.ssid
////        bssidLabel.text = currentNetworkInfos?.first?.bssid
//    }
//
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == .authorizedWhenInUse {
//            updateWiFi()
//        }
//    }
    
    
    
    var locationManager: CLLocationManager?

     override func viewDidLoad() {
       super.viewDidLoad()

       locationManager = CLLocationManager()
       locationManager?.delegate = self
       locationManager?.requestAlwaysAuthorization()
     }

     func getWiFiName() -> WiFiInfo? {
//       var ssid: String?
//
//       if let interfaces = CNCopySupportedInterfaces() as NSArray? {
//         for interface in interfaces {
//           if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
//             ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
//
//
//             break
//           }
//
//
//
//
//
//
//
//
//
//         }
//       }
//
//       return ssid
         
         guard let interfaces = CNCopySupportedInterfaces() as? [String] else {
                return nil
            }
            var wifiInfo: WiFiInfo? = nil
            for interface in interfaces {
                guard let interfaceInfo = CNCopyCurrentNetworkInfo(interface as CFString) as NSDictionary? else {
                    return nil
                }
                guard let ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String else {
                   return nil
                }
                guard let bssid = interfaceInfo[kCNNetworkInfoKeyBSSID as String] as? String else {
                    return nil
                }
                var rssi: Int = 0
                if let strength = getWifiStrength() {
                    rssi = strength
                }
                wifiInfo = WiFiInfo(rssi: "\(rssi)", networkName: ssid, macAddress: bssid)
                break
            }
            return wifiInfo
         
         
         
         
         
         
         
         
     }
    
    
    
    
    private func getWifiStrength() -> Int? {
        return isiPhoneX() ? getWifiStrengthOnIphoneX() : getWifiStrengthOnDevicesExceptIphoneX()
    }
    
    
    
    private func getWifiStrengthOnDevicesExceptIphoneX() -> Int? {
        var rssi: Int?
//        guard let statusBar = view.window?.windowScene?.statusBarManager?.statusBarFrame,
//              let foregroundView = statusBar.value(forKey:"foregroundView") as? UIView else {
//                  return rssi
//        }
//        for view in foregroundView.subviews {
//            if let statusBarDataNetworkItemView = NSClassFromString("UIStatusBarDataNetworkItemView"),
//               view.isKind(of: statusBarDataNetworkItemView) {
//                if let val = view.value(forKey:"fiStrengthRaw") as? Int {
//                      rssi = val
//                      break
//                  }
//            }
//        }
//        return rssi
        
        let localStatusBar = view.window?.windowScene?.statusBarManager?.value(forKey: "createLocalStatusBar") as? NSObject
        
        
        let statusBar = localStatusBar?.value(forKey: "statusBar") as? NSObject
        
        
//        let foregroundView = statusBar?.value(forKey: "foregroundView") as! UIView
//                let foregroundViewSubviews = foregroundView.subviews
//                var dataNetworkItemView: UIView!
//                for subview in foregroundViewSubviews {
//                    if subview.isKind(of: NSClassFromString("UIStatusBarSignalStrengthItemView")!) {
//                        dataNetworkItemView = subview
//                        break
//                    } else {
//
//                    }
//                }
//               let  signalStrength = dataNetworkItemView.value(forKey: "signalStrengthBars") as! Int
//                if signalStrength == -1 {
//                    return nil
//                } else {
//                    return signalStrength
//                }
        
        
        
        
        
        
        
        
        let _statusBar = statusBar?.value(forKey: "_statusBar") as? UIView
        let currentData = _statusBar?.value(forKey: "currentData")  as? NSObject
        let celluar = currentData?.value(forKey: "cellularEntry") as? NSObject
       if  let signalStrength = celluar?.value(forKey: "displayValue") as? Int{
                              rssi = signalStrength
                              
                          }
        
        
        
//        let statusBar = localStatusBar.value(forKey: "statusBar") as? NSObject,
//        let _statusBar = statusBar.value(forKey: "_statusBar") as? UIView,
//                   let currentData = _statusBar.value(forKey: "currentData")  as? NSObject,
//                   let celluar = currentData.value(forKey: "cellularEntry") as? NSObject,
//                   let signalStrength = celluar.value(forKey: "displayValue") as? Int {
//                   return signalStrength
//
        
        
        
        return rssi
        
        
    }
    
    func isiPhoneX() -> Bool {
    if UIDevice().userInterfaceIdiom == .phone {
    switch UIScreen.main.nativeBounds.height {
    case 1136:
    print("“iPhone 5 or 5S or 5C”")
    break
    case 1334:
    print("“iPhone 6/6S/7/8”")
    break
    case 2208:
    print("“iPhone 6+/6S+/7+/8+”")
    break
    case 2436:
    //print(“iPhone X”)
    return true
    default:
    break
    //print(“unknown”)
    }
    }
    return false
    }
    
    private func getWifiStrengthOnIphoneX() -> Int? {
            guard let numberOfActiveBars = getWiFiNumberOfActiveBars(), let bars = WiFISignalStrength(rawValue: numberOfActiveBars) else {
                return nil
            }
            return bars.convertBarsToDBM()
        }
    
    
    
    private func getWiFiNumberOfActiveBars() -> Int? {
            var numberOfActiveBars: Int?
            guard let containerBar = UIApplication.shared.value(forKey: AppKeys.statusBar.rawValue) as? UIView else {
                return nil
            }
            guard let statusBarModern = NSClassFromString("UIStatusBar_Modern"), containerBar.isKind(of: statusBarModern),
                  let statusBar = containerBar.value(forKey: AppKeys.statusBar.rawValue) as? UIView else {
                  return nil
            }
            guard let foregroundView = statusBar.value(forKey: AppKeys.foregroundView.rawValue) as? UIView else {
                return nil
            }
            for view in foregroundView.subviews {
                for v in view.subviews {
                   if let statusBarWifiSignalView = NSClassFromString("_UIStatusBarWifiSignalView"), v.isKind(of: statusBarWifiSignalView) {
                       if let val = v.value(forKey: AppKeys.numberOfActiveBars.rawValue) as? Int {
                           numberOfActiveBars = val
                           break
                       }
                   }
                }
                if let _ = numberOfActiveBars {
                   break
                }
            }
            return numberOfActiveBars
        }
    
   
    
    
    
    
    
    
}




extension ViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .authorizedAlways || status == .authorizedAlways {
      let ssid = self.getWiFiName()
      print("SSID: \(String(describing: ssid))")
    }
  }
}

//public class SSID {
//    class func fetchNetworkInfo() -> [NetworkInfo]? {
//        if let interfaces: NSArray = CNCopySupportedInterfaces() {
//            var networkInfos = [NetworkInfo]()
//            for interface in interfaces {
//                let interfaceName = interface as! String
//                var networkInfo = NetworkInfo(interface: interfaceName,
//                                              success: false,
//                                              ssid: nil,
//                                              bssid: nil)
//                if let dict = CNCopyCurrentNetworkInfo(interfaceName as CFString) as NSDictionary? {
//                    networkInfo.success = true
//                    networkInfo.ssid = dict[kCNNetworkInfoKeySSID as String] as? String
//                    networkInfo.bssid = dict[kCNNetworkInfoKeyBSSID as String] as? String
//                }
//                networkInfos.append(networkInfo)
//            }
//            return networkInfos
//        }
//        return nil
//    }
//}
//
//struct NetworkInfo {
//    var interface: String
//    var success: Bool = false
//    var ssid: String?
//    var bssid: String?
//}
