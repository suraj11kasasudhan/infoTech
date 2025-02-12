//
//  SignupVC.swift
//  InfoTechAssignment
//
//  Created by Suraj on 11/02/25.
//

import UIKit

import UIKit

class SignupVC: UIViewController {
    
    private var networkInstance:NetworkServiceProtocol
    private var genders:[String] = ["Male", "Female", "Other"]
    
    init(networkInstance:NetworkServiceProtocol = NetworkManager.shared){
        self.networkInstance = networkInstance
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign Up"
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textAlignment = .center
        return label
    }()
    
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.gray.cgColor
        return textField
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.layer.borderColor = UIColor.black.cgColor
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.gray.cgColor
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.layer.borderColor = UIColor.black.cgColor
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.gray.cgColor
        return textField
    }()
    
    private let confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Confirm Password"
        textField.layer.borderColor = UIColor.black.cgColor
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.gray.cgColor
        return textField
    }()
    
    private let dobLabel: UILabel = {
        let label = UILabel()
        label.text = "Date of Birth"
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private let dobPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        return picker
    }()
    
    private let genderLabel: UILabel = {
        let label = UILabel()
        label.text = "Gender"
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private let genderSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Male", "Female", "Other"])
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    private let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = .lightGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.isEnabled = false
        button.addTarget(self, action: #selector(didTapSignupBtn), for: .touchUpInside)
        return button
    }()
    
   
    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            usernameTextField,
            emailTextField,
            passwordTextField,
            confirmPasswordTextField,
            dobLabel,
            dobPicker,
            genderLabel,
            genderSegmentedControl,
            signupButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
    
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            signupButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func addTextFieldObservers() {
        usernameTextField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(validateEmail), for: .editingDidEnd)
        passwordTextField.addTarget(self, action: #selector(validatePassword), for: .editingDidEnd)
        confirmPasswordTextField.addTarget(self, action: #selector(validatePassword), for: .editingChanged)
    }
    
    private func isUserAdult(_ birthDate: Date) -> Bool {
        let calendar = Calendar.current
        let currentDate = Date()
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: currentDate)
        return (ageComponents.year ?? 0) >= 18
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$&*]).{6,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }

    @objc private func validateFields() {
        guard let username = usernameTextField.text, !username.isEmpty,
              let email = emailTextField.text, isValidEmail(email),
              let password = passwordTextField.text, isValidPassword(password),
              let confirmPassword = confirmPasswordTextField.text, password == confirmPassword
              else {
            signupButton.isEnabled = false
            signupButton.backgroundColor = .lightGray
            return
        }

        signupButton.isEnabled = true
        signupButton.backgroundColor = .systemRed
    }

    
    private func naviagateToSignin(){
        DispatchQueue.main.async {
            let vc = SigninVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func showAlert(title:String,message:String,status:CompletionState?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
                if status == .success {
                    self.naviagateToSignin()
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc private func validateEmail() {
        if let email = emailTextField.text, !isValidEmail(email) {
            if email.count > 0 {
                showAlert(title: "Email", message: "Please enter a valid email address.", status: nil)
            }
        }
        validateFields()
    }

    @objc private func validatePassword() {
        if let password = passwordTextField.text, !isValidPassword(password) {
            if password.count > 0 {
                showAlert(title: "Password", message: "Password must be at least 6 characters, include 1 uppercase, 1 number, and 1 special character.", status: nil)
            }
        }
        validateFields()
    }

   @objc private func validateDOB() {
        if !isUserAdult(dobPicker.date) {
            showAlert(title: "Date of birth", message: "You must be at least 18 years old to sign up.", status: nil)
        }
    }


    
    @objc private func didTapSignupBtn(){
        if !isUserAdult(dobPicker.date) {
            validateDOB()
            return
        }
        var params: [String: String]
        let selectedGender = genders[genderSegmentedControl.selectedSegmentIndex]

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dobString = dateFormatter.string(from: dobPicker.date)

        params = [
            "name": usernameTextField.text ?? "",
            "email": emailTextField.text ?? "",
            "password": passwordTextField.text ?? "",
            "gender": selectedGender,
            "dateOfBirth": dobString
        ]
        if let jsonData = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted) {
            networkInstance.postRequest(path: LoginFlowEndPoint.signup.rawValue, queryParams: nil, postParmsData: jsonData){[weak self] (status,data) in
                guard let self = self else { return }
                switch status {
                case .success:
                    if let data = data ,let model = try? JSONDecoder().decode(User.self, from: data) {
                        showAlert(title: "Sign Up", message: "Sign up successfully",status: .success)
                    }
                    
                case .failure:
                    showAlert(title: "Sign Up", message: "Sign up failed",status: .failure)
                    
                case .noInternet:
                    showAlert(title: "Sign Up", message: "Please check your interet connection",status: .noInternet)
                    
                case .notAuthorized:
                    showAlert(title: "Sign Up", message: "Sign up failed",status: .notAuthorized)
                    
                }
            }
        }
       
    }
}

