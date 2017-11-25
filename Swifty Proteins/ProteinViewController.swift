//
//  ProteinViewController.swift
//  Swifty Proteins
//
//  Created by Bastien NIZARD on 10/21/17.
//  Copyright © 2017 Bastien NIZARD. All rights reserved.
//

import UIKit
import SceneKit

class ProteinViewController: UIViewController {

    @IBOutlet weak var titleLigand: UINavigationItem!
    @IBOutlet weak var scnView: SCNView!
    
    let tapRec = UITapGestureRecognizer()
    
    
    @IBOutlet weak var typeLabel: UILabel!

    @IBAction func shareButtonAction(_ sender: Any) {
        let image =  scnView.snapshot()
        
        var imagesToShare = [AnyObject]()
        imagesToShare.append(image)
        
        let activityViewController = UIActivityViewController(activityItems: imagesToShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        present(activityViewController, animated: true, completion: nil)
    }
    
    
     var elem: [(Number: Int, Position: (X: Float, Y: Float, Z: Float), Type: String)] = []
     var conect: [[Int]] = [[]]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapRec.addTarget(self, action: #selector(ProteinViewController.tapBlurButton(_:)))
        scnView?.addGestureRecognizer(tapRec)
        
        scnView.scene = Scene(ELEM: elem, CONECT: conect) 
        scnView.backgroundColor = UIColor.white
        
        scnView.autoenablesDefaultLighting = true
        scnView.allowsCameraControl = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tapBlurButton(_ sender: UITapGestureRecognizer) {
        var text = "Type: "
        let location = tapRec.location(in: scnView)
        let hits = self.scnView.hitTest(location, options: nil)
        if let tappedNode = hits.first?.node {
            text += self.findTypeWithCoordonates(Position: tappedNode.position)
            if (text != "Type: KO")
            {
                typeLabel.text = text
            }
        }
    }
    
    private func findTypeWithCoordonates(Position: SCNVector3) -> String
    {
        for atom in elem {
            if (Position.x == atom.Position.X && Position.y == atom.Position.Y && Position.z == atom.Position.Z)
            {
                return (atom.Type)
            }
        }
        return ("KO")
    }
}
