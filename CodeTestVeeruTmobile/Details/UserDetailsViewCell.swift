//
//  UserDetailsViewCell.swift
//  CodeTestVeeruTmobile
//
//  Created by Veerabrahmam Suthari (contractor) on 9/30/21.
//

import UIKit

class UserDetailsViewCell: UITableViewCell {

    @IBOutlet var RepoName: UILabel!
    @IBOutlet var Forks: UILabel!
    @IBOutlet var Stars: UILabel!
    func setup(model: UserRepo) {
        RepoName.text = model.name
        Forks.text = String(model.forks) + " Forks"
        Stars.text = String(model.stars) + " Stars"
    }
    
    override func prepareForReuse() {
        RepoName.text = ""
        Forks.text = ""
        Stars.text = ""
    }
}
