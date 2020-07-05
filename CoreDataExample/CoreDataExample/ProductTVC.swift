
import UIKit

protocol CustomCellDelegate:class {
    func incButtonTapped(cell:ProductTVC, didTappedThe button:UIButton?)
    func decButtonTapped(cell:ProductTVC, didTappedThe button:UIButton?)
}
 

class ProductTVC: UITableViewCell {

     //MARK:- Outlets
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var productQtyLabel: UILabel!
    @IBOutlet weak var decBtnOutlet: UIButton!
    @IBOutlet weak var incBtnOutlet: UIButton!
    
    var buttonTag = 0
    weak var cellDelegate:CustomCellDelegate?

    
     //MARK:- Object Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    @IBAction func incAction(_ sender: Any) {
        print("cell inc function")
         cellDelegate?.incButtonTapped(cell: self, didTappedThe: sender as?UIButton)
    }
    
    @IBAction func decAction(_ sender: Any) {
          print("cell decc function")
         cellDelegate?.decButtonTapped(cell: self, didTappedThe: sender as?UIButton)
    }
    
       
    
}
