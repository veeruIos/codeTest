//
//  ViewController.swift
//  CodeTestVeeruTmobile
//
//  Created by Veerabrahmam Suthari (contractor) on 9/30/21.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class ViewController:  UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var UserIDList: [User]?
    var userDetailsLists: [UserDetails]?
    var selectedIndex: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
      if segue.identifier == "CellSelect",
         let movieDetailViewController = segue.destination as? UserDetailsViewController, let movieSearchViewCellSender = sender as? UserSearchViewCell {
        let UserIDList = self.userDetailsLists?[movieSearchViewCellSender.tag]
        movieDetailViewController.userDetails = UserIDList
      }
    }
}

extension ViewController: UISearchBarDelegate {

    func searchUser(query: String) {
        Network().searchUser(searhword: query, completion: { (searchResult:Result<[User],Network.NetworkError>) in
                            switch searchResult {
                            case .success(let searchResult):
                                self.UserIDList = searchResult
                                var solve: Int = 0
                                self.userDetailsLists = []
                                for User in searchResult {
                                    Network().searchUserDetails(searhword: User.title ?? "", completion: {
                                                    (searchResult: Result<UserDetails, Network.NetworkError>) in
                                        solve = solve + 1
                                        switch searchResult {
                                        case .success(let searchResult):
                                            var userDetailsList = searchResult
                                            userDetailsList.userLogin = User.title
                                            self.userDetailsLists?.append(userDetailsList)
                                        case .failure(let error):
                                            print(error, error.localizedDescription)
                                        }
                                        if solve == self.UserIDList?.count {
                                            DispatchQueue.main.async {
                                                self.tableView.reloadData()
                                            }
                                        }
                                    })
                                }
                            case .failure(let error):
                                print(error, error.localizedDescription)
                            }
                        })
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.UserIDList = nil
            self.userDetailsLists = nil
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } else {
            searchUser(query: searchText)
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userDetailsLists?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserSearchViewCell", for:indexPath) as! UserSearchViewCell
        if let userDetails = self.userDetailsLists, indexPath.row <= userDetails.count {
            let model = userDetails[indexPath.row]
            cell.setup(model: model)
        }
        cell.tag = indexPath.row
        return cell
    }
}

