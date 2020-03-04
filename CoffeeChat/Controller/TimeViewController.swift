//
//  TimeViewController.swift
//  CoffeeChat
//
//  Created by HAIYING WENG on 2/19/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import UIKit

class TimeViewController: UIViewController {

    // MARK: - Views
    private var dayCollectionView: UICollectionView!
    private let dayLabel = UILabel()
    private let finishButton = UIButton()
    private var timeCollectionView:UICollectionView!
    private let titleLabel = UILabel()

    // MARK: - Section
    struct Section {
        let type: SectionType
        var items: [ItemType]
    }

    enum SectionType: String {
        case afternoon = "Afternoon"
        case evening = "Evening"
        case morning = "Morning"
    }
    
    enum ItemType {
        case header(String)
        case time(String)
        
        func getTime() -> String? {
            switch self {
            case .time(let time):
                return time
            default:
                return nil
            }
        }
    }

    private var timeSections: [Section] = []

    // MARK: - Data
    private let finishButtonSize = CGSize(width: 175, height: 50)
    private let interitemSpacing: CGFloat = 4
    private let sectionInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)

    private let dayCellReuseId = "dayCellReuseIdentifier"
    private let timeCellReuseId = "timeCellReuseIdentifier"

    private var availabilities: [String: [String]] = [:]
    private let days = ["Su", "M", "Tu", "W", "Th", "F", "Sa"]
    private let daysDict = ["Su": "Sunday", "M": "Monday", "Tu": "Tuesday", "W": "Wednesday", "Th": "Thursday", "F": "Friday", "Sa": "Saturday"]
    private var selectedDay: String = "Su"

    private var afternoonItems: [ItemType] = []
    private let afternoonTimes = ["1:00", "1:30", "2:00", "2:30", "3:00", "3:30", "4:00", "4:30",]
    private var eveningItems: [ItemType] = []
    private let eveningTimes = ["5:00", "5:30", "6:00", "6:30", "7:00", "7:30", "8:00", "8:30"]
    private var morningItems: [ItemType] = []
    private let morningTimes = ["9:00", "9:30", "10:00", "10:30", "11:00", "11:30", "12:00", "12:30"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundLightGreen

        morningItems = [ItemType.header("Morning")] + morningTimes.map{ItemType.time($0)}
        afternoonItems = [ItemType.header("Afternoon")] + afternoonTimes.map{ItemType.time($0)}
        eveningItems = [ItemType.header("Evening")] + eveningTimes.map{ItemType.time($0)}

        titleLabel.text = "When are you free?"
        titleLabel.textColor = .textBlack
        titleLabel.font = ._24CircularStdMedium
        view.addSubview(titleLabel)

        let dayCollectionViewLayout = UICollectionViewFlowLayout()
        dayCollectionViewLayout.minimumInteritemSpacing = 4
        dayCollectionViewLayout.scrollDirection = .horizontal

        dayCollectionView = UICollectionView(frame: .zero, collectionViewLayout: dayCollectionViewLayout)
        dayCollectionView.allowsSelection = true
        dayCollectionView.backgroundColor = .clear
        dayCollectionView.dataSource = self
        dayCollectionView.delegate = self
        dayCollectionView.register(DayCollectionViewCell.self, forCellWithReuseIdentifier: dayCellReuseId)
        dayCollectionView.showsHorizontalScrollIndicator = false
        view.addSubview(dayCollectionView)

        dayLabel.text  = "Every \(daysDict[selectedDay] ?? "")"
        dayLabel.textColor = .textBlack
        dayLabel.font = ._20CircularStdBook
        view.addSubview(dayLabel)

        finishButton.setTitle("Finish", for: .normal)
        finishButton.setTitleColor(.white, for: .normal)
        finishButton.titleLabel?.font = ._20CircularStdBold
        finishButton.backgroundColor = .inactiveGreen
        finishButton.isEnabled = false
        finishButton.layer.cornerRadius = finishButtonSize.height/2
        view.addSubview(finishButton)

        let timeCollectionViewLayout = UICollectionViewFlowLayout()
        timeCollectionViewLayout.minimumInteritemSpacing = interitemSpacing
        timeCollectionViewLayout.sectionInset = sectionInsets
        timeCollectionViewLayout.scrollDirection = .horizontal

        timeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: timeCollectionViewLayout)
        timeCollectionView.allowsMultipleSelection = true
        timeCollectionView.backgroundColor = .clear
        timeCollectionView.dataSource = self
        timeCollectionView.delegate = self
        timeCollectionView.register(TimeCollectionViewCell.self, forCellWithReuseIdentifier: timeCellReuseId)
        view.addSubview(timeCollectionView)

        setupConstraints()
        setupTimeSections()
    }

    private func setupTimeSections() {
        let morningSection = Section(type: .morning, items: morningItems)
        let afternoonSection = Section(type: .afternoon, items: afternoonItems)
        let eveningSection = Section(type: .evening, items: eveningItems)
        
        timeSections = [morningSection, afternoonSection, eveningSection]
    }

    private func setupConstraints() {
        let titleLabelPadding: CGFloat = LayoutHelper.shared.getCustomVerticalPadding(size: 50)
        let bottomPadding: CGFloat = LayoutHelper.shared.getCustomVerticalPadding(size: 30)

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(titleLabelPadding)
            make.centerX.equalToSuperview()
        }

        dayCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(315)
        }

        dayLabel.snp.makeConstraints { make in
            make.top.equalTo(dayCollectionView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }

        finishButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(bottomPadding)
            make.centerX.equalToSuperview()
            make.size.equalTo(finishButtonSize)
        }

        timeCollectionView.snp.makeConstraints { make in
            make.top.equalTo(dayLabel.snp.bottom).offset(16)
            make.bottom.equalTo(finishButton.snp.top).offset(-30)
            make.centerX.equalToSuperview()
            make.width.equalTo(315)
        }
    }

    private func updateFinishButton() {
        let timeCount = availabilities.map({$0.value.count}).reduce(0, +)
        finishButton.isEnabled = availabilities.count != 0 && timeCount > 0
        if finishButton.isEnabled {
            finishButton.backgroundColor = .backgroundOrange
            finishButton.layer.shadowColor = UIColor.black.cgColor
            finishButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            finishButton.layer.shadowOpacity = 0.15
            finishButton.layer.shadowRadius = 2
        } else {
            finishButton.backgroundColor = .inactiveGreen
            finishButton.layer.shadowColor = .none
            finishButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            finishButton.layer.shadowOpacity = 0
            finishButton.layer.shadowRadius = 0
        }
    }

}

