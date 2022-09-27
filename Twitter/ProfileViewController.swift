//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Orion Medina on 09/20/22.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet var profileTaglineLabel: UILabel!
    @IBOutlet weak var totalTweetsLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUserData()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadUserData()
    }
    
    
    func loadUserData() {
        let stringURL = "https://api.twitter.com/1.1/account/verify_credentials.json"
        let params = ["skip_status": true as Any]
        TwitterAPICaller.client?.getDictionaryRequest(url: stringURL, parameters: params, success:
            { (tweets: NSDictionary) in
                
                let imageURL = URL(string: (tweets["profile_image_url_https"] as? String)!)
                let data = try? Data(contentsOf:imageURL!)
                if let imageData = data {
                    self.profileImageView.image = UIImage(data: imageData)
                }
                self.profileNameLabel.text = tweets["name"] as? String
                self.profileTaglineLabel.text = tweets["description"] as? String
                
                self.totalTweetsLabel.text = "\(tweets["statuses_count"] ?? 0) total tweets (including retweets)"
                self.followingCountLabel.text = "currently following \(tweets["friends_count"] ?? 0) users"
                self.followersCountLabel.text = "and \(tweets["followers_count"] ?? 0) followers"
                
        }, failure: { (Error) in
            print("Could not retrieve tweets: \(Error)")
        })
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
