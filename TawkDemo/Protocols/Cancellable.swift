
import Foundation

protocol Cancellable {

    // MARK: - Methods
    
    func cancel()

}

extension URLSessionTask: Cancellable {
    
}
