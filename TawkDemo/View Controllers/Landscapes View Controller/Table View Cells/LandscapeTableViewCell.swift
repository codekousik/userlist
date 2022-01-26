

import UIKit

final class LandscapeTableViewCell: UITableViewCell {

    // MARK: - Static Properties
    
    static var reuseIdentifier: String {
        String(describing: self)
    }
    
    @IBOutlet weak var imgBackgroundVw: UIImageView!
    // MARK: - Properties
    
    @IBOutlet private var titleLabel: UILabel!
    
    // MARK: -
    
    @IBOutlet private var thumbnailImageView: UIImageView! {
        didSet {
            // Configure Thumbnail Image View
            thumbnailImageView.contentMode = .scaleAspectFill
        }
    }
    
    // MARK: -
    
    @IBOutlet private var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: -
    
    private lazy var imageService = ImageService()
    
    // MARK: -
    
    private var imageRequest: Cancellable?
    
    // MARK: - Public API

    func configure(title: String, imageUrl: URL) {
        // Configure Title Label
        titleLabel.text = title
        
        // Animate Activity Indicator View
        activityIndicatorView.startAnimating()
        
        // Request Image Using Image Service
        imageRequest = imageService.image(for: imageUrl) { [weak self] image in
            // Update Thumbnail Image View
            self?.thumbnailImageView.image = image
        }
    }

    // MARK: - Overrides

    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Reset Thumbnail Image View
        thumbnailImageView.image = nil
        
        // Cancel Image Request
        imageRequest?.cancel()
    }

}
