//
//  PerformancesViewController.swift
//  HGC Internal
//
//  Created by user161027 on 11/28/19.
//  Copyright © 2019 Jay Sastry. All rights reserved.
//

import UIKit

class PerformancesViewController: UITableViewController {
    var piece: work!
    var sworks: [subwork] = []
    var finalWorks: [subwork] = []
    
     override func viewDidLoad() {
            super.viewDidLoad()
            
            print("hi2")
            print(piece)
        let url = URL(string: "https://wrapapi.com/use/sastryj24/cs50/hgcperforms/0.0.2?titleurl=\(piece.url.dropFirst(4))&stateToken=\(ViewController.keys)&wrapAPIKey=QoUv0L22KUQYHSKo7LfSOHsVQcmglUJW")
            print(url)
            guard let u = url else {
                print("drat")
                return
            }
            print("hi2.1")
            URLSession.shared.dataTask(with: u) { (data, response, error) in
    //            guard let data = data else {
    //                return
    //            }
                print("hi2.2")
                do {
                    let datum = try JSONDecoder().decode(outsidePerforms.self, from: data!)
                    let temp = datum.data
                    var tempWorks = temp.collection
                    tempWorks = tempWorks!.filter {($0.suburl != nil)}
                    tempWorks = tempWorks!.filter {($0.stitle != nil)}
                    print(tempWorks!.count)
                    
                    for song in tempWorks! {
                        let url = URL(string: "https://wrapapi.com/use/sastryj24/cs50/hgcmetadata/0.0.7?titleurl=abc&node=\(String(song.suburl.dropFirst(4)))&stateToken=\(ViewController.keys)&wrapAPIKey=QoUv0L22KUQYHSKo7LfSOHsVQcmglUJW")
                         guard let u = url else {
                             return
                         }
                         URLSession.shared.dataTask(with: u) { (data, response, error) in
                         //            guard let data = data else {
                         //                return
                         //            }
                         
                             do {
                                 let datums = try JSONDecoder().decode(outsidePerforms.self, from: data!)
                                 let temp = datums.data
                                 let tempMdata = temp.collection
//                                 print(temp)
//                                 print(tempMdata)
                             
                                if self.sworks.count == 0 {
                                    self.sworks = tempMdata!
                                 }
                                 
                                 else {
                                    self.sworks += tempMdata!
                                 }
                                if let row = self.sworks.firstIndex(where: {$0.year == nil}) {
                                    self.sworks[row].year = "0001"
                                }
//                                print(self.sworks.count)
//                                print(self.finalWorks.count)
                                
                             }
                             catch let error {
                                 print("\(error)")
                             }
                            
                            self.sworks = self.sworks.sorted {$0.year > $1.year}
                            self.finalWorks = self.sworks
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                            
                         }.resume()
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
        return finalWorks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "performance", for: indexPath)
        cell.textLabel?.text = finalWorks[indexPath.row].album
        var artist = String(finalWorks[indexPath.row].artist)
        var year = String(finalWorks[indexPath.row].year.prefix(4))

        cell.detailTextLabel?.text = "\(year) | \(artist)"

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlayerSegue" {
            if let destination = segue.destination as? PlayerViewController {
                destination.song = finalWorks[tableView.indexPathForSelectedRow!.row]
                }
        }
    }
    
}
