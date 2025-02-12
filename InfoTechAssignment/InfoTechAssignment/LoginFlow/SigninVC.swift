//
//  SigninVC.swift
//  InfoTechAssignment
//
//  Created by Suraj on 11/02/25.
//

import UIKit

class SigninVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        addTextFieldObservers()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private var networkInstance:NetworkServiceProtocol
    
    init(networkInstance:NetworkServiceProtocol = NetworkManager.shared){
        self.networkInstance = networkInstance
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome Back"
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textAlignment = .center
        return label
    }()
    
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.gray.cgColor
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login Now", for: .normal)
        button.backgroundColor = .lightGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.isEnabled = false
        button.addTarget(self, action: #selector(didTapLoginBtn), for: .touchUpInside)
        return button
    }()
    
    private let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.addTarget(self, action: #selector(goToSignup), for: .touchUpInside)
        return button
    }()
    
    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, usernameTextField, passwordTextField, loginButton, signupButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func naviagateToDashboard(){
        DispatchQueue.main.async {
            let vc = DashboardVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func showAlert(title:String,message:String,status:CompletionState) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                if status == .success {
                    self.naviagateToDashboard()
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }

    
    @objc private func didTapLoginBtn(){
        var params:[String:String] = [:]
        params = ["email":usernameTextField.text ?? "","password":passwordTextField.text ?? ""]
        networkInstance.getRequest(path: LoginFlowEndPoint.signin.rawValue, params: params){[weak self] status,data in
            guard let self = self else { return }
            switch status {
            case .success:
                if let data = data,let model = try? JSONDecoder().decode([User].self, from: data) {
                    KeychainManager.saveToken(model.first?.token ?? "")
                    showAlert(title: "Sign In", message: "Sign In Succesfull",status: .success)
                } else {
                    showAlert(title: "Sign In", message: "Sign In Failed (User not found)",status: .failure)
                }
            case .failure:
                showAlert(title: "Sign In", message: "Sign In Failure",status:.failure)
                
            case .noInternet:
                showAlert(title: "Sign In", message: "Sign In Failure",status: .noInternet)
                
            case .notAuthorized:
                showAlert(title: "Sign In", message: "Sign In Failure",status:.notAuthorized)
            }
        }
    }
    
    private func addTextFieldObservers() {
        [usernameTextField, passwordTextField].forEach { textField in
            textField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        }
    }
    
    @objc private func validateFields() {
        let isFormValid = !usernameTextField.text!.isEmpty && !passwordTextField.text!.isEmpty
        
        loginButton.isEnabled = isFormValid
        loginButton.backgroundColor = isFormValid ? .systemRed : .lightGray
    }
    
    @objc private func goToSignup() {
        let signupVC = SignupVC()
        navigationController?.pushViewController(signupVC, animated: true)
    }
}

