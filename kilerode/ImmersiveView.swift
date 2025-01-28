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
    
    @State var skullModel = Entity()
    @State var pipettaModel = Entity()
    @State var cameraModel = Entity()
    @State var gravity = true
    @State var coox = 0.0
    @State var cooy = 0.0
    @State var cooz = 0.0
    @State var tapped = false
    @State var meteorModel = Entity()
    @State var gameModel = Entity()
    
    
    var body: some View {
        
        RealityView { content in
            
            // Add the initial RealityKit content
            if let immersiveContentEntity = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
                content.add(immersiveContentEntity)
                
                immersiveContentEntity.position = [-0.1, 0.05, -0.5] // offset for the user to osit at the armchair
                
                
                
                if let skull = immersiveContentEntity.findEntity(named: "Skull"),
                   let camera = immersiveContentEntity.findEntity(named: "DSLR_Camera"),
                   let pipetta = immersiveContentEntity.findEntity(named: "Bunsen_Burner"),
                   let game = immersiveContentEntity.findEntity(named: "Toy_Rocket_3"),
                   let meteor = immersiveContentEntity.findEntity(named: "Meteor")
                {
                    self.skullModel = skull
                    self.cameraModel = camera
                    self.pipettaModel = pipetta
                    self.gameModel = game
                    self.meteorModel = meteor
                }
                
                skullModel.components.set(HoverEffectComponent(.spotlight(
                    HoverEffectComponent.SpotlightHoverEffectStyle(
                        color: .yellow, strength: 2.0
                    )
                )))
                cameraModel.components.set(HoverEffectComponent(.spotlight(
                    HoverEffectComponent.SpotlightHoverEffectStyle(
                        color: .yellow, strength: 2.0
                    )
                )))
                pipettaModel.components.set(HoverEffectComponent(.spotlight(
                    HoverEffectComponent.SpotlightHoverEffectStyle(
                        color: .yellow, strength: 2.0
                    )
                )))
                meteorModel.components.set(HoverEffectComponent(.spotlight(
                    HoverEffectComponent.SpotlightHoverEffectStyle(
                        color: .yellow, strength: 2.0
                    )
                )))
                gameModel.components.set(HoverEffectComponent(.spotlight(
                    HoverEffectComponent.SpotlightHoverEffectStyle(
                        color: .yellow, strength: 2.0
                    )
                )))
            }
            
            let material = PhysicsMaterialResource.generate(friction: 0.8, restitution: 0.0)
            let pb = PhysicsBodyComponent(material: material)
            
            
            skullModel.components.set(pb)
            cameraModel.components.set(pb)
            pipettaModel.components.set(pb)
            gameModel.components.set(pb)
            meteorModel.components.set(pb)
            
            
        }.installGestures()
        
            .gesture(SpatialTapGesture().targetedToEntity(where: .has(ObjComponent.self)).onEnded({ value in
//                tapped.toggle()
                  print("tapped")
//                coox = value.location3D.x
//                cooy = value.location3D.y
//                cooz = value.location3D.z
            }))
        
            .gesture(SpatialTapGesture().targetedToEntity(where: .has(MeteorComponent.self)).onEnded({ value in
                print("animate")
                let animation = value.entity.availableAnimations[0]
                value.entity.playAnimation(animation)

            }))
        
    }
}


#Preview(immersionStyle: .mixed) {
    ImmersiveView()
        .environment(AppModel())
}
