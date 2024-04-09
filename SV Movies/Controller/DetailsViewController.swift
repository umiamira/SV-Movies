//
//  DetailsViewController.swift
//  SV Movies
//
//  Created by Umi Amira on 10/04/2024.
//

import UIKit
import Alamofire
import Kingfisher

class DetailsViewController: UIViewController {

    @IBOutlet weak var iv_background: UIImageView!
    @IBOutlet weak var iv_poster: UIImageView!
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_year_genre_lang_type: UILabel!
    @IBOutlet weak var lbl_imdb_rating: UILabel!
    
    @IBOutlet weak var lbl_plot: UILabel!
    @IBOutlet weak var lbl_director: UILabel!
    @IBOutlet weak var lbl_writer: UILabel!
    @IBOutlet weak var lbl_actors: UILabel!
    
    
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        refreshData()
    }
    
    func refreshData() {
        let url = Constants.omdbAPIURL + "?apikey=" + Constants.omdbAPIKey + "&i=" + self.movie!.imdbID

        AF.request(url).responseDecodable(of: MovieDetails.self) { response in
            switch response.result {
                
            case .success(let movieDetails):
                if let posterURL = URL(string: movieDetails.poster) {
                    let blur = UIBlurEffect(style: .dark)
                    let effect = UIVisualEffectView(effect: blur)
                    effect.frame = self.iv_background.bounds
                    self.iv_background.addSubview(effect)
                    
                    self.iv_background.kf.setImage(with: posterURL)
                    self.iv_poster.kf.setImage(with: posterURL)
                    self.lbl_title.text = movieDetails.title
                    self.lbl_year_genre_lang_type.text = "\(movieDetails.year) | \(movieDetails.genre) | \(movieDetails.language) | \(movieDetails.type)"
                    self.lbl_imdb_rating.text = movieDetails.imdbRating
                    
                    self.lbl_plot.text = movieDetails.plot
                    self.lbl_director.text = "Director: \(movieDetails.director)"
                    self.lbl_writer.text = "Writer: \(movieDetails.writer)"
                    self.lbl_actors.text = "Actors: \(movieDetails.actors)"
                }
                
                
            case .failure(let error):
                print("Error fetching movie details: \(error)")
            }
        }

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
