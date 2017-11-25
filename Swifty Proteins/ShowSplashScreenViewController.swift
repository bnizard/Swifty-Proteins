//
//  ShowSplashScreenViewController.swift
//  Swifty Proteins
//
//  Created by Bastien NIZARD on 10/2/17.
//  Copyright © 2017 Bastien NIZARD. All rights reserved.
//

import UIKit

class ShowSplashScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        perform(#selector(ShowSplashScreenViewController.showNavController), with: nil, afterDelay: 3)
    }
    
    func showNavController()
    {
        performSegue(withIdentifier: "showSplashScreen", sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
