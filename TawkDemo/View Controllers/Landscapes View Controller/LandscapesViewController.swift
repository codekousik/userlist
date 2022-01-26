

import UIKit

final class LandscapesViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet private var tableView: UITableView! {
        didSet {
            // Configure Table View
            tableView.isHidden = true
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    @IBOutlet private var activityIndicatorView: UIActivityIndicatorView! {
        didSet {
            // Configure Activity Indicator View
            activityIndicatorView.hidesWhenStopped = true
        }
    }
    
    // MARK: -
    
    private var landscapes: [ModelUser] = [] {
        didSet {
            // Reload Table View
            tableView.reloadData()
            
            // Show/Hide Table View
            tableView.isHidden = landscapes.isEmpty
        }
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch Landscapes
        fetchUser()
    }
    
    // MARK: - Helper Methods
    
    private func fetchUser() {
        // Start/Show Activity Indicator View
        activityIndicatorView.startAnimating()
        
        let url = URL(string: "https://api.github.com/users?since=0")!
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data else {
                print("Unable to Fetch fetchUser")
                return
            }
            
            do {
                // Decode Response
                let landscapes = try JSONDecoder().decode([ModelUser].self, from: data)
                
                // Update Data Source and
                // User Interface on Main Thread
                DispatchQueue.main.async {
                    // Update Landscapes
                    self?.landscapes = landscapes
                    
                    // Stop/Hide Activity Indicator View
                    self?.activityIndicatorView.stopAnimating()
                }
            } catch {
                print("Unable to Decode fetchUser")
            }
        }.resume()
    }

}

extension LandscapesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        landscapes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LandscapeTableViewCell.reuseIdentifier, for: indexPath) as? LandscapeTableViewCell else {
            fatalError("Unable to Dequeue Landscape Table View Cell")
        }
        
        // Fetch Landscape
        let landscape = landscapes[indexPath.row]

        // Configure Cell
        cell.configure(title: landscape.title,
                       imageUrl: landscape.imageUrl)
        
        if (indexPath.row % 4 == 0){
            cell.imgBackgroundVw.backgroundColor = .gray
        }else{
            cell.imgBackgroundVw.backgroundColor = .white

        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
         let next:UserDetailsViewController = storyboard.instantiateViewController(withIdentifier: "UserDetailsViewController") as! UserDetailsViewController
        next.strUserName = landscapes[indexPath.row].title
        next.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(next, animated:false)

    }

}

extension LandscapesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Layout.TableView.rowHeight
    }

}

fileprivate extension LandscapesViewController {

    enum Layout {
        
        enum TableView {
            static let rowHeight: CGFloat = 90.0
        }
        
    }

}
