//
//  FeedController.swift
//  DoIt
//
//  Created by Данил Иванов on 16.11.2021.
//

import UIKit

class FeedController: UIViewController {

    private struct UIConstants {
        static let padding = 8.0
        static let collectionInset = 10.0
    }
    
    var collection: FeedCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = FeedCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: UIConstants.collectionInset,
                                                   left: UIConstants.collectionInset,
                                                   bottom: UIConstants.collectionInset,
                                                   right: UIConstants.collectionInset)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = collectionView.self
        collectionView.dataSource = collectionView.self
        collectionView.register(FeedCollectionCell.self, forCellWithReuseIdentifier: FeedCollectionCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        layoutCollection()
    }
    
    private func layoutCollection() {
        view.addSubview(collection)
        collection.backgroundColor = .lightGray
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collection.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collection.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        collection.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
