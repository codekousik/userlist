
import Foundation

struct ModelUser: Decodable {

    // MARK: - Types
    
    private enum CodingKeys: String, CodingKey {
        
        // MARK: - Cases
        
        case title = "login"
        case imageUrl = "avatar_url"
        
    }
    
    // MARK: - Properties
    
    let title: String
    
    // MARK: -
    
    let imageUrl: URL
    
}
