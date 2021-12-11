//
//  FeedController.swift
//  DoIt
//
//  Created by Данил Иванов on 16.11.2021.
//

import UIKit

class FeedController: UIViewController {

    private struct UIConstants {
        static let collectionInset = 10.0
        static let cellHeight = 190.0
    }
    
    private lazy var searchButton: UIBarButtonItem = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(.SearchFriendsIcons.searchIcon, for: .normal)
        button.addTarget(self, action: #selector(openSearch), for: .touchUpInside)
        button.tintColor = .AppColors.navigationTextColor
        return UIBarButtonItem(customView: button)
    }()
    
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.width * 0.5 - UIConstants.collectionInset * 1.5, height: UIConstants.cellHeight)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: UIConstants.collectionInset,
                                                   left: UIConstants.collectionInset,
                                                   bottom: UIConstants.collectionInset,
                                                   right: UIConstants.collectionInset)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: FeedCollectionViewCell.self.description())
        collectionView.backgroundColor = UIColor.AppColors.feedBackgroundColor
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    var userModel: UserModel?
    
    var following = [
        UserModel(image: nil, name: "wfqjoa fda", login: "fqFJqow", summary: "My summery is", statistics: UserStatisticsModel(inProgress: "0", outdated: "1", done: "1", total: "2"), isMyScreen: false, isFollowed: true),
        UserModel(image: nil, name: "gsgdsgger", login: "GIOWJEOG", summary: nil, statistics: UserStatisticsModel(inProgress: "0", outdated: "0", done: "0", total: "0"), isMyScreen: false, isFollowed: true),
        UserModel(image: nil, name: "greaiojgeo", login: "fwaojfoq", summary: nil, statistics: UserStatisticsModel(inProgress: "0", outdated: "0", done: "0", total: "0"), isMyScreen: true, isFollowed: true),
        UserModel(image: nil, name: "greaiojgeo", login: "gasgs", summary: nil, statistics: UserStatisticsModel(inProgress: "0", outdated: "0", done: "0", total: "0"), isMyScreen: false, isFollowed: true),
        UserModel(image: nil, name: "greaiojgeo", login: "gasg", summary: nil, statistics: UserStatisticsModel(inProgress: "0", outdated: "0", done: "0", total: "0"), isMyScreen: false, isFollowed: true),
        UserModel(image: nil, name: "greaiojgeo", login: "hdgh", summary: nil, statistics: UserStatisticsModel(inProgress: "0", outdated: "0", done: "0", total: "0"), isMyScreen: false, isFollowed: true),
        UserModel(image: nil, name: "greaiojgeo", login: "hgdhr", summary: nil, statistics: UserStatisticsModel(inProgress: "0", outdated: "0", done: "0", total: "0"), isMyScreen: false, isFollowed: true),
        UserModel(image: nil, name: "greaiojgeo", login: "gwaegfa", summary: nil, statistics: UserStatisticsModel(inProgress: "0", outdated: "0", done: "0", total: "0"), isMyScreen: false, isFollowed: true)
    ]
    
    var followingUsersTasks = [
        Task(image: UIImage(named: "bob"), title: "Поменять резину", description: nil, deadline: nil, isDone: true, creatorId: "GIOWJEOG", color: .black, chapterId: 0, creationTime: Date(), isMyTask: false),
        Task(image: UIImage(named: "duck"), title: "Купиить шапку", description: nil, deadline: nil, isDone: false, creatorId: "fqFJqow", color: .yellow, chapterId: 1, creationTime: Date(), isMyTask: false),
        Task(image: UIImage(named: "bob"), title: "Отдохнуть", description: "Math exam. jad;lfajslf;jasl;dfjlskfja;sldf", deadline: nil, isDone: false, creatorId: "fwaojfoq", color: .red, chapterId: 2, creationTime: Date(), isMyTask: false),
        Task(image: UIImage(named: "duck"), title: "Почистить зубы", description: "Math exam. jad;lfajslf;jasl;dfjlskfja;sldf", deadline: nil, isDone: true, creatorId: "fwaojfoq", color: .orange, chapterId: 3, creationTime: Date(), isMyTask: false),
        Task(image: UIImage(named: "duck"), title: "Занятие по танцам", description: nil, deadline: nil, isDone: false, creatorId: "fwaojfoq", color: .black, chapterId: 4, creationTime: Date(), isMyTask: false),
        Task(image: UIImage(named: "bob"), title: "Отдохнуть", description: "Math exam. jad;lfajslf;jasl;dfjlskfja;sldf", deadline: nil, isDone: false, creatorId: "GIOWJEOG", color: .red, chapterId: 5, creationTime: Date(), isMyTask: false),
        Task(image: UIImage(named: "duck"), title: "Почистить зубы", description: "Math exam. jad;lfajslf;jasl;dfjlskfja;sldf", deadline: nil, isDone: true, creatorId: "GIOWJEOG", color: .orange, chapterId: 6, creationTime: Date(), isMyTask: false),
        Task(image: UIImage(named: "duck"), title: "Оплатить счета", description: nil, deadline: nil, isDone: false, creatorId: "GIOWJEOG", color: .orange, chapterId: 7, creationTime: Date(), isMyTask: false),
        Task(image: UIImage(named: "bob"), title: "Отдохнуть", description: "Math exam. jad;lfajslf;jasl;dfjlskfja;sldf", deadline: nil, isDone: false, creatorId: "GIOWJEOG", color: .red, chapterId: 8, creationTime: Date(), isMyTask: false)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        layoutCollection()
        configureNavigationController()
    }
    
    private func configureNavigationController() {
        navigationItem.title = FeedStrings.header.rawValue.localized
        guard let userModel = userModel else { return }
        navigationItem.rightBarButtonItem = userModel.isMyScreen ? searchButton : nil
    }
    
    private func layoutCollection() {
        view.addSubview(collection)
        collection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collection.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collection.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        collection.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension FeedController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return followingUsersTasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCollectionViewCell.self.description(), for: indexPath) as? FeedCollectionViewCell else { return .init(frame: .zero) }
        guard let userInfo = following.first(where: { $0.login == followingUsersTasks[indexPath.row].creatorId }) else { return .init(frame: .zero) }
        cell.tapOnUser = { [weak self] in
            let profileViewController = ProfileViewController()
            profileViewController.userModel = userInfo
            profileViewController.userTasksModel = UserTasksModel(login: userInfo.login, tasks: self?.followingUsersTasks.filter({ $0.creatorId == userInfo.login }) ?? [])
//            let start = Int.random(in: 0...(self?.following.count ?? 0))
//            profileViewController.userFollowingModel = UserFollowingModel(login: userInfo.login, followings: Array(self?.following[start..<Int.random(in: start...(self?.following.count ?? 0))] ?? []))
            self?.navigationController?.pushViewController(profileViewController, animated: true)
        }
        cell.configureCell(taskInfo: followingUsersTasks[indexPath.row], userInfo: userInfo)
        return cell
    }
}

// MARK: - Actions

extension FeedController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let taskViewController = TaskViewController()
        taskViewController.taskModel = followingUsersTasks[indexPath.row]
        taskViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(taskViewController, animated: true)
    }
}

extension FeedController {
    @objc
    private func openSearch() {
        let searchUsersController = SearchUsersController()
        searchUsersController.userModel = userModel
        navigationController?.pushViewController(searchUsersController, animated: true)
    }
}
