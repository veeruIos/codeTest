//
//  UserDetailsViewController.swift
//  CodeTestVeeruTmobile
//
//  Created by Veerabrahmam Suthari (contractor) on 9/30/21.
//

import UIKit

class UserDetailsViewController: UIViewController {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var userRepoList: [UserRepo]?

    var userDetails: UserDetails?
    
    @IBAction func onBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        searchMovie(query: "")
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let userInfo = userDetails {
            self.title = userInfo.name
            let UserBio: String = userInfo.name + strNewLine(str: userInfo.email) + strNewLine(str: userInfo.location)
            let User1Bio: String = stringCovertJointDate(dateString: userInfo.jointDate) + "\n" + String(userInfo.followers)
            let User2Bio: String = " followers \n following " + String(userInfo.following)

            releaseDateLabel.text = UserBio + User1Bio + User2Bio
            if let poster_path = userInfo.poster_path {
            let url = URL(string: poster_path)!
            movieImageView.load(url: url)
            }
        }
    }
    
    func strNewLine(str: String) -> String {
        if str.isEmpty {
            return ""
        } else {
            return "\n" + str
        }
    }
    
    func stringCovertJointDate(dateString: String) -> String {
        let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "MMMM dd, yyyy"

                if let date: Date = dateFormatterGet.date(from: dateString) {
                return "\n" + dateFormatterPrint.string(from: date)
                }
        return ""
    }
}

extension UserDetailsViewController: UISearchBarDelegate {

    func searchMovie(query: String) {
        guard let userLogin = self.userDetails?.userLogin else {
            return
        }
        Network().searchUserRepoDetails(searhword: query, userID: userLogin, completion: { (searchResult:Result<UserRepoList,Network.NetworkError>) in
                            switch searchResult {
                            case .success(let searchResult):
                                self.userRepoList = searchResult.items
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                }
                            case .failure(let error):
                                print(error, error.localizedDescription)
                            }
                        })
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            searchMovie(query: searchText)
    }
}

extension UserDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userRepoList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserDetailsViewCell", for:indexPath) as! UserDetailsViewCell
        if let ostfdfd = self.userRepoList, indexPath.row <= ostfdfd.count {
            let model = ostfdfd[indexPath.row]
            cell.setup(model: model)
        }
        cell.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let userRepoList = self.userRepoList, let urlString = userRepoList[indexPath.row].html_url {
            guard let url = URL(string: urlString) else {
                return
            }
            UIApplication.shared.open(url)
        }
    }
}
