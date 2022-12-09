import UIKit

class HeaderCell: UITableViewHeaderFooterView {
  static let reuseIidentifier = "HeaderCell"
  
  @IBOutlet weak var instrumentNameTitlLabel: UILabel!
  @IBOutlet weak var priceTitleLabel: UILabel!
  @IBOutlet weak var amountTitleLabel: UILabel!
  @IBOutlet weak var sideTitleLabel: UILabel!
}
