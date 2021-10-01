//
//  UserSearchViewCell.swift
//  CodeTestVeeruTmobile
//
//  Created by Veerabrahmam Suthari (contractor) on 9/30/21.
//

import UIKit

class UserSearchViewCell: UITableViewCell {

    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet weak var repoCountLabel: UILabel!
    func setup(model: UserDetails) {
        userNameLabel.text = model.name
        repoCountLabel.text = "Repo: " + String(model.numberrepo)
        if let poster_path = model.poster_path {
            let UrlString = poster_path
            let url = URL(string: UrlString)!
            profilePicImageView.load(url: url)
        }
    }
    
    override func prepareForReuse() {
        userNameLabel.text = ""
        repoCountLabel.text = ""
        profilePicImageView.image = nil
    }
}

extension UIImageView {
    func load(url: URL) {
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
        self.image = imageFromCache
        return
        }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let imageToCache = UIImage(data: data) {
                    DispatchQueue.main.async {
                        imageCache.setObject(imageToCache, forKey: url as AnyObject)
                        self?.image = imageToCache
                    }
                }
            }
        }
    }
}

