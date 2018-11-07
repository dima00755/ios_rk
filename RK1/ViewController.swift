//
//  ViewController.swift
//  RK1
//
//  Created by Dima Sokolov on 31/10/2018.
//  Copyright © 2018 Dima Sokolov. All rights reserved.
//

import UIKit
import SDWebImage

struct Anime: Codable {
    let name: String?
    let title: String?
    let episodes: String?
    let episode_length: String?
    let description: String?
}
class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    var names = ["attack_on_titan","beck","clannad","code_geass","fma",
                 "gto","monster", "opm","usagi"]
    
    fileprivate let session = URLSession(configuration: URLSessionConfiguration.default)
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
        
        let imageURLs = "https://raw.githubusercontent.com/techparkios/ios-lectures-fall-2018/master/06/" + self.names[indexPath.row] + ".jpg"
        
        let jsonURLs = "https://raw.githubusercontent.com/techparkios/ios-lectures-fall-2018/master/06/" + self.names[indexPath.row] + ".json"
        
        let url = URL(string: imageURLs)!

DispatchQueue.global(qos: .background).async { [weak self] in
            guard let data = try? Data(contentsOf: url) else {
                return
            }
            guard let image = UIImage(data: data) else {
                return
            }
            DispatchQueue.main.async {
                cell.imageCell.image = image
            }
        }
        
        let gitUrl = URL(string: jsonURLs)!
        
        URLSession.shared.dataTask(with: gitUrl) { (data, response, error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let gitData = try decoder.decode(Anime.self, from: data)
                
            DispatchQueue.main.async {
                cell.nameLabelCell.text = gitData.name
                cell.descLabelCell.text = "Episodes: " + gitData.episodes!
            }
                
            } catch let err {
                print("Err", err)
            }
            }.resume()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
        if segue.identifier == "Segue" {
            if let indexPath = sender as? IndexPath {
                let destinationVC = segue.destination as! SecViewController
                destinationVC.number = indexPath.row
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Segue" , sender: indexPath)
    }
    

}

