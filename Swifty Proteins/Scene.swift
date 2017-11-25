//
//  Scene.swift
//  Swifty Proteins
//
//  Created by Bastien NIZARD on 10/20/17.
//  Copyright © 2017 Bastien NIZARD. All rights reserved.
//

import UIKit
import SceneKit

class Scene: SCNScene {
    
    var elem: [(Number: Int, Position: (X: Float, Y: Float, Z: Float), Type: String)] = []
    var conect: [[Int]] = [[]]
    
    init(ELEM: [(Number: Int, Position: (X: Float, Y: Float, Z: Float), Type: String)], CONECT: [[Int]]) {
        self.elem = ELEM
        self.conect = CONECT
        super.init()
        
        self.drawAtoms()
        self.drawConnection()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func drawAtoms()
    {
        for atom in elem {
            let sphere = SCNSphere(radius: 0.35)
            sphere.firstMaterial?.diffuse.contents = self.CPKcoloring(color: atom.Type)
            let sphereNode = SCNNode(geometry: sphere)
            sphereNode.position = SCNVector3(x: atom.Position.X, y: atom.Position.Y, z: atom.Position.Z)

            rootNode.addChildNode(sphereNode)
        }
    }
    
    private func drawConnection()
    {
        var i: Int = 0
        let nb_elem: Int = elem.count
        var count = 0;
        for con in conect {
            if (i < nb_elem)
            {
                let origin : SCNVector3 = SCNVector3(x: elem[i].Position.X, y: elem[i].Position.Y, z: elem[i].Position.Z)
                var j: Int = 1
                while (j < con.count)
                {
                    let nb: Int = con[j]
                    if (nb < nb_elem && i + 1 > nb)
                    {
                        let destination :  SCNVector3 = SCNVector3(x: elem[nb - 1].Position.X, y: elem[nb - 1].Position.Y, z: elem[nb - 1].Position.Z)
                        rootNode.addChildNode(CylinderLine(parent: rootNode, v1: origin, v2: destination, radius: 0.1, radSegmentCount: 48, color: UIColor.white))
                        count = count + 1;
                    }
                    j = j + 1
                }
            }
            i = i + 1
        }
    }
    
    private func CPKcoloring(color: String) -> UIColor  {
        
        switch color {
        case "H":
            return (UIColor.white)
        case "C":
            return (UIColor.black)
        case "N":
            return (UIColor(red:0.00, green:0.14, blue:0.49, alpha:1.0))
        case "O":
            return(UIColor.red)
        case "F", "Cl":
            return (UIColor.green)
        case "Br":
            return (UIColor(red:0.49, green:0.00, blue:0.00, alpha:1.0))
        case "I":
            return (UIColor(red:0.37, green:0.00, blue:0.49, alpha:1.0))
        case "He", "Ne", "Ar", "Xe", "Kr":
            return (UIColor(red:0.22, green:0.94, blue:0.99, alpha:1.0))
        case "P":
            return (UIColor.orange)
        case "S":
            return (UIColor.yellow)
        case "B":
            return (UIColor(red:0.99, green:0.73, blue:0.51, alpha:1.0))
        case "Li", "Na", "K", "Rb", "Cs", "Fr":
            return (UIColor.purple)
        case "Be", "Mg", "Ca", "Sr", "Ba", "Ra":
            return (UIColor(red:0.05, green:0.33, blue:0.02, alpha:1.0))
        case "Ti":
            return (UIColor.gray)
        case "Fe":
            return (UIColor.orange)
        default:
            return (UIColor(red:1.00, green:0.00, blue:0.60, alpha:1.0))
        }
    }
}
