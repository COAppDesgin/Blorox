//
//  GameViewController.swift
//  Blorox
//
//  Created by Tyler Jordan Cagle on 6/26/17.
//  Copyright © 2017 AppDesign. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController, SCNSceneRendererDelegate {
    
    var gameView: SCNView!
    var gameScene: SCNScene!
    var cameraNode: SCNNode!
    var targetCreationTime: TimeInterval = 0
    var highScore = 0
    var score = 0
    var time = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        initScene()
        initCamera()
        createTarget()
        createFloor()
    }
    
    func initView() {
        gameView = self.view as! SCNView
        gameView.allowsCameraControl = true
        gameView.autoenablesDefaultLighting = true
        
        gameView.delegate = self
    }
    
    func initScene() {
        gameScene = SCNScene()
        gameView.scene = gameScene
        self.gameView.backgroundColor = UIColor.white
        gameView.isPlaying = true
    }
    
    func initCamera() {
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        
        cameraNode.position = SCNVector3(x:0, y:5, z:15)
        
        gameScene.rootNode.addChildNode(cameraNode)
    }
    
    func createTarget() {
        
        let geometry:SCNGeometry = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
        
        geometry.materials.first?.diffuse.contents = UIColor.red
        
        let geometryNode = SCNNode(geometry: geometry)
        
//        geometryNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        
        gameScene.rootNode.addChildNode(geometryNode)
        
    }
    
    func createFloor() {
        
        let levelGeometry:SCNGeometry = SCNBox(width: 1, height: 0.1, length: 10, chamferRadius: 1)
        
        levelGeometry.materials.first?.diffuse.contents = UIColor.black
        
        let levelGeometryNode = SCNNode(geometry: levelGeometry)
        
        //        geometryNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        
        gameScene.rootNode.addChildNode(levelGeometryNode)

        levelGeometryNode.position = SCNVector3(x:0, y:-0.5, z:5)
        
    }
    
    func CGPointToSCNVector3(view: SCNView, depth: Float, point: CGPoint) -> SCNVector3 {
        let projectedOrigin = view.projectPoint(SCNVector3Make(0, 0, depth))
        let locationWithz   = SCNVector3Make(Float(point.x), Float(point.y), projectedOrigin.z)
        return view.unprojectPoint(locationWithz)
    }
    func dragObject(sender: UIPanGestureRecognizer){
        if(movingNow){
            let translation = sender.sender.translationInView(self.view!)
            var result : SCNVector3 = CGPointToSCNVector3(objectView, depth: tappedObjectNode.position.z, point: translation)
            tappedObjectNode.position = result
        }
        else{
            let hitResults = objectView.hitTest(sender.locationInView(objectView), options: nil)
            if hitResults.count > 0 {
                movingNow = true
            }
        }
        if(sender.state == UIGestureRecognizerState.Ended) {
        }
    }
    
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
}
