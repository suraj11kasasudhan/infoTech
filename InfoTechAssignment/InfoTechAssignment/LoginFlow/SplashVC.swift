//
//  SplashVC.swift
//  InfoTechAssignment
//
//  Created by Suraj on 11/02/25.
//

import UIKit

class SplashVC: UIViewController{
    
    private let authenticatingLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        createViews()
        self.view.backgroundColor = .orange
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            self.handleLogin()
        }
    }
    
    private func createViews(){
        self.view.addSubview(authenticatingLabel)
        authenticatingLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            authenticatingLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            authenticatingLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            authenticatingLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            authenticatingLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100)
        ])
        authenticatingLabel.textAlignment = .center
        authenticatingLabel.text = "Authenticating......"
        authenticatingLabel.font.withSize(50)
    }
    
    private func handleLogin(){
        if let token = KeychainManager.getToken() {
            DispatchQueue.main.async {
                let vc = DashboardVC()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            DispatchQueue.main.async {
                let vc = SigninVC()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
