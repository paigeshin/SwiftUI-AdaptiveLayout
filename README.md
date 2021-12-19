### Device

```swift
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
```

### view + adapted

```swift
//
//  Helper.swift
//  SwiftUIAdaptiveLayout
//
//  Created by paige on 2021/12/19.
//

import SwiftUI

//{
//    get {
//        return UIDevice.current.orientation.isPortrait ? .width : .height
//    }
//}

struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}

extension View {

    //Input, design CGFloat
    //Output, new CGFloat adpated to BaseScreenSize Ratio
    func adapted(dimensionSize: CGFloat, to dimension: Dimension, applyOnPortrait: Bool = true, applyOnLandscape: Bool = true) -> CGFloat {

        //In order to get the current device screen dimensions, we have to call UIScreen.main.bounds.size
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height

        var ratio: CGFloat = 0.0
        var resultDiemsnionSize: CGFloat = 0.0

        switch dimension {
        case .width:
            if applyOnPortrait {
                //To adapt CGFloat in base dimension (design dimension) passed to the function, first we need to calculate the ratio of base dimension size to base screen size.
                ratio = dimensionSize / Device.baseScreenSize.rawValue.width
                // Then we have to multiply the current width or height by the ratio to get the adapted CGFloat for the current screen size:
                resultDiemsnionSize = screenWidth * ratio
                print("width ratio: \(ratio)")
                print("width dimensionsize: \(resultDiemsnionSize)")
                return resultDiemsnionSize
            }
        case .height:
            if applyOnLandscape {
                ratio = dimensionSize / Device.baseScreenSize.rawValue.height
                resultDiemsnionSize = screenHeight * ratio
                print("height ratio: \(ratio)")
                print("height dimensionsize: \(resultDiemsnionSize)")
                return resultDiemsnionSize
            }
        }
        return dimensionSize
    }

    //The main purpose of the resized function is to resize passed CGSize preserveing the initial apsect ratio.
    //We can choose which dimensino will be taken into account when rezing the base CGSize: Width or Height
    func resized(size: CGSize, basedOn dimension: Dimension, applyOnPortrait: Bool = true, applyOnLandscape: Bool = true) -> CGSize {
        //In order to get the current device screen dimensions, we have to call UIScreen.main.bounds.size
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height

        var ratio: CGFloat = 0.0
        var width: CGFloat = 0.0
        var height: CGFloat = 0.0

        switch dimension {
        case .width:
            if applyOnPortrait {
                ratio = size.height / size.width
                width = screenWidth * (size.width / Device.baseScreenSize.rawValue.width)
                height = width * ratio
                return CGSize(width: width, height: height)
            }
        case .height:
            if applyOnLandscape {
                ratio = size.width / size.height
                height = screenHeight * (size.height / Device.baseScreenSize.rawValue.height)
                width = height * ratio
                return CGSize(width: width, height: height)
            }
        }
        return size
    }
}
```

### AppObject

```swift
//
//  AppObject.swift
//  SwiftUIAdaptiveLayout
//
//  Created by paige on 2021/12/19.
//

import SwiftUI

class AppObject: ObservableObject {

    @Published var dimension: Dimension = .width

}
```

### How to use

- you can just set `to` to `width` or `height` to make it a fixed size without providing `applyOnLandScape` and `applyOnPortrait`

```swift
//
//  ContentView.swift
//  SwiftUIAdaptiveLayout
//
//  Created by paige on 2021/12/19.
//

import SwiftUI

struct ContentView: View {

    @StateObject var appObject = AppObject()

    var body: some View {
        // you can just set `to` to width or height to make it a fixed size without providing `applyOnLandScape` and `applyOnPortrait`
        Text("Hello, world!")
            .font(.system(size: adapted(dimensionSize: 24, to: appObject.dimension, applyOnLandscape: false)))
            .onRotate { orientation in
                if orientation.isPortrait {
                    Text("Portrait")
                    appObject.dimension = .width
                } else if orientation.isLandscape {
                    Text("Landscape")
                    appObject.dimension = .height
                } else if orientation.isFlat {
                    Text("Flat")
                } else {
                    Text("Unknown")
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
```
