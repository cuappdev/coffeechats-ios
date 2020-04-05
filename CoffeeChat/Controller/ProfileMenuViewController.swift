//
//  ProfileMenuViewController.swift
//  CoffeeChat
//
//  Created by HAIYING WENG on 4/4/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

class ProfileMenuViewController: UIViewController {

    private let editButton = UIButton()
    private let optionsTableView = UITableView()
    private let profileImageView = UIImageView()
    private let profileInfoLabel = UILabel()
    private let profileNameLabel = UILabel()
    
    private let profileImageSize = CGSize(width: 120, height: 120)
    private let editButtonSize = CGSize(width: 70, height: 30)
    private let cellReuseId = "cellReuseIdentifier"
    private let menuOptions: [MenuOption] = [
        MenuOption(image: "interests", text: "Your interests"),
        MenuOption(image: "groups", text: "Your groups"),
        MenuOption(image: "settings", text: "Settings")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundLightGreen
        navigationController?.navigationBar.isHidden = true
        
        // TODO: Remove after connecting to backend. These are temp values.
        let firstName = "Ezra"
        let lastName = "Cornell"
        let major = "Government"
        let year = 2020
        let hometown = "Ithaca, NY"

        editButton.backgroundColor = .backgroundWhite
        editButton.setTitle("Edit Info", for: .normal)
        editButton.setTitleColor(.backgroundOrange, for: .normal)
        editButton.titleLabel?.font = ._12CircularStdMedium
        editButton.layer.cornerRadius = editButtonSize.height/2
        editButton.layer.shadowColor = UIColor.black.cgColor
        editButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        editButton.layer.shadowOpacity = 0.15
        editButton.layer.shadowRadius = 2
        editButton.addTarget(self, action: #selector(editPressed), for: .touchUpInside)
        view.addSubview(editButton)
        view.bringSubviewToFront(editButton)
        
        optionsTableView.backgroundColor = .backgroundLightGreen
        optionsTableView.separatorStyle = .none
        optionsTableView.showsVerticalScrollIndicator = false
//        optionsTableView.allowsSelection = true
        optionsTableView.dataSource = self
        optionsTableView.delegate = self
        optionsTableView.register(MenuOptionTableViewCell.self, forCellReuseIdentifier: cellReuseId)
        view.addSubview(optionsTableView)
        
        profileImageView.backgroundColor = .inactiveGreen
        profileImageView.layer.cornerRadius = profileImageSize.width/2
        view.addSubview(profileImageView)
        view.sendSubviewToBack(profileImageView)

        profileInfoLabel.text = "\(major) \(year)\nFrom \(hometown)"
        profileInfoLabel.textColor = .greenGray
        profileInfoLabel.font = ._16CircularStdBook
        profileInfoLabel.numberOfLines = 0
        view.addSubview(profileInfoLabel)

        profileNameLabel.text = "\(firstName) \(lastName)"
        profileNameLabel.textColor = .textBlack
        profileNameLabel.numberOfLines = 0
        profileNameLabel.font = ._24CircularStdMedium
        view.addSubview(profileNameLabel)

        setupConstraints()
    }
    
    private func setupConstraints() {
        let leftPadding = 25
        
        editButton.snp.makeConstraints { make in
            make.centerX.equalTo(profileImageView.snp.trailing)
            make.bottom.equalTo(profileImageView.snp.bottom)
            make.size.equalTo(editButtonSize)
        }
        
        optionsTableView.snp.makeConstraints { make in
            make.top.equalTo(profileInfoLabel.snp.bottom).offset(30)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(leftPadding)
            make.size.equalTo(profileImageSize)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
        }
        
        profileInfoLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(leftPadding)
            make.top.equalTo(profileNameLabel.snp.bottom).offset(5)
        }
        
        profileNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(leftPadding)
            make.top.equalTo(profileImageView.snp.bottom).offset(15)
        }
    }
    
    @objc private func editPressed() {
        print("Edit button pressed")
    }
    
}

extension ProfileMenuViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath) as? MenuOptionTableViewCell else { return UITableViewCell() }
        let option = menuOptions[indexPath.row]
        cell.configure(for: option)
        // Create custom selected background color
        let backgroundView = UIView()
        backgroundView.backgroundColor = .backgroundLightGrayGreen
        cell.selectedBackgroundView = backgroundView
        return cell
    }

}

extension ProfileMenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

}
