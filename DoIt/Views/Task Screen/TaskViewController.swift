//
//  TaskViewController.swift
//  DoIt
//
//  Created by Данил Швец on 01.12.2021.
//

import UIKit

class TaskViewController: UIViewController {
    
    private struct UIConstants {
        static let boldFontSize = 28.0
        static let normalFontSize = 24.0
        static let navigationBarFontSize = 20.0
        static let stackPadding = 20.0
        static let verticalStackSpacing = 10.0
        static let horizontalStackSpacing = 20.0
        static let imageCornerRadius = 12.0
        static let verticalStackTopSpacing = 15.0
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var timerTitle: UILabel = getLabel(title: TaskScreen.countdown.rawValue.localized)
    private lazy var timerLabel: UILabel = getLabel()

    private lazy var taskDescriptionTitle: UILabel = getLabel(title: TaskScreen.description.rawValue.localized)
    private lazy var taskDescription: InputBox = {
        let taskDescription = InputBox(maxHeight: 200, placeholder: TaskString.description.rawValue.localized)
        taskDescription.textView.isEditable = false
        taskDescription.textView.font = UIFont.systemFont(ofSize: UIConstants.normalFontSize)
        taskDescription.textView.textAlignment = .center
        return taskDescription
    }()

    private lazy var taskChapterTitle: UILabel = getLabel(title: TaskScreen.chapter.rawValue.localized)
    private lazy var taskChapter: UILabel = getLabel()
    
    private lazy var taskImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = UIConstants.imageCornerRadius
        image.layer.masksToBounds = true
        image.heightAnchor.constraint(equalTo: image.widthAnchor).isActive = true
        image.widthAnchor.constraint(equalToConstant: view.bounds.width / 2).isActive = true
        return image
    }()
    private lazy var taskImageViewContainter: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var deleteButton = CustomRoundedButton(image: .TaskIcons.trashIcon, target: self, action: #selector(deleteButtonPressed), width: UIScreen.main.bounds.width / 4, color: .AppColors.greyColor)
    private lazy var doneButton = CustomRoundedButton(image: .TaskIcons.checkMarkIcon, target: self, action: #selector(doneButtonPressed), width: UIScreen.main.bounds.width / 4, color: UIColor.AppColors.doneColor)
    private lazy var editButton = CustomRoundedButton(image: .TaskIcons.editIcon, target: self, action: #selector(editButtonPressed), width: UIScreen.main.bounds.width / 4, color: UIColor.AppColors.accentColor)
    
    private lazy var horizontalStack: UIStackView = {
        let horizontalStack = UIStackView(arrangedSubviews: [deleteButton, doneButton, editButton])
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .fill
        horizontalStack.distribution = .fillEqually
        horizontalStack.spacing = UIConstants.horizontalStackSpacing
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        return horizontalStack
    }()
    
    private var timer: Timer?
    
    private var countdown: DateComponents? {
        guard let deadlineDate = viewModel.taskModel.value?.deadline else { return nil }
        return Calendar.current.dateComponents([.day, .hour, .minute, .second], from: Date(), to: deadlineDate)
    }
    
    var viewModel: TaskViewModel = TaskViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        runCountdown()
        
        viewModel.taskModel.bind { _ in
            DispatchQueue.main.async { [weak self] in
                self?.configure()
            }
        }
    }
    
    private func configure() {
        guard let taskModel = viewModel.taskModel.value else { return }
        taskImage.image = .TaskIcons.defaultImage
        taskDescription.text = taskModel.description
        taskChapter.text = TaskCategory(index: taskModel.chapterId).chapter.title
        configureNavigationBar(title: taskModel.title, isDone: taskModel.isDone)
        horizontalStack.isHidden = !taskModel.isMyTask
        timerLabel.text = taskModel.deadline == nil ? TaskScreen.noDeadline.rawValue.localized : nil
        if taskModel.isDone {
            timer?.invalidate()
        }
        viewModel.downloadImage(taskModel.image) { [weak self] image in
            guard let image = image else {
                return
            }
            self?.taskImage.image = image
        }
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
        layoutScrollView()
        layoutContentView()
        layoutImageView()
        layoutStackViews()
        
        configureNavigationBar(title: nil, isDone: nil)
    }
    
    private func layoutScrollView() {
        view.addSubview(scrollView)
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    private func layoutContentView() {
        scrollView.addSubview(contentView)
        contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor).isActive = true
    }
    
    private func layoutStackViews() {
        let verticalStack = UIStackView(arrangedSubviews: [timerTitle, timerLabel, taskChapterTitle, taskChapter, taskDescriptionTitle, taskDescription, taskImageViewContainter, horizontalStack])
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        verticalStack.axis = .vertical
        verticalStack.distribution = .equalSpacing
        verticalStack.spacing = UIConstants.verticalStackSpacing
        
        [verticalStack, horizontalStack].forEach { stack in
            contentView.addSubview(stack)
            stack.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: UIConstants.stackPadding).isActive = true
            stack.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -UIConstants.stackPadding).isActive = true
        }
        
        verticalStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: UIConstants.verticalStackTopSpacing).isActive = true
        
