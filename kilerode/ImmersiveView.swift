//
//  ImmersiveView.swift
//  Hidden Box
//
//  Created by Sarang Borude on 8/7/24.
//

import SwiftUI
import RealityKit
import RealityKitContent
import Combine
struct ImmersiveView: View {
    
    @State var gravity = true
    @State var coox = 0.0
    @State var cooy = 0.0
    @State var cooz = 0.0
    @State var tapped = false
    @State var meteorModel = Entity()
    @State var swordModel = Entity()
    @State var leverModel = Entity()
    @State var cameraModel = Entity()
    @State var session: SpatialTrackingSession?
    @State var subscription: EventSubscription?
    @State var thisContent: RealityViewContent?
    @State var swordAnchohor: Bool = true
    @State var keypadModel = Entity()
    
    
    
    var body: some View {
        
        RealityView { content in
            
            self.thisContent = content
            
            // Add the initial RealityKit content
            if let immersiveContentEntity = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
                content.add(immersiveContentEntity)
                
                immersiveContentEntity.position = [-0.1, 0.05, -0.5] // offset for the user to osit at the armchair
                if let swordScene = try? await Entity(named: "Sword Scene", in: realityKitContentBundle) {
                    
                    if let sword = swordScene.findEntity(named: "Sword"){
                        self.swordModel = sword
                    }
                }
                
                if let meteor = immersiveContentEntity.findEntity(named: "Meteor"),
                   let keypad = immersiveContentEntity.findEntity(named: "Keypad"),
                   let lever = immersiveContentEntity.findEntity(named: "Lever"),
                   let camera = immersiveContentEntity.findEntity(named: "Camera")
                {
                    self.meteorModel = meteor
                    self.keypadModel = keypad
                    self.leverModel = lever
                    self.cameraModel = camera
                }
                
                
                let session = SpatialTrackingSession()
                let configuration = SpatialTrackingSession.Configuration(tracking: [.hand])
                _ = await session.run(configuration)
                self.session = session
                
                if(swordAnchohor == false){
                    //Setup an anchor at the user's right palm.
                    let handAnchor = AnchorEntity(.hand(.right, location: .palm), trackingMode: .continuous)
                    
                    //Add the Gauntlet scene that was set up in Reality Composer Pro.
                    if let gauntletEntity = try? await Entity(named: "Untitled Scene", in: realityKitContentBundle) {
                        
                        if let gauntlet = gauntletEntity.findEntity(named: "Gauntlet"){
                            
                            
                            //Child the gauntlet scene to the handAnchor.
                            handAnchor.addChild(gauntlet)
                            
                            // Add the handAnchor to the RealityView scene.
                            content.add(handAnchor)
                            
                        }
                        
                        
                    }
                }else{
                    let handAnchor = AnchorEntity(.hand(.right, location: .palm), trackingMode: .continuous)
                    
                    //Add the Gauntlet scene that was set up in Reality Composer Pro.
                    if let swordScene = try? await Entity(named: "Sword Scene", in: realityKitContentBundle) {
                        
                        if let sword = swordScene.findEntity(named: "Sword"){
                            
                            //Child the gauntlet scene to the handAnchor.
                            handAnchor.addChild(sword)
                            
                            // Add the handAnchor to the RealityView scene.
                            content.add(handAnchor)
                            
                        }
                        
                        
                    }
                }
                
                leverModel.components.set(HoverEffectComponent(.spotlight(
                    HoverEffectComponent.SpotlightHoverEffectStyle(
                        color: .yellow, strength: 2.0
                    )
                )))
                meteorModel.components.set(HoverEffectComponent(.spotlight(
                    HoverEffectComponent.SpotlightHoverEffectStyle(
                        color: .yellow, strength: 2.0
                    )
                )))
                cameraModel.components.set(HoverEffectComponent(.spotlight(
                    HoverEffectComponent.SpotlightHoverEffectStyle(
                        color: .yellow, strength: 2.0
                    )
                )))
                
            }
            
            subscription = content.subscribe(to: CollisionEvents.Began.self, on: meteorModel) { collisionEvent in
                
                if (collisionEvent.entityB.name == "Sword") {
                    print("Collision")
                    let animation = meteorModel.availableAnimations[0]
                    meteorModel.components.remove(CollisionComponent.self)
                    
                    meteorModel.playAnimation(animation)
                    // Delay disabling the entity until after the animation ends
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        meteorModel.isEnabled = false
                    }
                }
                
            }
            
            //            let material = PhysicsMaterialResource.generate(friction: 0.8, restitution: 0.0)
            //            let pb = PhysicsBodyComponent(material: material)
            //            meteorModel.components.set(pb)
            //            leverModel.components.set(pb)
            //            swordModel.components.set(pb)
            
            
        }.installGestures()
        
            .gesture(SpatialTapGesture().targetedToEntity(keypadModel).onEnded({ value in
                print("\(value.entity.name.replacingOccurrences(of: "keypad_", with: ""))")
            }))
        
            .gesture(
                SpatialTapGesture()
                    .targetedToEntity(where: .has(TimelineComponent.self))
                    .onEnded { value in
                        if value.entity.applyTapForBehaviors() {
                            print("Tapped")
                        }
                    }
            )
        //            .upperLimbVisibility(.hidden)
    }
}
