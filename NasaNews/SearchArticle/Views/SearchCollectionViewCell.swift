//
//  SearchCollectionViewCell.swift
//  NasaNews
//
//  Created by Tzy on 01.04.2022.
//

import UIKit

final class SearchCollectionViewCell: UICollectionViewCell {
    static let cellId = "SearchCollectionViewCell"
    
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    private func configure() {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        titleLabel.setConstraints(width: 100, height: 100)
    }
    
    override var reuseIdentifier: String? {
        return SearchCollectionViewCell.cellId
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
