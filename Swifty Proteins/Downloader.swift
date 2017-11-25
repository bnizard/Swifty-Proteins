//
//  Downloader.swift
//  Swifty Proteins
//
//  Created by Bastien NIZARD on 10/13/17.
//  Copyright © 2017 Bastien NIZARD. All rights reserved.
//

import UIKit
import Darwin

class Downloader: NSObject {
    var elem: [(Number: Int, Position: (X: Float, Y: Float, Z: Float), Type: String)] = []
    var conect: [[Int]] = [[]]
    var lig = ""
    
    func load(URL: NSURL, SPINNER: UIActivityIndicatorView, CONTROLLER: ProteinListViewController, LIGAND: String) {
            lig = LIGAND
            self.conect.remove(at: 0)
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
            let request = NSMutableURLRequest(url: URL as URL)
            request.httpMethod = "GET"
            SPINNER.startAnimating()
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            let task = session.dataTask(with: request as URLRequest, completionHandler: { (data: Data!, response: URLResponse!, error: Error!) -> Void in
                if (error == nil) {
                    // Success
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    print("Success: \(statusCode)")
                    if (statusCode != 404)
                    {
                        let string1 = String(data: data, encoding: String.Encoding.utf8) ?? "Data could not be printed"
                        string1.enumerateLines { line, _ in
                            let element = line.condensedWhitespace.components(separatedBy: " ")
                            if (element[0] == "ATOM")
                            {
                                self.elem += [(Number: Int(element[1])!, Position: (X: Float(element[6])!, Y: Float(element[7])!, Z: Float(element[8])!), Type: element[11])]
                            }
                            if (element[0] == "CONECT")
                            {
                                var con: [Int] = []
                                var i: Int = 1
                                while (i < element.count)
                                {
                                    con += [Int(element[i])!]
                                    i += 1
                                }
                                self.conect.append(con)
                            }
                        }
                        DispatchQueue.main.async() {
                            SPINNER.stopAnimating()
                            CONTROLLER.performSegue(withIdentifier: "goToLigandScreen", sender: self)
                        }
                    }
                    else // Error 404
                    {
                        DispatchQueue.main.async() {
                            SPINNER.stopAnimating()
                            let alertController = UIAlertController(title: "Error", message:
                                "Impossible de trouver le ligand", preferredStyle: UIAlertControllerStyle.alert)
                            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                            
                            CONTROLLER.present(alertController, animated: true, completion: nil)
                        }
                    }
                }
                else {
                    // Failure
                    DispatchQueue.main.async() {
                        SPINNER.stopAnimating()
                        let alertController = UIAlertController(title: "Error", message:
                            "Impossible de charger le ligand", preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                        
                        CONTROLLER.present(alertController, animated: true, completion: nil)
                    }
                    print("Failure: %@", error.localizedDescription);
                }
            })
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            task.resume()
        }
}

extension String {
    var condensedWhitespace: String {
        let components = self.components(separatedBy: .whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
}
