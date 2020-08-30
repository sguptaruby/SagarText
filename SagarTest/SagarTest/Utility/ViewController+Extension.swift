





import UIKit
import MBProgressHUD


extension UIViewController {
    
    /// Shows Darlingo progress view
    internal func showHUD() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }
    
    /// Hides Darlingo progress view
    internal func hideHUD() {
        MBProgressHUD.hide(for: self.view, animated: false)
    }
    
    internal func showAlert(title:String,message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}

