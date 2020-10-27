//
//  CommunityViewController.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 10/1/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

class CommunityViewController: UIViewController {

    // MARK: - Private View Vars
    private let communityTableView = UITableView()
    private let searchBar = UISearchBar()

    // MARK: - Private Data Vars
    // TODO: Replace with backend values
    private let users: [User] = [
        User(
            clubs: ["AppDev"],
            firstName: "Lucy",
            googleID: "12345",
            graduationYear: "2021",
            hometown: "Boston, MA",
            interests: ["Art", "AppDev", "DTI"],
            lastName: "Xu",
            major: "Computer Science",
            matches: nil,
            netID: "llx2",
            profilePictureURL: "",
            pronouns: "She/her",
            facebook: nil,
            instagram: nil
        ),
        User(
            clubs: ["AppDev"],
            firstName: "Cindy",
            googleID: "12345",
            graduationYear: "2022",
            hometown: "Boston, MA",
            interests: ["Art", "Art", "Netflix", "Netflix", "Writing", "Art", "Netflix", "Netflix", "Art", "Art"],
            lastName: "Huang",
            major: "Computer Science",
            matches: nil,
            netID: "llx2",
            profilePictureURL: "",
            pronouns: "She/her",
            facebook: nil,
            instagram: nil
        ),
        User(
            clubs: ["AppDev"],
            firstName: "Manish",
            googleID: "12345",
            graduationYear: "2021",
            hometown: "Boston, MA",
            interests: ["Art", "ABC", "Chill", "Box", "Long", "Array"],
            lastName: "Shah",
            major: "Computer Science",
            matches: nil,
            netID: "llx2",
            profilePictureURL: "",
            pronouns: "He/Him",
            facebook: nil,
            instagram: nil
        )
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .backgroundLightGreen

        searchBar.delegate = self
        searchBar.backgroundColor = .backgroundWhite
        searchBar.backgroundImage = UIImage()
        searchBar.placeholder = "Search"
        searchBar.searchTextField.backgroundColor = .backgroundWhite
        searchBar.searchTextField.textColor = .black
        searchBar.searchTextField.font = ._16CircularStdBook
        searchBar.searchTextField.clearButtonMode = .never
        searchBar.layer.cornerRadius = 8
        searchBar.showsCancelButton = false
        searchBar.layer.shadowColor = UIColor.black.withAlphaComponent(0.15).cgColor
        searchBar.layer.shadowOpacity = 1
        searchBar.layer.shadowRadius = 4
        searchBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.addSubview(searchBar)

        communityTableView.delegate = self
        communityTableView.dataSource = self
        communityTableView.isScrollEnabled = true
        communityTableView.separatorStyle = .none
        communityTableView.backgroundColor = .clear
        communityTableView.rowHeight = UITableView.automaticDimension
        communityTableView.estimatedRowHeight = 140
        communityTableView.sizeToFit()
        communityTableView.register(CommunityUserTableViewCell.self, forCellReuseIdentifier: CommunityUserTableViewCell.reuseIdentifier)
        view.addSubview(communityTableView)

        setupConstraints()
    }
    
    private func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(23)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(40)
        }

        communityTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
        }
    }
}

extension CommunityViewController: UITableViewDelegate {}

extension CommunityViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommunityUserTableViewCell.reuseIdentifier, for: indexPath) as? CommunityUserTableViewCell else { return UITableViewCell() }
        let user = users[indexPath.row]
        cell.configure(with: user)
        return cell
    }

}

// MARK: - SearchBarDelegate
extension CommunityViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // TODO: Implement search and filter
    }

}


