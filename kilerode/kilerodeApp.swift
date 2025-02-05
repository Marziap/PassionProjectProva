//
//  kilerodeApp.swift
//  kilerode
//
//  Created by Gianrocco Di Tomaso on 20/01/25.
//

import SwiftUI
import RealityKitContent

@main
struct kilerodeApp: App {
    
    @State private var appModel = AppModel()
    @State private var avPlayerViewModel = AVPlayerViewModel()
    
    init() {
        RealityKitContent.ObjComponent.registerComponent()
        RealityKitContent.MeteorComponent.registerComponent()
        RealityKitContent.TimelineComponent.registerComponent()
        RealityKitContent.KeyComponent.registerComponent()
        //call this once to register the component
    }
    
    var body: some Scene {
        WindowGroup {
            if avPlayerViewModel.isPlaying {
                AVPlayerView(viewModel: avPlayerViewModel)
            } else {
                ContentView()
                    .environment(appModel)
            }
        }
        
        ImmersiveSpace(id: appModel.immersiveSpaceID) {
            ImmersiveView()
                .environment(appModel)
                .onAppear {
                    appModel.immersiveSpaceState = .open
                    avPlayerViewModel.play()
                }
                .onDisappear {
                    appModel.immersiveSpaceState = .closed
                    avPlayerViewModel.reset()
                }
        }
        .immersionStyle(selection: .constant(.full), in: .full)
    }
}
