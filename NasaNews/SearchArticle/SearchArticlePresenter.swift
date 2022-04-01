//
//  SearchArticlePresenter.swift
//  NasaNews
//
//  Created by Tzy on 01.04.2022.
//

import Foundation
import UIKit

//MVP - Model - View - Presenter

final class SearchArticlePresenter {
    
    weak var view: SearchArticleViewType?
    
    private var model: [RatingEntity] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.view?.reloadCollectionView()
                self?.view?.reloadTable()
            }
        }
    }
    
    
    func getAllModels(searchString: String = String()) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = RatingEntity.fetchRequest()
        if !searchString.isEmpty {
            fetchRequest.predicate = NSPredicate(format: "name CONTAINS %@", searchString)
        }
        
        do {
            model = try managedContext.fetch(fetchRequest)
        } catch {
            print("here::", error.localizedDescription)
        }
    }
    
    func deleteItemAt(index: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let deletItem = model[index.row]
        model.remove(at: index.row)
        managedContext.delete(deletItem)
        
        do {
            try managedContext.save()
            print("here::did delete item", deletItem)
        } catch {
            print("here::", error.localizedDescription)
        }
        
    }
    
    func getModels() -> [RatingEntity] {
        return model
    }
    
    func getModel(for index: IndexPath) -> RatingEntity {
        return model[index.row]
    }
}
