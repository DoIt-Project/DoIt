//
//  RegistrationController.swift
//  DoIt
//
//  Created by Y u l i a on 22.10.2021.
//

import UIKit

class RegistrationController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureInterface()
    }
    
    private lazy var usernameInputView = InputField(labelImage: UIImage(systemName: "person"), placeholderText: "Enter username")
    private lazy var envelopeInputView = InputField(labelImage: UIImage(systemName: "envelope"), placeholderText: "Enter e-mail")
    private lazy var passwordInputView = InputField(labelImage: UIImage(systemName: "lock"), placeholderText: "Enter password", isSecureTextField: true)
    private lazy var retypePasswordInputView = InputField(labelImage: UIImage(systemName: "lock"), placeholderText: "Reenter password", isSecureTextField: true)
    private lazy var registerButton = CustomRoundedButton(title: "Register")
    private lazy var signInButton = AttributedCustomButton(firstPart: "Already have an account?", secondPart: " Sign in")
    private lazy var header_ = Header(title: "Registration")

    func configureInterface() {
        view.backgroundColor = .white
        
        let stack = UIStackView(arrangedSubviews: [header_, usernameInputView, envelopeInputView, passwordInputView, retypePasswordInputView, registerButton, signInButton])
        
        stack.axis = .vertical
        stack.spacing = 12

        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        stack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
   
    }
    
}
