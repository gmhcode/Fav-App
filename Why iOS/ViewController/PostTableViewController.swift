//
//  PostTableViewController.swift
//  Why iOS
//
//  Created by Greg Hughes on 12/12/18.
//  Copyright © 2018 Greg Hughes. All rights reserved.
//

import UIKit

class PostTableViewController: UITableViewController {

    var posts : [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadTableView()
        
    }

    func reloadTableView(){
        PostController.fetchPosts { (posts) in
            
            
            DispatchQueue.main.async {
                self.posts = posts ?? []
                self.tableView.reloadData()
            }
        }
    }

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)

        let post = posts[indexPath.row]
        
        cell.detailTextLabel?.text = post.favApp
        
        cell.textLabel?.text = post.name

        return cell
    }
    
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    
    @IBAction func addbuttonTapped(_ sender: Any) {
        
        presentAddPostAlert()
        
    }
    
    
    func presentAddPostAlert(){
        let alertController = UIAlertController(title: "Add App", message: "What's your favorite app?", preferredStyle: .alert)
        
        
        alertController.addTextField { (nameTextField) in
            nameTextField.placeholder = "Add your name here"
        }
        alertController.addTextField { (favoriteAppTextField) in
            favoriteAppTextField.placeholder = "Enter your favorite app here"
        }
        
        
        let addButton = UIAlertAction(title: "Add", style: .default) { (_) in
            
            if let name = alertController.textFields?[0].text,
                let favApp = alertController.textFields?[1].text,
                !name.isEmpty,
                !favApp.isEmpty {
                
                PostController.addPost(name: name, favApp: favApp, completion: {
                    self.reloadTableView()
                })
            } else {
                self.presentErrorAlert()
                
            }
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(addButton)
        alertController.addAction(cancelButton)
        
        self.present(alertController, animated: true)
        
        
    }
        
    func presentErrorAlert(){
        let alertController = UIAlertController(title: "Error", message: "the text fields are missing data", preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.presentAddPostAlert()
        }
        alertController.addAction(cancelButton)
        present(alertController, animated: true)
        
    }
    
   
    
}
