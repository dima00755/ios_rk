//
//  1ViewController.swift
//  RK1
//
//  Created by Dima Sokolov on 07/11/2018.
//  Copyright © 2018 Dima Sokolov. All rights reserved.
//

import UIKit
import SDWebImage

class SecViewController: UIViewController {
    
    var names = ["attack_on_titan","beck","clannad","code_geass","fma",
                 "gto","monster", "opm", "staingate","usagi"]
    
    var number : Int = 0
    
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var episods: UILabel!
    @IBOutlet weak var ep_length: UILabel!
    @IBOutlet weak var desc: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeImage()
        makeDesc()
        
    }
    
    func makeImage(){
        
        let imageUrl = "https://raw.githubusercontent.com/techparkios/ios-lectures-fall-2018/master/06/" + self.names[self.number] + ".jpg"
        
        let url = URL(string: imageUrl)!
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let data = try? Data(contentsOf: url) else {
                return
            }
            
            guard let image = UIImage(data: data) else {
                return
            }
            
            DispatchQueue.main.async {
                self?.image.image = image
            }
        }
    }
    
    func makeDesc(){
        
        let JsonURL = "https://raw.githubusercontent.com/techparkios/ios-lectures-fall-2018/master/06/" + self.names[self.number] + ".json"
        
        let gitUrl = URL(string: JsonURL)!
        
        URLSession.shared.dataTask(with: gitUrl) { (data, response, error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let gitData = try decoder.decode(Anime.self, from: data)
                
                DispatchQueue.main.async {
                    self.name.text = gitData.name
                    self.episods.text = gitData.episodes
                    self.ep_length.text = gitData.episode_length
                    self.desc.text = gitData.description
                }
                
            } catch let err {
                print("Err", err)
            }
            }.resume()
        
    }

}
