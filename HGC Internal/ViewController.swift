//
//  ViewController.swift
//  Pokedex
//
//  Created by user161027 on 11/16/19.
//  Copyright © 2019 CS50. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet var searchBar: UISearchBar?
    
    var searchList: [work] = []
    var works: [work] = []
    var searching = false
    static var keys: String = ""
    var transition: Bool = false
    static var cookie: [HTTPCookie]?
    
    func capitalize(text: String) -> String {
        return text.prefix(1).uppercased() + text.dropFirst()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if searchBar?.delegate == nil && transition == true {
            return
        }
        
        searchBar?.delegate = self
        
        print("hi1")
        
        let url = URL(string: "https://wrapapi.com/use/sastryj24/cs50/hgclogin/latest?username=jsastry&password=Veritas18%21&wrapAPIKey=QoUv0L22KUQYHSKo7LfSOHsVQcmglUJW")
        guard let u = url else {
            print("drat")
            return
        }
        print("hi1.1")
        URLSession.shared.dataTask(with: u) { (data, response, error) in
//            guard let data = data else {
//                return
//            }
            print("hi1.2")
            do {
                ViewController.self.cookie = HTTPCookieStorage.shared.cookies!
                let key = try JSONDecoder().decode(loginKey.self, from: data!)
                ViewController.self.keys = key.stateToken
                print(ViewController.self.keys)
                self.tableData(token: ViewController.self.keys)

            }
            catch let error {
                print("\(error)")
            }
        }.resume()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
        
    func tableData(token: String) {
        print("hi2")
    
        let url2 = URL(string: "https://wrapapi.com/use/sastryj24/cs50/hgcinternal2/latest?stateToken=\(token)&wrapAPIKey=QoUv0L22KUQYHSKo7LfSOHsVQcmglUJW")
//               guard let u = url else {
//                   return
//               }
               URLSession.shared.dataTask(with: url2!) { (data, response, error) in
                   guard let data = data else {
                       return
                   }
                   do {
                        let datum = try JSONDecoder().decode(outside.self, from: data)
                        let worksList = datum.data
                        print(worksList)
                        self.works = worksList.piece
                        print(self.works.count)
                        self.works = self.works.filter {($0.title != nil)}
       
                        print(self.works.count)
                        self.searchList = self.works
                       
                       DispatchQueue.main.async {
                           self.tableView.reloadData()
                       }
                                      
                   }
                   catch let error {
                       print("\(error)")
                   }
               }.resume()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
       return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Piece", for: indexPath)
        var newTitle = capitalize(text: searchList[indexPath.row].title)
        var numb = String(newTitle.suffix(4))
        var numb2: String = ""
        
        for char in numb {
            if char != "(" || char != ")" || char != " " {
                numb2 += String(char)
            }
        }
        searchList[indexPath.row].performances = Int(numb2)
        newTitle.removeLast(4)
        cell.textLabel?.text = newTitle
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        transition = true
        if segue.identifier == "PerformSegue" {
            if let destination = segue.destination as? PerformancesViewController {
                destination.piece = searchList[tableView.indexPathForSelectedRow!.row]
                }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) { //search bar funtion
        
        if searchText.count != 0 { // if the search is not blank
        self.searchList = works.filter {($0.title.lowercased().contains(searchText.lowercased()))} // then check to see if any part of the lowercased name of a pokemon matches with the search text
            }
        else {
            searchList = works // return the full pokemon list if nothing has been searched
        }

        searching = true
        tableView.reloadData()
       
    }
}

