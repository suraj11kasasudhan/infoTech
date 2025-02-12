//
//  LoginModel.swift
//  InfoTechAssignment
//
//  Created by Suraj on 11/02/25.
//


struct User: Codable {
    let id: String?
    let name: String?
    let avatar: String?
    let token: String?
    let email: String?
    let password: String?
    let dateOfBirth: String?
    let gender: String?
    let createdAt: String?
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try? container.decodeIfPresent(String.self, forKey: .id)
        self.name = try? container.decodeIfPresent(String.self, forKey: .name)
        self.avatar = try? container.decodeIfPresent(String.self, forKey: .avatar)
        self.token = try? container.decodeIfPresent(String.self, forKey: .token)
        self.email = try? container.decodeIfPresent(String.self, forKey: .email)
        self.password = try? container.decodeIfPresent(String.self, forKey: .password)
        self.dateOfBirth = try? container.decodeIfPresent(String.self, forKey: .dateOfBirth)
        self.gender = try? container.decodeIfPresent(String.self, forKey: .gender)
        self.createdAt = try? container.decodeIfPresent(String.self, forKey: .createdAt)
    }
}

enum LoginFlowEndPoint{
    case signup
    case signin
    
    var rawValue:String{
        switch self {
        case .signup:
            return "https://67ab92bd5853dfff53d7ea13.mockapi.io/user"
            
        case .signin:
            return "https://67ab92bd5853dfff53d7ea13.mockapi.io/user"
            
        }
    }
}
