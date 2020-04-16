//
//  NoMatchViewController.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 2/29/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//
 import UIKit

 class NoMatchViewController: UIViewController {

    // MARK: - Private View Vars
    private let availabilityButton = UIButton()
    private let noMatchLabel = UILabel()
    private let noMatchTitleLabel = UILabel()
    private let profileButton = UIButton()
    private let surprisedPearImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "" // To get rid of the "back" text on navigation bar
        view.backgroundColor = .backgroundLightGreen
        navigationController?.navigationBar.isHidden = true

        let buttonSize = CGSize(width: 225, height: 54)
        let buttonBottomPadding: CGFloat = LayoutHelper.shared.getCustomVerticalPadding(size: 102)
        let imageBottomPadding: CGFloat = LayoutHelper.shared.getCustomVerticalPadding(size: 36)
        let imageWidth = (UIScreen.main.bounds.width / 375) * 176
        let profileButtonSize = CGSize(width: 35, height: 35)
        let subtitleLabelPadding: CGFloat = LayoutHelper.shared.getCustomVerticalPadding(size: 24)
        let titleLabelPadding: CGFloat = LayoutHelper.shared.getCustomVerticalPadding(size: 92)

        profileButton.backgroundColor = .inactiveGreen
        profileButton.layer.cornerRadius = profileButtonSize.width/2
        profileButton.addTarget(self, action: #selector(profilePressed), for: .touchUpInside)
        view.addSubview(profileButton)

        noMatchTitleLabel.text = "Meet your new Pear\nnext Sunday"
        noMatchTitleLabel.numberOfLines = 2
        noMatchTitleLabel.sizeToFit()
        noMatchTitleLabel.textAlignment = .center
        noMatchTitleLabel.textColor = .textBlack
        noMatchTitleLabel.font = ._24CircularStdMedium
        view.addSubview(noMatchTitleLabel)

        surprisedPearImageView.image = UIImage(named: "surprisedPear")
        surprisedPearImageView.contentMode = .scaleAspectFit
        view.addSubview(surprisedPearImageView)

        noMatchLabel.text = "In the meantime, tell me when you're\nusually free to make meeting up easier!"
        noMatchLabel.numberOfLines = 2
        noMatchLabel.textAlignment = .center
        noMatchLabel.textColor = .greenGray
        noMatchLabel.sizeToFit()
        noMatchLabel.font = ._16CircularStdMedium
        view.addSubview(noMatchLabel)

        availabilityButton.setTitle("Enter availability", for: .normal)
        availabilityButton.setTitleColor(.white, for: .normal)
        availabilityButton.titleLabel?.font = ._20CircularStdBold
        availabilityButton.backgroundColor = .backgroundOrange
        availabilityButton.layer.cornerRadius = 26
        availabilityButton.addTarget(self, action: #selector(availabilityButtonPressed), for: .touchUpInside)
        view.addSubview(availabilityButton)

        profileButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.trailing.equalToSuperview().inset(20)
            make.size.equalTo(profileButtonSize)
        }

        noMatchTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(titleLabelPadding)
        }

        noMatchLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(availabilityButton.snp.top).offset(-subtitleLabelPadding)
        }

        surprisedPearImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(noMatchLabel.snp.top).offset(-imageBottomPadding)
            make.width.equalTo(imageWidth)
        }

        availabilityButton.snp.makeConstraints { make in
           make.size.equalTo(buttonSize)
           make.centerX.equalToSuperview()
           make.bottom.equalTo(view.safeAreaLayoutGuide).inset(buttonBottomPadding)
       }
     }

     @objc private func availabilityButtonPressed() {
        print("Available button pressed.")
        let timeVC = TimeViewController()
        navigationController?.pushViewController(timeVC, animated: true)
    }

    @objc private func profilePressed() {
        print("Profile button pressed")
        let editDemographicsVC = EditDemographicsViewController()
        navigationController?.pushViewController(editDemographicsVC, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

 }
