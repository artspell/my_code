//
//  TableViewController.swift
//
//
//

import UIKit
import RealmSwift

class TableViewController: UITableViewController{
    
    //init Realm DataBase
    let realm = try! Realm()
    //get object "User" from DataBase
    lazy var users: Results<User> = { self.realm.objects(User.self) }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        //return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return the number of rows
        return users.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell

        cell.username.text = users[indexPath.row].username
        cell.last_login.text = users[indexPath.row].last_login
        
        return cell
    }
    
}
