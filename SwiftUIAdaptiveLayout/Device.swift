//
//  Device.swift
//  SwiftUIAdaptiveLayout
//
//  Created by paige on 2021/12/19.
//

import SwiftUI

enum Dimension {
    case width
    case height
}

enum Device: RawRepresentable {
    
    static let baseScreenSize: Device = .iPhone13ProMax
    
    typealias RawValue = CGSize
    
    init?(rawValue: CGSize) {
        switch rawValue {
        case CGSize(width: 320, height: 480):
            self = .iPhone4
        case CGSize(width: 320, height: 568):
            self = .iPhoneSE
        case CGSize(width: 375, height: 667):
            self = .iPhone8
        case CGSize(width: 414, height: 736):
            self = .iPhone8Plus
        case CGSize(width: 375, height: 812):
            self = .iPhone11Pro
        case CGSize(width: 390, height: 844):
            self = .iPhone12
        case CGSize(width: 414, height: 896):
            self = .iPhone11ProMax
        case CGSize(width: 428, height: 926):
            self = .iPhone13ProMax
        default:
            return nil
        }
    }
    
    case iPhone4
    case iPhoneSE
    case iPhone8
    case iPhone8Plus
    case iPhone11Pro
    case iPhone12
    case iPhone11ProMax
    case iPhone13ProMax
    
    var rawValue: CGSize {
        switch self {
        case .iPhone4:
            return CGSize(width: 320, height: 480)
        case .iPhoneSE:
            return CGSize(width: 320, height: 568)
        case .iPhone8:
            return CGSize(width: 375, height: 667)
        case .iPhone8Plus:
            return CGSize(width: 414, height: 736)
        case .iPhone12:
            return CGSize(width: 390, height: 844)
        case .iPhone11Pro:
            return CGSize(width: 375, height: 812)
        case .iPhone11ProMax:
            return CGSize(width: 414, height: 896)
        case .iPhone13ProMax:
            return CGSize(width: 428, height: 926)
        }
    }
    
}