        horizontalStack.topAnchor.constraint(greaterThanOrEqualTo: verticalStack.bottomAnchor, constant: UIConstants.verticalStackSpacing).isActive = true
        horizontalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    private func layoutImageView() {
        taskImageViewContainter.addSubview(taskImage)
        taskImageViewContainter.heightAnchor.constraint(equalTo: taskImage.heightAnchor).isActive = true
        taskImage.centerYAnchor.constraint(equalTo: taskImageViewContainter.centerYAnchor).isActive = true
        taskImage.centerXAnchor.constraint(equalTo: taskImageViewContainter.centerXAnchor).isActive = true
    }
    
    private func getLabel(title: String? = nil) -> UILabel {
        let timerLabel = UILabel()
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.font = UIFont.systemFont(ofSize: title == nil ? UIConstants.normalFontSize : UIConstants.boldFontSize)
        timerLabel.text = title
        timerLabel.textAlignment = title == nil ? .center : .left
        return timerLabel
    }
    
    private func configureNavigationBar(title: String? = nil, isDone: Bool? = nil) {
        let navigationBarView = UIView()
        navigationBarView.translatesAutoresizingMaskIntoConstraints = false
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = title
        label.textColor = .AppColors.navigationTextColor

        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = UIView.ContentMode.scaleAspectFit
        image.setContentCompressionResistancePriority(.required, for: .horizontal)

        let stack = UIStackView(arrangedSubviews: [label, image])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = UIConstants.verticalStackSpacing

        navigationItem.titleView = stack
        navigationItem.largeTitleDisplayMode = .never

        guard let isDone = isDone else { return }
        image.tintColor = isDone ? .AppColors.taskDoneColor : .AppColors.taskOutdatedColor
        image.image = isDone ? .TaskIcons.doneIcon : .TaskIcons.outdatedIcon
    }
    
    private func runCountdown() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
}

// MARK: - Actions

extension TaskViewController {
    @objc private func deleteButtonPressed(){
        viewModel.removeTask(completion: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        })
    }
    
    @objc private func doneButtonPressed(){
        timer?.invalidate()
        configureNavigationBar(title: nil, isDone: true)
        timerLabel.text = "00:00:00:00"
        timerLabel.textColor = .AppColors.doneColor
        viewModel.setTaskDone()
    }

    @objc private func editButtonPressed(){
        let taskEditController = TaskEditViewController()
        taskEditController.viewModel.taskModel = viewModel.taskModel
        present(taskEditController, animated: true, completion: nil)
    }
    
    @objc private func updateTime() {
        guard let days = countdown?.day, let hours = countdown?.hour, let minutes = countdown?.minute, let seconds = countdown?.second else { return }
        guard let deadlineDate = viewModel.taskModel.value?.deadline, deadlineDate >= Date(), days >= 0 && hours >= 0 && minutes >= 0 && seconds >= 0 else {
            timer?.invalidate()
            timerLabel.text = "00:00:00:00"
            timerLabel.textColor = .red
            return
        }
        timerLabel.text = String(format: "%02i:%02i:%02i:%02i", days, hours, minutes, seconds)
    }
}
