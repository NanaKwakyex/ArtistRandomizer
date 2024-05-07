//
//  FavoritesViewController.swift
//  ArtistRec
//
//  Created by user251966 on 5/6/24.
//

import Foundation
import UIKit

class FavoritesViewController: UITableViewController {

    var favoriteArtists: [String] = []

    override func viewDidLoad() {
        self.title = "My Favorites"
        super.viewDidLoad()

        // Load favorite artists from UserDefaults
        loadFavoriteArtists()
    }

    func loadFavoriteArtists() {
        if let savedArtistSwitchStates = UserDefaults.standard.dictionary(forKey: "artistSwitchStates") as? [String: Bool] {
            // Filter out favorite artists
            favoriteArtists = savedArtistSwitchStates.filter { $0.value && !$0.key.isEmpty}.map { $0.key }
            
            tableView.reloadData()
        }
    }

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteArtists.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let artistName = favoriteArtists[indexPath.row]
        cell.textLabel?.text = artistName
        print(artistName)
        return cell
    }
}
