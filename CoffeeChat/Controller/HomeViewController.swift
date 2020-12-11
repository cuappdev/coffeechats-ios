//
//  HomeViewController.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 10/1/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//
import FutureNova
import Kingfisher
import SideMenu
import UIKit

class HomeViewController: UIViewController {

    // MARK: - Private View Vars
    private let profileButton = UIButton(type: .custom)
    /// Pill display used to swap between matching and community view controllers
    private var tabCollectionView: UICollectionView!
    /// View that holds `tabPageViewController` below the pill view
    private var tabContainerView: UIView!
    /// View Controller whose contents are shown below
    private var tabPageViewController: TabPageViewController?
    private let profileButtonSize = CGSize(width: 35, height: 35)

    // MARK: - Private Data Vars
    private var activeTabIndex = 0
    private let tabs = ["Weekly Pear", "People"]
    private var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .backgroundLightGreen

        profileButton.backgroundColor = .inactiveGreen
        profileButton.layer.cornerRadius = profileButtonSize.width/2
        profileButton.layer.shadowColor = UIColor.black.cgColor
        profileButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        profileButton.layer.shadowOpacity = 0.15
        profileButton.layer.shadowRadius = 2
        profileButton.layer.masksToBounds = true
        profileButton.clipsToBounds = true
        profileButton.addTarget(self, action: #selector(profilePressed), for: .touchUpInside)
        view.addSubview(profileButton)

        tabContainerView = UIView()
        view.addSubview(tabContainerView)

        let tabLayout = UICollectionViewFlowLayout()
        tabLayout.minimumInteritemSpacing = 0

        tabCollectionView = UICollectionView(frame: .zero, collectionViewLayout: tabLayout)
        tabCollectionView.delegate = self
        tabCollectionView.dataSource = self
        tabCollectionView.register(HomeTabOptionCollectionViewCell.self,
                                   forCellWithReuseIdentifier: HomeTabOptionCollectionViewCell.reuseIdentifier)
        tabCollectionView.backgroundColor = .white
        tabCollectionView.clipsToBounds = true
        tabCollectionView.layer.masksToBounds = false
        tabCollectionView.layer.cornerRadius = 20
        tabCollectionView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        tabCollectionView.layer.shadowOffset = CGSize(width: 0, height: 2)
        tabCollectionView.layer.shadowOpacity = 1
        tabCollectionView.layer.shadowRadius = 4
        view.addSubview(tabCollectionView)

        setUpConstraints()
        setUserAndTabPage()
    }

    private func setUserAndTabPage() {
        guard let netId = UserDefaults.standard.string(forKey: Constants.UserDefaults.userNetId) else { return }

        NetworkManager.shared.getUser(netId: netId).observe { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .value(let response):
                guard response.success else {
                    print("Unsuccesful response when getting user")
                    return
                }

                self.user = response.data

                //let firstActiveMatch = response.data.matches.filter({ $0.status == "inactive" }).first
                let firstActiveMatch = Match(
                    matchID: "abc123",
                    status: "cancelled",
                    meetingTime: 10,
                    users: ["pno3", "llx2"],
                    availabilities: TimeAvailability(availabilities: [SubTimeAvailability(day: "Friday", times: [10])])
                )
                DispatchQueue.main.async {
                    self.setupTabPageViewController(with: firstActiveMatch)
                    print("done setting this ")
                }
            case .error(let error):
                print("Encountered error in HomeViewController when getting User: \(error)")
            }
        }
    }

    private func setupTabPageViewController(with match: Match?) {
        tabPageViewController = TabPageViewController(match: match)
        if let tabPageViewController = tabPageViewController {
            addChild(tabPageViewController)

            tabPageViewController.view.frame = tabContainerView.frame
            tabContainerView.addSubview(tabPageViewController.view)
            tabPageViewController.view.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        view.updateConstraints()
    }

    @objc private func profilePressed() {
        guard let user = user else { return }
        let menu = SideMenuNavigationController(rootViewController: ProfileMenuViewController(user: user))
        let presentationStyle: SideMenuPresentationStyle = .viewSlideOutMenuPartialIn
        presentationStyle.presentingEndAlpha = 0.85
        menu.presentationStyle = presentationStyle
        menu.leftSide = true
        menu.statusBarEndAlpha = 0
        menu.menuWidth = view.frame.width * 0.8
        present(menu, animated: true)
    }

    private func setUpConstraints() {

        profileButton.snp.makeConstraints { make in
            make.top.equalTo(tabCollectionView)
            make.leading.equalToSuperview().inset(20)
            make.size.equalTo(profileButtonSize)
        }

        tabCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.size.equalTo(CGSize(width: 227, height: 40))
            make.centerX.equalToSuperview()
        }

        tabContainerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(tabCollectionView.snp.bottom)
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

}

extension HomeViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        activeTabIndex = indexPath.item
        tabPageViewController?.setViewController(to: indexPath.item)
        tabCollectionView.reloadData()
    }

}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tabs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeTabOptionCollectionViewCell.reuseIdentifier,
                                                            for: indexPath) as?
                HomeTabOptionCollectionViewCell else { return UICollectionViewCell() }
        cell.isSelected = indexPath.item == activeTabIndex
        cell.configure(with: tabs[indexPath.item])
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = indexPath.item == 0 ? 151 : 50
        return CGSize(width: cellWidth, height: 40)
    }
}
