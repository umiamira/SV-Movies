//
//  ViewController.swift
//  SV Movies
//
//  Created by Umi Amira on 10/04/2024.
//

import UIKit
import Alamofire
import Kingfisher

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var movies: [Movie] = []
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.minimumLineSpacing = 0
        }

        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        refreshData()
        
    }
    
    @objc func refresh() {
        refreshData()
    }

    func refreshData() {
        let url = Constants.omdbAPIURL + "?apikey=" + Constants.omdbAPIKey + "&s=avengers"

        AF.request(url).responseDecodable(of: MovieSearchResponse.self) { response in
            self.refreshControl.endRefreshing()
            
            switch response.result {
            case .success(let searchResponse):
                // Handle the JSON response
                self.movies = searchResponse.search
                self.collectionView.reloadData()
                
            case .failure(let error):
                // Handle the error
                print("Error: \(error)")
            }
        }
    }

    
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        
        guard let posterURL = URL(string: movies[indexPath.row].poster) else {
            return cell
        }
        
        cell.iv_poster.layer.cornerRadius = 10
        cell.iv_poster.clipsToBounds = true
        cell.iv_poster.kf.setImage(with: posterURL)
        cell.lbl_title.text = movies[indexPath.row].title
        
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.frame.width
        
        let numberOfColumns: CGFloat = 2
        let itemWidth = collectionViewWidth / numberOfColumns
        
        let itemHeight: CGFloat = 250
        return CGSize(width: itemWidth, height: itemHeight)
    }

}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedMovie = movies[indexPath.item]
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController else {
            return
        }
        
        vc.movie = selectedMovie

        present(vc, animated: true)
    }
}