extension TimeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == dayCollectionView {
            return 1
        } else {
            return timeSections.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == dayCollectionView {
            return days.count
        } else {
            let section = timeSections[section]
            switch section.type {
            case .afternoon:
                return afternoonItems.count
            case .evening:
                return eveningItems.count
            case .morning:
                return morningItems.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == dayCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: dayCellReuseId, for: indexPath) as? DayCollectionViewCell else { return UICollectionViewCell() }
            let day = days[indexPath.item]
            cell.configure(for: day)
            // Update cell color based on whether there's availability for a day
            if let day = daysDict[day] {
                if availabilities[day] == nil || availabilities[day] == [] {
                    cell.updateBackgroundColor(isAvailable: false)
                } else {
                    cell.updateBackgroundColor(isAvailable: true)
                }
            }
            // Select item if day is the selected day
            if day == selectedDay {
                dayCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
                cell.isSelected = true
            }
            return cell
        } else {
            let section = timeSections[indexPath.section]
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: timeCellReuseId, for: indexPath) as? TimeCollectionViewCell else { return UICollectionViewCell() }
            let item: ItemType
            switch section.type {
            case .afternoon:
                item = afternoonItems[indexPath.item]
            case .evening:
                item = eveningItems[indexPath.item]
            case .morning:
                item = morningItems[indexPath.item]
            }
            switch item {
            case .header(let header):
                cell.configure(for: header, isHeader: true)
                cell.isUserInteractionEnabled = false
            case .time(let time):
                cell.configure(for: time, isHeader: false)
                cell.isUserInteractionEnabled = true
                // Select times that were previously selected for a day
                if let day = daysDict[selectedDay],
                    let dayAvailability = availabilities[day],
                    dayAvailability.contains(time) {
                    timeCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
                    cell.isSelected = true
                }
            }
            return cell
        }
    }
}

extension TimeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == dayCollectionView {
            selectedDay = days[indexPath.item]
            dayLabel.text  = "Every \(daysDict[selectedDay] ?? "")"
            timeCollectionView.reloadData()
        } else {
            let section = timeSections[indexPath.section]
            let item : ItemType
            switch section.type {
            case .afternoon:
                item = afternoonItems[indexPath.item]
            case .evening:
                item = eveningItems[indexPath.item]
            case .morning:
                item = morningItems[indexPath.item]
            }
            guard let time = item.getTime() else { return }
            guard let day = daysDict[selectedDay] else { return }
            if availabilities[day] == nil {
                availabilities[day] = [time]
            } else {
                availabilities[day]?.append(time)
            }
            dayCollectionView.reloadData()
            updateFinishButton()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == dayCollectionView {
            return
        } else {
            let section = timeSections[indexPath.section]
            let item : ItemType
            switch section.type {
            case .afternoon:
                item = afternoonItems[indexPath.item]
            case .evening:
                item = eveningItems[indexPath.item]
            case .morning:
                item = morningItems[indexPath.item]
            }
            guard let time = item.getTime() else { return }
            guard let day = daysDict[selectedDay] else { return }
            availabilities[day]?.removeAll { $0 == time }
            if let dayAvailability = availabilities[day], dayAvailability.isEmpty {
                availabilities.removeValue(forKey: day)
            }
            dayCollectionView.reloadData()
            updateFinishButton()
        }
    }
}

extension TimeViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == dayCollectionView {
            return CGSize(width: 36, height: 48)
        } else {
            let itemWidth = timeCollectionView.frame.width/3 - sectionInsets.left - sectionInsets.right
            let itemHeight = (timeCollectionView.frame.height)/9 - interitemSpacing
            return itemHeight > 36
                ? CGSize(width: itemWidth, height: 36)
                : CGSize(width: itemWidth, height: itemHeight)
        }
    }
}
