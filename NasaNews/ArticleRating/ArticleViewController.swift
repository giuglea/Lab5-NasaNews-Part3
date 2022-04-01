//
//  ArticleViewController.swift
//  NasaNews
//
//  Created by Tzy on 18.03.2022.
//

import UIKit
import WebKit
import CoreData

final class ArticleViewController: UIViewController {
    
    var item: Item?
    
    
    var rating: Int = 0
    
    @IBOutlet var webView: WKWebView?

    @IBOutlet weak var starCollection: StarCollection!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        guard let item = item else {
            return
        }

        title = item.title
        webView?.loadHTMLString(item.body, baseURL: nil)
        starCollection.delegate = self
    }
    
    private func addRating() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "RatingEntity", in: managedContext),
        let item = item else { return }
        let ratingEntity = RatingEntity(entity: entity, insertInto: managedContext)
        ratingEntity.rating = Int64(rating)
        ratingEntity.name = item.title
        ratingEntity.body = item.body
        
        do {
            try managedContext.save()
            print("here:: Saved!")
        } catch {
            print("here::", error.localizedDescription)
        }
    }
    
}

extension ArticleViewController: StarCollectionDelegate {
    func didRate(rate: Int) {
        rating = rate
        addRating()
    }
    
    
}


