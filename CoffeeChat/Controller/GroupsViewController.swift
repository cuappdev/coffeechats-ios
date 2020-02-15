//
//  GroupsViewController.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 2/9/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit
import SnapKit

class GroupsViewController: UIViewController {

    // MARK: - Private Data vars
    private weak var delegate: OnboardingPageDelegate?
    private var selectedGroups: [Group] = []
    private var groups: [Group] = [
        Group(name: "Apple", image: ""),
        Group(name: "banana", image: ""),
        Group(name: "Cornell AppDev", image: ""),
        Group(name: "dandelion", image: ""),
        Group(name: "giraffe", image: ""),
        Group(name: "heap", image: ""),
        Group(name: "Igloo", image: ""),
        Group(name: "Jeans", image: "")
    ]
    private var displayedGroups: [Group] = []

    // MARK: - Private View Vars
    private let searchBar = UISearchBar()
    private let backButton = UIButton()
    private let clubLabel = UILabel()
    private let greetingLabel = UILabel()
    private let nextButton = UIButton()
    private let tableView = UITableView(frame: .zero, style: .plain)

    // MARK: - Gradients
    // Fade out affects on the top and bottom of the tableView
    private let bottomFadeView = UIView()
    private let topFadeView = UIView()

    init(delegate: OnboardingPageDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundWhite

        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        view.addSubview(searchBar)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(OnboardingTableViewCell.self, forCellReuseIdentifier: OnboardingTableViewCell.reuseIdentifier)
        tableView.isScrollEnabled = true
        tableView.clipsToBounds = true
        tableView.allowsMultipleSelection = true
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        view.addSubview(tableView)
        view.addSubview(topFadeView)
        view.addSubview(bottomFadeView)

        clubLabel.text = "What clubs are you in?"
        clubLabel.font = .systemFont(ofSize: 24, weight: .bold)
        view.addSubview(clubLabel)

        nextButton.setTitle("Get started!", for: .normal)
        nextButton.layer.cornerRadius = 27
        nextButton.backgroundColor = .backgroundLightGray
        nextButton.setTitleColor(.textBlack, for: .normal)
        nextButton.titleLabel?.font = .systemFont(ofSize: 20)
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        view.addSubview(nextButton)

        backButton.titleLabel?.font = .systemFont(ofSize: 16)
        backButton.setTitle("Go back", for: .normal)
        backButton.setTitleColor(.textLightGray, for: .normal)
        backButton.backgroundColor = .none
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        view.addSubview(backButton)

        displayedGroups = groups

        setupConstraints()
    }

    private func setupConstraints() {

        let backBottomPadding: CGFloat = 49
        let backButtonSize = CGSize(width: 62, height: 20)
        let fadeHeight: CGFloat = 26
        let nextBottomPadding: CGFloat = 21
        let nextButtonSize = CGSize(width: 225, height: 54)
        let searchSize = CGSize(width: 295, height: 42)
        let searchTopPadding: CGFloat = 50
        let tableViewSize = CGSize(width: 295, height: 365)
        let tableViewTopPadding: CGFloat = 24
        let titleHeight: CGFloat = 30
        let titleSpacing: CGFloat = 100
        let topFadeHeight: CGFloat = 10

        searchBar.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(clubLabel.snp.bottom).offset(searchTopPadding)
            make.size.equalTo(searchSize)
        }

        clubLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(titleHeight)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(titleSpacing)
        }

        tableView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(tableViewSize)
            make.top.equalTo(searchBar.snp.bottom).offset(tableViewTopPadding)
        }

        topFadeView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(tableView)
            make.height.equalTo(topFadeHeight)
        }

        bottomFadeView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalTo(tableView)
            make.height.equalTo(fadeHeight)
        }

        nextButton.snp.makeConstraints { make in
            make.size.equalTo(nextButtonSize)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(backButton.snp.top).inset(nextBottomPadding)
        }

        backButton.snp.makeConstraints { make in
            make.size.equalTo(backButtonSize)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(backBottomPadding)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        let clearColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0)

        let topLayer = CAGradientLayer()
        topLayer.frame = topFadeView.bounds
        topLayer.colors = [UIColor.backgroundWhite.cgColor, clearColor.cgColor]
        topLayer.locations = [0.0, 1.0]
        topFadeView.layer.insertSublayer(topLayer, at: 0)

        let bottomLayer = CAGradientLayer()
        bottomLayer.frame = bottomFadeView.bounds
        bottomLayer.colors = [clearColor.cgColor, UIColor.backgroundWhite.cgColor]
        bottomLayer.locations = [0.0, 1.0]
        bottomFadeView.layer.insertSublayer(bottomLayer, at: 0)
    }

    // MARK: - Search Bar
    /** Updates the search bar text based on currently selected Groups. */
    private func updateSearchBarText() {
        if selectedGroups.isEmpty {
            searchBar.text = ""
            return
        }

        /** Number of characters before list is considered "too long" and shortened to "..." */
        let tooLong = 20
        let wordLong = 15

        let listString = (selectedGroups.map { $0.name } ).joined(separator: ", ")
        let lastComma = listString.lastIndex(of: ",")

        if let comma = lastComma {
            let lastWordLength = listString.count - comma.utf16Offset(in: listString) - 2
            if listString.count < tooLong {
                searchBar.text = "\(listString), "
            } else if listString.count > tooLong && lastWordLength < wordLong { // Last word is short enough to show
                searchBar.text = "...\(listString.suffix(from: comma)), "
            } else { // Both the entire string and the last word are too long to display
                searchBar.text = "..., "
            }
        } else if listString.count < tooLong { // listString is one item, and show it if its short
            searchBar.text = "\(listString), "
        }
    }

    /** Retrieves user typed search text from searchBar */
    private func getSearchText(from searchText: String) -> String {
        guard let lastGroupName = selectedGroups.last?.name else { return searchBar.text ?? "" }
        let result: String
        if searchText.contains(lastGroupName) { // Search for text after listing
            result = searchText.components(separatedBy: lastGroupName + ", ").last ?? ""
        } else if searchText.contains("..., ") { // Search for text after ..., "
            result = searchText.components(separatedBy: "..., ").last ?? ""
        } else if searchText.contains(", ") { // User backspaced into the previous list item
            result = searchText.components(separatedBy: ", ").last ?? ""
        } else { // User is deleting list, and should show all options
          result = ""
        }
        return result.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /** Filters table view results based on text typed in search */
    private func filterTableView(searchText: String) {
        displayedGroups = searchText.isEmpty ?
            groups :
            groups.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        tableView.reloadData()
    }

    // MARK: - Next and Previous Buttons
    /**
     Updates the enabled state of next button based on the state of selectedGroups.
     */
    private func updateNext() {
        nextButton.isEnabled = selectedGroups.count > 0
        nextButton.backgroundColor = nextButton.isEnabled ? .backgroundRed : .backgroundLightGray
    }

    @objc func nextButtonPressed() {
        print("Next button pressed.")
    }

    @objc func backButtonPressed() {
        delegate?.backPage(index: 1)
    }

}

// MARK: - TableViewDelegate
extension GroupsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedGroups.append(displayedGroups[indexPath.section])
        updateSearchBarText()
        filterTableView(searchText: getSearchText(from: searchBar.text ?? ""))
        updateNext()
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedGroups.removeAll { $0.name == displayedGroups[indexPath.section].name}
        updateSearchBarText()
        filterTableView(searchText: getSearchText(from: searchBar.text ?? ""))
        updateNext()
    }

}

// MARK: - TableViewDataSource
extension GroupsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:
            OnboardingTableViewCell.reuseIdentifier, for: indexPath) as?
        OnboardingTableViewCell else { return UITableViewCell() }
        let data = displayedGroups[indexPath.section]
        cell.configure(with: data)
        // Keep previous selected cell when reloading tableView
        // if selectedGroups.reduce(false, { $0 || $1.name == data.name }) {
        if selectedGroups.contains(where: { $0.name == data.name }) {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return displayedGroups.count
    }

}

extension GroupsViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterTableView(searchText: getSearchText(from: searchText))
    }

}
