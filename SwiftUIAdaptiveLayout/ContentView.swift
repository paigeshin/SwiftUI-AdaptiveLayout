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
