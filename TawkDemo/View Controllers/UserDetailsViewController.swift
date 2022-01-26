
import UIKit

class UserDetailsViewController: UIViewController {
    var strUserName:String?
    
    @IBOutlet weak var av: UIActivityIndicatorView!
    @IBOutlet weak var imgUsr: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblLogin: UILabel!
    
    private lazy var imageService = ImageService()
    
    // MARK: -
    
    private var imageRequest: Cancellable?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.fetchUserWith(name: strUserName!)
    }
    private func fetchUserWith(name:String) {
        // Start/Show Activity Indicator View
        av.startAnimating()
        
        let url = URL(string: "https://api.github.com/users/\(name)")!
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data else {
                print("Unable to Fetch fetchUser")
                return
            }
            
            do {
                // Decode Response
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    
                  print(" Response: \(string)")

                }
                //let landscapes = try JSONDecoder().decode([ModelUser].self, from: data)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.mutableContainers ) as! NSDictionary

                // Update Data Source and
                // User Interface on Main Thread
                DispatchQueue.main.async {
                    
                    self?.updateUIWith(dic: jsonResult)
                    
                    // Stop/Hide Activity Indicator View
                    self?.av.stopAnimating()
                }
            } catch {
                print("Unable to Decode fetchUser")
            }
        }.resume()
    }
    func updateUIWith(dic:NSDictionary) {
        
        if let nm = dic["login"] as? String{
            self.lblName.text = nm
        }
        if let nm = dic["login"] as? String{
            self.lblName.text = nm
        }
        if let avatr = dic["avatar_url"] as? String{
            // Request Image Using Image Service
            
            imageRequest = imageService.image(for: URL(string: avatr)!) { [weak self] image in
                // Update Thumbnail Image View
                self?.imgUsr.image = image
            }
        }
    }

}
