import UIKit

class DealCell: UITableViewCell {
  static let reuseIidentifier = "DealCell"
  
  @IBOutlet weak var instrumentNameLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var amountLabel: UILabel!
  @IBOutlet weak var sideLabel: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
