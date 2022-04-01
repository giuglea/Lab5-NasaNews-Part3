//
//  SearchArticleViewController.swift
//  NasaNews
//
//  Created by Tzy on 25.03.2022.
//

import UIKit

protocol SearchArticleViewType: AnyObject {
    func reloadTable()
    func reloadCollectionView()
}

final class SearchArticleView: UIViewController {
    
    var presenter: SearchArticlePresenter?
    
    @IBOutlet var searchTextField: UITextField?
    
    lazy var stackView = UIStackView
        .vetical(views: collectionView, tableView)
    private let tableView = UITableView()
    private let collectionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: UICollectionViewLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePresenter()
        
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.getAllModels()
    }
    
    private func configurePresenter() {
        presenter = SearchArticlePresenter()
        presenter?.view = self
    }
    
    private func configure() {
        searchTextField?.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: searchTextField!.bottomAnchor, constant: 10),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        
        configureTableView()
        configureCollectionView()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
        tableView.register(SearchArticleTableViewCell.self, forCellReuseIdentifier: SearchArticleTableViewCell.cellId)
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = CGSize(width: 100, height: 100)
        flowLayout.itemSize = CGSize(width: 100, height: 100)
        flowLayout.sectionInset = .zero
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .horizontal
        collectionView.setCollectionViewLayout(flowLayout, animated: false)
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.cellId)
    }
    
    @objc
    private func textFieldDidChange() {
        let searchString = searchTextField?.text ?? String()
        presenter?.getAllModels(searchString: searchString)
    }
    private func navigate(item: Item) {
        guard let viewController = storyboard?.instantiateViewController(withIdentifier: "ArticleViewController")
                as? ArticleViewController else { return }
        viewController.item = item
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
}

// MARK: TableView
extension SearchArticleView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchArticleTableViewCell.cellId, for: indexPath)
                as? SearchArticleTableViewCell else { return UITableViewCell() }
        guard let cellModel = presenter?.getModel(for: indexPath) else { return UITableViewCell() }
        cell.setup(ratingEntity: cellModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getModels().count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let model = presenter?.getModel(for: indexPath) else { return }
        let item = Item(title: model.name ?? String(),
                        date: "",
                        body: model.body ?? String(),
                        itemName: "")
        
        navigate(item: item)
    }
    
    
}

// MARK: CollectionView
extension SearchArticleView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.cellId, for: indexPath)
                as? SearchCollectionViewCell else { return UICollectionViewCell() }
        guard let item = presenter?.getModel(for: indexPath) else { return UICollectionViewCell() }
        cell.titleLabel.text = item.name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.getModels().count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.deleteItemAt(index: indexPath)
    }
    
}

extension SearchArticleView: SearchArticleViewType {
    func reloadTable() {
        tableView.reloadData()
    }
    
    func reloadCollectionView() {
        collectionView.reloadData()
    }
}


extension UIView {
    func rotate() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.y")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 5
        self.layer.add(rotation, forKey: "rotateAnimation")
        
    }
    
    func sizeTransform() {
        let animation = CABasicAnimation(keyPath: "transform.scale.x")
        animation.fromValue = 1
        animation.toValue = 2
        animation.duration = 0.5
        self.layer.add(animation, forKey: "sclaeAnimation")
    }
}


extension UIStackView {
    static func vetical(views: UIView...) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        for view in views {
            stackView.addArrangedSubview(view)
        }
        
        return stackView
    }
}
