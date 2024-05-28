//
//  ArtistViewController.swift
//  ArtistRec
//
//  Created by user251966 on 5/5/24.
//

import Foundation
import UIKit

class ArtistViewController : UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //populateArray()
        self.title = "Artist List"
        getJSONData()
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var index = tableView.indexPathForSelectedRow
        var artistRow = ArtistObjectArray[index!.row]
        
        var destinationController = segue.destination as! ViewController
        destinationController.segueArtist = artistRow
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ArtistObjectArray.count
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)



        let artist = ArtistObjectArray[indexPath.row]

        cell.textLabel?.text = artist.ArtistName
        cell.detailTextLabel?.text = "Genre: \(artist.Genre)"

        // Call PullImage function with the specific image URL for the artist
        if let artistImageURL = URL(string: artist.ArtistImage) {
            cell.imageView?.image = PullImage(imageURL: artistImageURL)
        } else {
            cell.imageView?.image = UIImage(named: "https://raw.githubusercontent.com/NanaKwakyex/HarmoniQuest/main/Artists/default.png") // Placeholder image if URL is invalid
        }
        
        cell.imageView?.contentMode = .scaleAspectFill // Adjust content mode as needed
        cell.imageView?.frame.size.width = 200
        cell.imageView?.frame.size.height = 150
        cell.imageView?.layer.borderWidth = 2
        cell.imageView?.layer.borderColor = UIColor.black.cgColor
        
        return cell
    }

    func PullImage(imageURL: URL) -> UIImage? {
        var img: UIImage?

        do {
            let imgData = try Data(contentsOf: imageURL)
            img = UIImage(data: imgData) ?? UIImage(named: "https://raw.githubusercontent.com/NanaKwakyex/HarmoniQuest/main/Artists/default.png") // Placeholder image if data is not a valid image
        } catch {
            print("Error loading image: \(error)")
            img = UIImage(named: "https://raw.githubusercontent.com/NanaKwakyex/HarmoniQuest/main/Artists/default.png") ?? UIImage() // Placeholder image if error occurs
        }

        return img
    }
    
    
    var ArtistObjectArray = [Artist]()
    
    
    //1. Convert the String to URL. The string is the https address to the API. also called as REST endpoint.
        //2. Call the Data function on the URL
        //3. collect the returned Data (JavaScriptObjectNotation type)
        //4. Serialize The JSON data into SWIFT objects (first A Dictionary) the into an Array.
        //4.1 Split the Dictionary into two parts. keep the Hiking Trails complex object and throw away the Status = OK part.
        //5. once the JSON data is serialized into Swift Objects one can iterate on each object within the dictionary and build the HikingTrail Object and add it to the Array.
     
    func getJSONData() {
        let endPointURL = URL(string: "https://raw.githubusercontent.com/NanaKwakyex/HarmoniQuest/main/Artist.json")

        let dataBytes = try? Data(contentsOf: endPointURL!)


        if let dataBytes = dataBytes {
            do {
                let dictionary = try JSONSerialization.jsonObject(with: dataBytes, options: []) as! [String: Any]
                print("Dictionary --:  \(dictionary) ---- \n")

                if let arDictionary = dictionary["Artists"] as? [[String: Any]] {
                    for singleAR in arDictionary {
                        let ar = Artist()

                        ar.ArtistName = singleAR["ArtistName"] as! String

                        ar.ArtistSite = singleAR["ArtistSite"] as! String
                        ar.Genre = singleAR["Genre"] as! String
                        ar.RecentAlbum = singleAR["RecentAlbum"] as! String
                        ar.from = singleAR["From"] as! String
                        ar.RecordLabel = singleAR["RecordLabel"] as! String
                        ar.quote = "\"\(singleAR["quote"] as! String)\""
                        ar.ArtistImage = singleAR["ArtistImage"] as! String
                        ar.AlbumImage = singleAR["AlbumImage"] as! String

                        ArtistObjectArray.append(ar)
                    }
                }

                // Reload table view data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }
    } // end of function getJSONData()
    
}
