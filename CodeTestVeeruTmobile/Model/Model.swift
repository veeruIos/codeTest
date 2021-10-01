//
//  Model.swift
//  CodeTestVeeruTmobile
//
//  Created by Veerabrahmam Suthari (contractor) on 9/30/21.
//
import Foundation

struct UserRepo: Decodable {
    var name: String?
    var html_url: String?
    var forks: Int
    var stars: Int

    enum CodingKeys : String, CodingKey {
        case name = "name"
        case forks = "forks_count"
        case stars = "stargazers_count"
        case html_url = "html_url"
      }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserRepo.CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.html_url = try container.decodeIfPresent(String.self, forKey: .html_url)
        self.forks = try container.decodeIfPresent(Int.self, forKey: .forks) ?? 0
        self.stars = try container.decodeIfPresent(Int.self, forKey: .stars) ?? 0
    }
    
}

struct UserRepoList: Decodable {
    var total_count: Int
    var items: [UserRepo]?
    enum CodingKeys : String, CodingKey {
        case total_count = "total_count"
        case items = "items"
      }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserRepoList.CodingKeys.self)
        self.total_count = try container.decodeIfPresent(Int.self, forKey: .total_count) ?? 0
        self.items = try container.decodeIfPresent([UserRepo].self, forKey: .items)
    }
    
}

struct UserDetails: Decodable {
    var userID: Int
    var userLogin: String?
    var name: String
    var numberrepo: Int
    var poster_path: String?
    var repos_path: String?
    var email: String
    var location: String
    var jointDate: String
    var followers: Int
    var following: Int

    enum CodingKeys : String, CodingKey {
        case userID = "id"
        case name = "name"
        case numberrepo = "public_repos"
        case poster_path = "avatar_url"
        case repos_path = "repos_url"
        case email = "email"
        case location = "location"
        case jointDate = "created_at"
        case followers = "followers"
        case following = "following"
      }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserDetails.CodingKeys.self)
        self.numberrepo = try container.decodeIfPresent(Int.self, forKey: .numberrepo) ?? 0
        self.userID = try container.decodeIfPresent(Int.self, forKey: .userID) ?? 0
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.poster_path = try container.decodeIfPresent(String.self, forKey: .poster_path)
        self.repos_path = try container.decodeIfPresent(String.self, forKey: .repos_path)
        self.email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
        self.location = try container.decodeIfPresent(String.self, forKey: .location) ?? ""
        self.jointDate = try container.decodeIfPresent(String.self, forKey: .jointDate) ?? ""
        self.followers = try container.decodeIfPresent(Int.self, forKey: .followers) ?? 0
        self.following = try container.decodeIfPresent(Int.self, forKey: .following) ?? 0
    }
    
}
struct User: Decodable {
    var userDetails: UserDetails?
    var poster_path: String?
    var title: String?
    
    enum CodingKeys : String, CodingKey {
        case poster_path = "avatar_url"
        case title = "login"
      }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: User.CodingKeys.self)
        self.poster_path = try container.decode(String.self, forKey: .poster_path)
        self.title = try container.decode(String.self, forKey: .title)
    }
    
}

struct UserList: Decodable {
    let results: [User]?
    let total_pages: Int
    
    enum CodingKeys : String, CodingKey {
        case results = "items"
        case total_pages = "total_count"
      }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserList.CodingKeys.self)
    self.total_pages = try container.decode(Int.self, forKey: .total_pages)
    self.results = try container.decodeIfPresent([User].self, forKey: .results)
    }
}
