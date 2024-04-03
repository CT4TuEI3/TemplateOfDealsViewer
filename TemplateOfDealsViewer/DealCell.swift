import UIKit

final class DealCell: UITableViewCell {
    static let reuseIdentifier = "DealCell"
    
    // MARK: UI elements
    
    @IBOutlet weak var instrumentNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var sideLabel: UILabel!
    
    
    // MARK: Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLabels()
    }
    
    
    // MARK: Configure
    
    func configure(model: Deal) {
        self.instrumentNameLabel.text = model.instrumentName
        self.priceLabel.text = String(roundDouble(a: model.price))
        self.amountLabel.text = String(roundAmount(a: model.amount))
        self.sideLabel.text = putSideToString(side: model.side)
        self.priceLabel.textColor = textColor(side: model.side)
    }
    
    
    // MARK: Private methods
    
    private func configureLabels() {
        instrumentNameLabel.adjustsFontSizeToFitWidth = true
        instrumentNameLabel.minimumScaleFactor = 0.5
        
        amountLabel.adjustsFontSizeToFitWidth = true
        amountLabel.minimumScaleFactor = 0.5
    }
    
    private func roundDouble(a: Double) -> Double {
        round(a * 100) / 100.0
    }
    
    private func roundAmount(a: Double) -> Int {
        Int(round(a * 1) / 1)
    }
    
    private func putSideToString(side: Deal.Side) -> String {
        side == .buy ? "Buy" : "Sell"
    }
    
    private func textColor(side: Deal.Side) -> UIColor {
        side == .buy ? .systemGreen : .systemRed
    }
}
