//
//  ProteinListViewController.swift
//  Swifty Proteins
//
//  Created by Bastien NIZARD on 10/3/17.
//  Copyright © 2017 Bastien NIZARD. All rights reserved.
//

import UIKit

class ProteinListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var TableView: UITableView!
    
    @IBOutlet weak var SearchBar: UISearchBar!
    
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    
    var list = [String]()
    var filteredData = [String]()
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        self.ShowLigands()
        SearchBar.returnKeyType =  UIReturnKeyType.done
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func ShowLigands()
    {
        let fileURLProject = Bundle.main.path(forResource: "ligands", ofType: "txt")
        // Read from the file
        do {
            let str = try String(contentsOfFile: fileURLProject!, encoding: String.Encoding.utf8)
            list = str.components(separatedBy: "\n")
        } catch let error as NSError {
            print("Failed reading from URL: \(String(describing: fileURLProject)), Error: " + error.localizedDescription)
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if isSearching
        {
            return filteredData.count
        }
        return (list.count)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "ProteinCell")
        let text: String!
        
        if isSearching {
            text = filteredData[indexPath.row]
        }
        else {
            text = list[indexPath.row]
        }
        cell.textLabel?.text = text
        
        return (cell)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ligand: String
        if (isSearching)
        {
            ligand = filteredData[indexPath.row]
        }
        else{
            ligand = list[indexPath.row]
        }
        print("Ligand: \(ligand)")
        
        if let url = NSURL(string: "http://file.rcsb.org/ligands/download/" + ligand + "_model.pdb") {
            Downloader().load(URL: url, SPINNER: activitySpinner, CONTROLLER: self, LIGAND: ligand)
        }
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
//            view.endEditing(true)
            TableView.reloadData()
        }
        else {
            isSearching = true
            filteredData = list.filter({ $0.lowercased().range(of:searchBar.text!.lowercased()) != nil})
            TableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
            if segue.identifier == "goToLigandScreen" {
            
            let proteinViewController = segue.destination as! ProteinViewController
            if let proteinlistviewcontroller = sender as? Downloader
            {
                proteinViewController.titleLigand.title = proteinlistviewcontroller.lig
                proteinViewController.elem = proteinlistviewcontroller.elem
                proteinViewController.conect = proteinlistviewcontroller.conect
            }
        }
    }
}
