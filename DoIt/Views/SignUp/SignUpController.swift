//
//  RegistrationController.swift
//  DoIt
//
//  Created by Y u l i a on 22.10.2021.
//

import UIKit

class SignUpController: UIViewController {

    private struct UIConstants {
        static let spacing = 12.0
    }

    private lazy var usernameInputView = InputField(labelImage: UIImage.AuthIcons.personIcon, placeholderText: AuthStrings.username.rawValue.localized)
    private lazy var envelopeInputView = InputField(labelImage: UIImage.AuthIcons.envelopeIcon, placeholderText: AuthStrings.email.rawValue.localized)
    private lazy var passwordInputView : InputField = {
        lazy var passwordInput = InputField(labelImage: UIImage.AuthIcons.lockIcon, placeholderText: AuthStrings.password.rawValue.localized)
        passwordInput.textField.isSecureTextEntry = true
        return passwordInput
    }()
    private lazy var retypePasswordInputView : InputField = {
        let retypePasswordInput = InputField(labelImage: UIImage.AuthIcons.lockIcon, placeholderText: AuthStrings.retypePassword.rawValue.localized)
        retypePasswordInput.textField.isSecureTextEntry = true
        return retypePasswordInput
    }()
    private lazy var registerButton = CustomRoundedButton(title: AuthStrings.signUp.rawValue.localized, target: self, action: #selector(registerButtonPressed(_:)))
    private lazy var signInButton: AttributedCustomButton = {
        let button = AttributedCustomButton(firstPart: AuthStrings.alreadySignedUp.rawValue.localized, secondPart: AuthStrings.signIn.rawValue.localized)
        button.addTarget(self, action: #selector(signInButtonPressed(_:)), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    // MARK: - Private Methods
    
    private func configureView() {
        navigationController?.hidesBarsOnSwipe = true
        view.backgroundColor = .systemBackground
        navigationItem.title = AuthStrings.headerSignUp.rawValue.localized
        configureInputsStackView()
    }

    private func configureInputsStackView() {
        let stack = UIStackView(arrangedSubviews: [usernameInputView, envelopeInputView, passwordInputView, retypePasswordInputView, registerButton, signInButton])
        stack.axis = .vertical
        stack.spacing = UIConstants.spacing
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.spacing).isActive = true
        stack.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        stack.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    }
    
    @objc private func registerButtonPressed(_ sender: UIButton) {
        let mainScreen = CustomNavigationController(rootViewController: OnboardingViewController())
        mainScreen.modalPresentationStyle = .fullScreen
        present(mainScreen, animated: true)
        
    }
    
    @objc private func signInButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
