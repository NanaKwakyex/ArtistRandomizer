//
//  ViewController.swift
//  ArtistRec
//
//  Created by user251966 on 3/31/24.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController {

    
    @IBOutlet weak var lblArtistName: UILabel!
    @IBOutlet weak var lblArtistQuote: UILabel!
    @IBOutlet weak var lblArtistGenre: UILabel!
    @IBOutlet weak var lblRecordLabel: UILabel!
    @IBOutlet weak var lblAlbum: UILabel!
    @IBOutlet weak var lblFrom: UILabel!
    
    @IBOutlet weak var imgArtist: UIImageView!
    @IBOutlet weak var imgAlbum: UIImageView!
    
    @IBOutlet weak var swEnjoy: UISwitch!
    
    var cannonSound: AVAudioPlayer!
    var targetSound: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "The Artist"        // Do any additional setup after loading the view.
        //populateArray()
        if let savedArtistSwitchStates = UserDefaults.standard.dictionary(forKey: "artistSwitchStates") as? [String: Bool] {
                    artistSwitchStates = savedArtistSwitchStates
                }
        let soundURL = URL(fileURLWithPath: Bundle.main.path(forResource: "cannon_fire", ofType: "wav")!)
        cannonSound = try? AVAudioPlayer(contentsOf: soundURL)
        let zoundURL = URL(fileURLWithPath: Bundle.main.path(forResource: "target_hit", ofType: "wav")!)
        targetSound = try? AVAudioPlayer(contentsOf: zoundURL)
        SetLables()
    }
    
    var ArtistArray = [Artist()]
    var segueArtist = Artist()
    var artistSwitchStates: [String: Bool] = [:]
    
    
    @IBAction func btnSite(_ sender: Any) {
        var randomArtist = segueArtist
        if let url = URL(string: randomArtist.ArtistSite) {
            UIApplication.shared.open(url)
            }
    }
    
    @IBAction func swEnjoyValChanged(_ sender: UISwitch) {
        targetSound.play()
        artistSwitchStates[segueArtist.ArtistName] = sender.isOn // Save switch state for the current artist
        UserDefaults.standard.set(artistSwitchStates, forKey: "artistSwitchStates")
    }
            
    func setSwitchState(for artistName: String, with switchControl: UISwitch) {
                if let switchState = artistSwitchStates[artistName] {
                    switchControl.isOn = switchState // Set switch state based on saved value
                } else {
                    switchControl.isOn = false // Default to off if switch state is not found
                }
    }
    
    
    
    
    
    var ra = Artist()
    
    // This function sets the lables with values from the Artists Object array
    func SetLables() {
        var randomArtist = segueArtist
        
        lblArtistName.text = randomArtist.ArtistName
        lblArtistQuote.text = randomArtist.quote
        lblArtistGenre.text = randomArtist.Genre
        lblRecordLabel.text = randomArtist.RecordLabel
        lblAlbum.text = randomArtist.RecentAlbum
        lblFrom.text = randomArtist.from
        
        
        // Load artist image asynchronously
        if let artistImageURL = URL(string: randomArtist.ArtistImage) {
            loadImage(from: artistImageURL) { [weak self] image in
                DispatchQueue.main.async {
                    self?.imgArtist.image = image
                }
            }
        }
        
        // Load album image asynchronously
        if let albumImageURL = URL(string: randomArtist.AlbumImage) {
            loadImage(from: albumImageURL) { [weak self] image in
                DispatchQueue.main.async {
                    self?.imgAlbum.image = image
                }
            }
        }
        
        setSwitchState(for: randomArtist.ArtistName, with: swEnjoy) // Set switch state for the current artist
        
        cannonSound.play()
    }

    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Error loading image from URL: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            let image = UIImage(data: data)
            completion(image)
        }.resume()
    }

        
    
    
    
    
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
            imgArtist.alpha = 0
            imgAlbum.alpha = 0
            lblArtistName.alpha = 0
            lblArtistQuote.alpha = 0
            lblAlbum.alpha = 0
        }
        override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
            
            UIView.animate(withDuration: 3, animations: {
                self.imgArtist.alpha = 1
                self.imgAlbum .alpha = 1
                self.lblArtistName.alpha = 1
                self.lblArtistQuote.alpha = 0.75
                self.lblAlbum.alpha = 1

            })
            
        }
    
    
    
    /*
    func populateArray() {
        let art0 = Artist()
        art0.ArtistName = "Kenny Mason"
        art0.Genre = "Punk Rap/ Rap Rock"
        art0.RecentAlbum = "9"
        art0.RecordLabel = "RCA Records"
        art0.from = "Atlanta, GA"
        art0.quote = "\"Now I am the light in the dark, it's lit\""
        art0.ArtistSite = "https://www.kennymason.dog"
        art0.ArtistImage = "KMason.jpeg"
        art0.AlbumImage = "KM_Album.jpeg"
        ArtistArray.insert(art0, at: 0)
        
        let art1 = Artist()
        art1.ArtistName = "Taylor Swift"
        art1.Genre = "Pop / Country"
        art1.RecentAlbum = "Midnights"
        art1.RecordLabel = "Big Machines Records"
        art1.from = "West Reading, PA"
        art1.quote = "\"Lord what will become of me, once I lost my novelty?\""
        art1.ArtistSite = "https://www.taylorswift.com"
        art1.ArtistImage = "TSwift.jpeg"
        art1.AlbumImage = "TS_Album.png"
        ArtistArray.append(art1)
        
        let art2 = Artist()
        art2.ArtistName = "Kali Uchis"
        art2.Genre = "Neo Soul/ Latin"
        art2.RecentAlbum = "Orquideas"
        art2.RecordLabel = "Virgin EMI Records"
        art2.from = "Alexandria, VA"
        art2.quote = "\"Everyone's replaceable, but not me, though\""
        art2.ArtistSite = "https://www.kaliuchis.com"
        art2.ArtistImage = "KUchis.jpeg"
        art2.AlbumImage = "KU_Album.jpeg"
        ArtistArray.append(art2)
        
        let art3 = Artist()
        art3.ArtistName = "J Hus"
        art3.Genre = "Afroswing"
        art3.RecentAlbum = "Beautiful and Brutal Yard"
        art3.RecordLabel = "Black Butter Records"
        art3.from = "Stratford, Eng"
        art3.quote = "How you gonna run the world? You can't even run your life"
        art3.ArtistSite = "https://www.jhusmusic.com"
        art3.ArtistImage = "Jhus.jpeg"
        art3.AlbumImage = "JH_album.jpeg"
        ArtistArray.append(art3)
        
        let art4 = Artist()
        art4.ArtistName = "SZA"
        art4.Genre = "R&B/ Pop"
        art4.RecentAlbum = "SOS"
        art4.RecordLabel = "TDE"
        art4.from = "St. Louis, MO"
        art4.quote = "\"Keep intentions pure, Don't be scared, Dont mince words\""
        art4.ArtistSite = "https://www.szasos.com"
        art4.ArtistImage = "Sza.jpeg"
        art4.AlbumImage = "SZA_Album.jpeg"
        ArtistArray.append(art4)
        
        let art5 = Artist()
        art5.ArtistName = "1975"
        art5.Genre = "Alternative rock/ Indie pop"
        art5.RecentAlbum = "Being Funny in a Foreign Language"
        art5.RecordLabel = "Wilmslow, Eng"
        art5.from = "Wilmslow, Eng"
        art5.quote = "\"Dont't fall in love with the moment\""
        art5.ArtistSite = "http://the1975.com"
        art5.ArtistImage = "1975.jpeg"
        art5.AlbumImage = "19_album.png"
        ArtistArray.append(art5)
        
    }
    */
}

