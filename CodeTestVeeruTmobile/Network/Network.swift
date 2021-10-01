//
//  Network.swift
//  CodeTestVeeruTmobile
//
//  Created by Veerabrahmam Suthari (contractor) on 9/30/21.
//

import Foundation
let networkCache = NSCache<AnyObject, AnyObject>()


class Network {
 
    enum NetworkError: Error {
        case badURL,
             requestFailed,
             unknown
    }
        
    func searchUser(searhword: String, completion: @escaping (Result<[User], NetworkError>) -> Void) {
        let searchString = searhword.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? searhword
        let urlString = "https://api.github.com/search/users?q=" + searchString + "+in%3Afullname&type=users&per_page=10"
        fetchData(urlString: urlString, completion: completion)
    }
    
    func searchUserDetails(searhword: String, completion: @escaping (Result<UserDetails, NetworkError>) -> Void) {
        let searchString = searhword.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? searhword
        let urlString = "https://api.github.com/users/" + searchString
        fetchuserData(urlString: urlString, completion: completion)
    }
    
    func searchUserRepoDetails(searhword: String, userID: String, completion: @escaping (Result<UserRepoList, NetworkError>) -> Void) {
            let searchString = searhword.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? searhword
            let urlString = "https://api.github.com/search/repositories?q=" + searchString + "%20user:" + userID
            fetchuserRepoData(urlString: urlString, completion: completion)
    }
    

    func fetchData(urlString: String, completion: @escaping (Result<[User], NetworkError>) -> Void ) {
        let APIURLString = urlString + ""
        guard let url = URL(string: APIURLString) else {
            completion(.failure(.badURL))
            return
        }
        if let userDetailsChache = networkCache.object(forKey: url as AnyObject) as? [User] {
            completion(.success(userDetailsChache))
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(.failure(.requestFailed))
                return
            }
            let decoder = JSONDecoder()
            guard let decodedDataUserList = try? decoder.decode(UserList.self, from: data) else {
                completion(.failure(.unknown))
                return
            }
            guard let results = decodedDataUserList.results else {
                            completion(.failure(.unknown))
                            return
                        }
            networkCache.setObject(results as AnyObject, forKey: url as AnyObject)
            completion(.success(results))
        }.resume()
    }
    
    
    func fetchuserData(urlString: String, completion: @escaping (Result<UserDetails, NetworkError>) -> Void ) {
        let APIURLString = urlString + ""
        guard let url = URL(string: APIURLString) else {
            completion(.failure(.badURL))
            return
        }
        if let userDetailsChache = networkCache.object(forKey: url as AnyObject) as? UserDetails {
            completion(.success(userDetailsChache))
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(.failure(.requestFailed))
                return
            }
            let decoder = JSONDecoder()
            guard let userDetail = try? decoder.decode(UserDetails.self, from: data) else {
                completion(.failure(.unknown))
                return
            }
            networkCache.setObject(userDetail as AnyObject, forKey: url as AnyObject)
            completion(.success(userDetail))
        }.resume()
    }
    
    func fetchuserRepoData(urlString: String, completion: @escaping (Result<UserRepoList, NetworkError>) -> Void ) {
            let APIURLString = urlString + ""
            guard let url = URL(string: APIURLString) else {
                completion(.failure(.badURL))
                return
            }
            if let userDetailsChache = networkCache.object(forKey: url as AnyObject) as? UserRepoList {
                completion(.success(userDetailsChache))
                return
            }
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else {
                    completion(.failure(.requestFailed))
                    return
                }
                let decoder = JSONDecoder()
                guard let decodedDataUserRepo = try? decoder.decode(UserRepoList.self, from: data) else {
                    completion(.failure(.unknown))
                    return
                }
                networkCache.setObject(decodedDataUserRepo as AnyObject, forKey: url as AnyObject)
                completion(.success(decodedDataUserRepo))
            }.resume()
        }
    
        
    
}
