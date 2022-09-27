//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Orion Medina on 09/20/22.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var tweetArray = [NSDictionary]()
    var numberOfTweets: Int!
    
    let tableViewRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadTweets()
        tableViewRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = tableViewRefreshControl
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadTweets()
    }
    
    
    @objc func loadTweets() {
        
        numberOfTweets = 20
        
        let stringURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let params = ["count": numberOfTweets as Any]
        TwitterAPICaller.client?.getDictionariesRequest(url: stringURL, parameters: params, success:
            { (tweets: [NSDictionary]) in
            
                self.tweetArray.removeAll()
                for tweet in tweets {
                    self.tweetArray.append(tweet)
                }
                self.tableView.reloadData()
                self.tableViewRefreshControl.endRefreshing()
                
        }, failure: { (Error) in
            print("Could not retrieve tweets: \(Error)")
        })
    }
    
    
    func loadMoreTweets() {
        
        numberOfTweets += 20
        
        let stringURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let params = ["count": numberOfTweets as Any]
        TwitterAPICaller.client?.getDictionariesRequest(url: stringURL, parameters: params, success:
            { (tweets: [NSDictionary]) in
            
                self.tweetArray.removeAll()
                for tweet in tweets {
                    self.tweetArray.append(tweet)
                }
                self.tableView.reloadData()
                
        }, failure: { (Error) in
            print("Could not retrieve tweets: \(Error)")
        })
    }
    
    
    
    @IBAction func logoutBarButtonTapped(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetArray.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        cell.userNameLabel.text = user["name"] as? String
        cell.tweetContentLabel.text = tweetArray[indexPath.row]["text"] as? String
        
        let imageURL = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf:imageURL!)
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        cell.setFavorite(tweetArray[indexPath.row]["favorited"] as! Bool)
        cell.tweetID = tweetArray[indexPath.row]["id"] as! Int
        cell.setRetweet(tweetArray[indexPath.row]["retweeted"] as! Bool)

        return cell
    }
    
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArray.count {
            loadMoreTweets()
        }
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
