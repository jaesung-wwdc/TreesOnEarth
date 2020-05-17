//
//  GameViewController.swift
//  GreenForest
//
//  Created by 이재성 on 2020/05/17.
//  Copyright © 2020 SweetLab. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    var sceneView: SCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // retrieve the SCNView
        self.sceneView = self.view as? SCNView
        
        // allows the user to manipulate the camera
        self.sceneView.allowsCameraControl = true
        
        // configure the view
        self.sceneView.backgroundColor = .black
        
        self.sceneView.autoenablesDefaultLighting = true
        
        self.loadEarth()
        
        self.rotateEarth()
    }
    
    // MARK: - Create Earth
    private func loadEarth() {
        guard let scene = SCNScene(named: "art.scnassets/earth.scn") else { return }
        self.sceneView.scene = scene
        self.sceneView.backgroundColor = .black
        
        for _ in 0..<500 {
            self.addTreeToEarth(scene.rootNode)
        }
    }
    
    
    private func addTreeToEarth(_ earth: SCNNode) {
        guard let scene = SCNScene(named: "art.scnassets/tree.scn") else { return }
        // If you use rootNode as treeNode, will face
        // "[SCNKit ERROR] removing the root node of a scene from its scene is not allowed"
        guard let treeNode = scene.rootNode.childNode(withName: "Trunk", recursively: true) else { return }
        let latitude = CGFloat.random(in: -180..<180)
        let longitude = CGFloat.random(in: -180..<180)
        treeNode.position = convertedAxisFromAngle(radius: 4.0, latitude: latitude, longitude: longitude)
        treeNode.eulerAngles = SCNVector3((latitude) * .pi / CGFloat(180), 0, (longitude - 90) * .pi / CGFloat(180))  // y axis is ignorable
        
        earth.addChildNode(treeNode)
    }
    
    private func convertedAxisFromAngle(radius: CGFloat, latitude: CGFloat, longitude: CGFloat) -> SCNVector3 {
        let xy = radius * cos(latitude * .pi / CGFloat(180))
        let x = xy * cos(longitude * .pi / CGFloat(180))
        let y = xy * sin(longitude * .pi / CGFloat(180))
        let z = radius * sin(latitude * .pi / CGFloat(180))
        
        return SCNVector3(x, y, z)
    }
    
    
    // MARK: - Animation
    private func rotateEarth() {
        guard let earthNode = self.sceneView.scene?.rootNode else { return }
        let rotateAction = SCNAction.repeatForever(SCNAction.rotate(by: .pi, around: SCNVector3(0, 1, 0), duration: 5))
        
        earthNode.runAction(rotateAction)
        
    }
}
