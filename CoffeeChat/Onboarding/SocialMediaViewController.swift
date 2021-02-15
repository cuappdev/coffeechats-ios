//
//  SocialMediaViewController.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 10/5/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

class SocialMediaViewController: UIViewController {

    // MARK: - Private Data vars
    private weak var delegate: OnboardingPageDelegate?

    // MARK: - Private View Vars
    private let backButton = UIButton()
    private let disclaimerLabel = UILabel()
    private var facebookTextField = UITextField()
    private var instagramTextField = UITextField()
    private let nextButton = UIButton()
    private let skipButton = UIButton()
    private let subtitleLabel = UILabel()
    private let titleLabel = UILabel()
    
    private let button = UIButton()
    
    
    var instagramApi = InstagramAPI.shared
    var testUserData = InstagramTestUser(access_token: "", user_id: 0)
    var instagramUser: InstagramUser?
    var signedIn = false

    init(delegate: OnboardingPageDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.setTitle("Add instagram", for: .normal)
        button.layer.backgroundColor = UIColor.greenGray.cgColor
        button.addTarget(self, action: #selector(authenticateOrSignIn), for: .touchUpInside)
        view.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 300, height: 40))
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(400)
        }

        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        view.addSubview(backButton)

        titleLabel.text = "Connect your social\nmedia?"
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = ._24CircularStdMedium
        view.addSubview(titleLabel)

        subtitleLabel.text = "Help your Pear contact you"
        subtitleLabel.textColor = .greenGray
        subtitleLabel.font = ._12CircularStdBook
        view.addSubview(subtitleLabel)

        setSocialMediaTextField(socialMediaTextField: instagramTextField)
        instagramTextField.placeholder = "@Instagram handle"
        let instagramImageView = UIImageView(image: UIImage(named: "instagram"))
        instagramImageView.frame = CGRect(x: 15, y: 15, width: 19, height: 19)
        instagramTextField.addSubview(instagramImageView)
        view.addSubview(instagramTextField)

        setSocialMediaTextField(socialMediaTextField: facebookTextField)
        facebookTextField.placeholder = "Facebook profile link"
        let facebookImageView = UIImageView(image: UIImage(named: "facebook"))
        facebookImageView.frame = CGRect(x: 15, y: 15, width: 19, height: 19)
        facebookTextField.addSubview(facebookImageView)
        view.addSubview(facebookTextField)

        disclaimerLabel.text = "Your information will only be shared with the verified Cornell students you are paired with."
        disclaimerLabel.textColor = .greenGray
        disclaimerLabel.font = ._12CircularStdBook
        disclaimerLabel.numberOfLines = 0
        disclaimerLabel.textAlignment = .center
        disclaimerLabel.lineBreakMode = .byWordWrapping
        view.addSubview(disclaimerLabel)

        nextButton.setTitle("Ready for Pear", for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.titleLabel?.font = ._20CircularStdBold
        nextButton.backgroundColor = .inactiveGreen
        nextButton.layer.cornerRadius = 26
        nextButton.isEnabled = false
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        view.addSubview(nextButton)

        skipButton.titleLabel?.font = ._16CircularStdMedium
        skipButton.setTitle("Skip", for: .normal)
        skipButton.setTitleColor(.greenGray, for: .normal)
        skipButton.backgroundColor = .none
        skipButton.addTarget(self, action: #selector(skipButtonPressed), for: .touchUpInside)
        view.addSubview(skipButton)

        getUserSocialMedia()
        setupConstraints()
    }

    private func setSocialMediaTextField(socialMediaTextField: UITextField) {
        socialMediaTextField.backgroundColor = .backgroundWhite
        socialMediaTextField.textColor = .black
        socialMediaTextField.font = ._20CircularStdBook
        socialMediaTextField.clearButtonMode = .never
        socialMediaTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        socialMediaTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 49))
        socialMediaTextField.leftViewMode = .always
        socialMediaTextField.layer.cornerRadius = 8
        socialMediaTextField.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        socialMediaTextField.layer.shadowOpacity = 1
        socialMediaTextField.layer.shadowRadius = 4
        socialMediaTextField.layer.shadowOffset = CGSize(width: 0, height: 2)
    }

    private func setupConstraints() {
        backButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel).offset(6)
            make.size.equalTo(Constants.Onboarding.backButtonSize)
            make.leading.equalToSuperview().offset(24)
        }

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 318, height: 61))
            make.top
                .equalTo(view.safeAreaLayoutGuide)
                .offset(Constants.Onboarding.titleLabelPadding)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }

        disclaimerLabel.snp.makeConstraints { make in
            make.bottom.equalTo(nextButton.snp.top).offset(-16)
            make.leading.trailing.equalToSuperview().inset(63)
        }

        instagramTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(49)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(62)
        }

        facebookTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(49)
            make.top.equalTo(instagramTextField.snp.bottom).offset(16)
        }

        nextButton.snp.makeConstraints { make in
            make.size.equalTo(Constants.Onboarding.mainButtonSize)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constants.Onboarding.nextBottomPadding)
        }

        skipButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 86, height: 20))
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constants.Onboarding.skipBottomPadding)
        }
    }

    // MARK: - Next and Previous Buttons
    private func updateNext() {
        guard let instagramHandle = instagramTextField.text, let facebookHandle = facebookTextField.text else { return }
        let isSocialMediaEntered =
            instagramHandle.trimmingCharacters(in: .whitespaces).isEmpty ||
            facebookHandle.trimmingCharacters(in: .whitespaces).isEmpty
        nextButton.isEnabled = isSocialMediaEntered
        nextButton.backgroundColor = nextButton.isEnabled ? .backgroundOrange : .inactiveGreen
        skipButton.isEnabled = !nextButton.isEnabled
        let skipButtonColor: UIColor = skipButton.isEnabled ? .greenGray : .inactiveGreen
        skipButton.setTitleColor(skipButtonColor, for: .normal)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        updateNext()
    }

    @objc func backButtonPressed() {
        delegate?.backPage(index: 4)
    }

    @objc func nextButtonPressed() {
        let instagramHandle = instagramTextField.text ?? ""
        let facebookHandle = facebookTextField.text ?? ""
        NetworkManager.shared.updateUserSocialMedia(facebook: facebookHandle, instagram: instagramHandle).observe { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .value(let response):
                    if response.success {
                        UserDefaults.standard.set(true, forKey: Constants.UserDefaults.onboardingCompletion)
                        self.navigationController?.pushViewController(HomeViewController(), animated: true)
                    } else {
                        self.present(UIAlertController.getStandardErrortAlert(), animated: true, completion: nil)
                    }
                case .error:
                    self.present(UIAlertController.getStandardErrortAlert(), animated: true, completion: nil)
                }
            }
        }
    }
    
    private func getUserSocialMedia() {
        guard let netId = UserDefaults.standard.string(forKey: Constants.UserDefaults.userNetId) else { return }
        NetworkManager.shared.getUser(netId: netId).observe { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .value(let response):
                    if response.success {
                        if let facebook = response.data.facebook {
                            self.facebookTextField.text = facebook
                        }
                        if let instagram = response.data.instagram {
                            self.instagramTextField.text = instagram
                        }
                        self.updateNext()
                    } else {
                        print("Network error: could not get user social media.")
                    }
                case .error:
                    print("Network error: could not get user social media.")
                }
            }
        }
    }

    @objc func skipButtonPressed() {
        UserDefaults.standard.set(true, forKey: Constants.UserDefaults.onboardingCompletion)
        let homeVC = HomeViewController()
        navigationController?.pushViewController(homeVC, animated: true)
    }
    
    func presentAlert() {
        let alert = UIAlertController(title: "Signed In:", message: "with account: @\(self.instagramUser!.username)", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func presentWebViewController() {
        let webVC = WebViewController()
        webVC.mainVC = self
        self.present(webVC, animated: true)
    }
    
    @objc func authenticateOrSignIn() {
        if self.testUserData.user_id == 0 {
            print("trying to sign in")
            presentWebViewController()
        } else {
            InstagramAPI.shared.getInstagramUser(testUserData: self.testUserData) { [weak self] (user) in
                self?.instagramUser = user
                self?.signedIn = true
                DispatchQueue.main.async {
                    self?.presentAlert()
                }
            }
        }
    }

}
