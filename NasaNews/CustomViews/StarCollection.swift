//
//  StarCollection.swift
//  NasaNews
//
//  Created by Tzy on 01.04.2022.
//

import UIKit

protocol StarCollectionDelegate: AnyObject {
    func didRate(rate: Int)
}

final class StarCollection: UIView {
    private var stackView = UIStackView()
    
    var starButton1 = UIButton()
    private var starButton2 = UIButton()
    private var starButton3 = UIButton()
    private var starButton4 = UIButton()
    private var starButton5 = UIButton()
    
    weak var delegate: StarCollectionDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    @objc
    private func didTapStar(sender: UIButton) {
        var number = 0
        for view in stackView.arrangedSubviews {
            
            if number <= sender.tag,
               let button = view as? UIButton {
                let image = UIImage(systemName: "star.fill")?.withTintColor(.yellow)
                button.setImage(image: image)
            }
            
            if number > sender.tag,
               let button = view as? UIButton {
                let image = UIImage(systemName: "star")?.withTintColor(.yellow)
                button.setImage(image: image)
            }
            number += 1
        }
        delegate?.didRate(rate: sender.tag)
    }
    
    private func configure() {
        stackView.axis = .horizontal
        stackView.addArrangedSubview(starButton1)
        stackView.addArrangedSubview(starButton2)
        stackView.addArrangedSubview(starButton3)
        stackView.addArrangedSubview(starButton4)
        stackView.addArrangedSubview(starButton5)
        
        
        for (number, view) in stackView.arrangedSubviews.enumerated() {
            view.setConstraints(width: 30, height: 30)
                .setTag(tag: number)
                .setTintColor(color: .red)
            if let button = view as? UIButton {
                let image = UIImage(systemName: "star")
                button.setImage(image: image)
                button.addTarget(self, action: #selector(didTapStar), for: .touchUpInside)
            }
        }
        
        stackView.spacing = 5
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leftAnchor.constraint(equalTo: self.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: self.rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    
}


extension UIView {
    @discardableResult
    func setTag(tag: Int) -> Self {
        self.tag = tag
        return self
    }
    
    @discardableResult
    func setConstraints(width: CGFloat, height: CGFloat) -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        let width = self.widthAnchor.constraint(equalToConstant: 30)
        let height =  self.heightAnchor.constraint(equalToConstant: 30)
        
        width.priority = .required
        height.priority = .required
        
        NSLayoutConstraint.activate([
           width,
           height
        ])

        return self
    }
    
    @discardableResult
    func setBackgroundColor(color: UIColor) -> Self {
        self.backgroundColor = color
        return self
    }
    
    @discardableResult
    func setTintColor(color: UIColor) -> Self {
        self.tintColor = color
        return self
    }
}

extension UIButton {
    @discardableResult
    func setImage(image: UIImage?) -> Self {
        self.setBackgroundImage(image, for: .normal)
        return self
    }
}
