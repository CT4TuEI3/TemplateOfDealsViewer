import UIKit

class ViewController: UIViewController {
    
    private enum DealsSortedType {
        case date
        case instrument
        case price
        case amount
        case side
    }
    
    
    // MARK: Private property
    
    private let server = Server()
    private var model: [Deal] = []
    private var currentDealSorttedType: DealsSortedType = .date
    private var instrumentSelected = false
    private var priceSelected = false
    private var amountSelected = false
    private var sideSelected = false
    
    
    // MARK: UI Elements
    
    @IBOutlet weak var topButtonsStackView: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    private let instrumentSortButton = UIButton()
    private let priceSortButton = UIButton()
    private let amountSortButton = UIButton()
    private let sideSortButton = UIButton()
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromServer()
        setupUI()
    }
    
    
    // MARK: Private methods
    
    private func getDataFromServer() {
        server.subscribeToDeals { deals in
            self.model.append(contentsOf: deals)
            self.sortedData(mode: self.currentDealSorttedType)
            self.tableView.reloadData()
        }
    }
    
    private func setupUI() {
        navigationItem.title = "Deals"
        settingsTableView()
        settingsStackView()
        configureButtons()
    }
    
    private func sortedData(mode: DealsSortedType) {
        switch mode {
            case .date:
                model.sort() {$0.dateModifier < $1.dateModifier}
                
            case .instrument:
                if instrumentSelected {
                    model.sort() { $0.instrumentName < $1.instrumentName}
                } else {
                    model.sort() { $0.instrumentName > $1.instrumentName}
                }
                
            case .price:
                if priceSelected == false {
                    model.sort() {$0.price > $1.price}
                } else {
                    model.sort() {$0.price < $1.price}
                }
                
            case .amount:
                if amountSelected {
                    model.sort() {$0.amount < $1.amount}
                } else {
                    model.sort() {$0.amount > $1.amount}
                }
                
            case .side:
                if sideSelected {
                    model = model.filter({ $0.side == .sell }) + model.filter({ $0.side == .buy})
                } else {
                    model = model.filter({ $0.side == .buy }) + model.filter({ $0.side == .sell})
                }
        }
        tableView.reloadData()
    }
    
    private func settingsTableView() {
        tableView.register(UINib(nibName: DealCell.reuseIidentifier,
                                 bundle: nil),
                           forCellReuseIdentifier: DealCell.reuseIidentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func settingsStackView() {
        topButtonsStackView.addArrangedSubview(instrumentSortButton)
        topButtonsStackView.addArrangedSubview(priceSortButton)
        topButtonsStackView.addArrangedSubview(amountSortButton)
        topButtonsStackView.addArrangedSubview(sideSortButton)
    }
    
    private func configureButtons() {
        instrumentSortButton.backgroundColor = .systemBackground
        instrumentSortButton.setTitle("Instrument", for: .normal)
        instrumentSortButton.setTitleColor(.black, for: .normal)
        instrumentSortButton.titleLabel?.adjustsFontSizeToFitWidth = true
        instrumentSortButton.titleLabel?.font = .systemFont(ofSize: 16)
        instrumentSortButton.addTarget(self, action: #selector(pressedInstrumentBtn), for: .touchUpInside)
        
        priceSortButton.backgroundColor = .systemBackground
        priceSortButton.setTitle("Price", for: .normal)
        priceSortButton.setTitleColor(.black, for: .normal)
        priceSortButton.titleLabel?.adjustsFontSizeToFitWidth = true
        priceSortButton.titleLabel?.font = .systemFont(ofSize: 16)
        priceSortButton.addTarget(self, action: #selector(pressedPriceBtn), for: .touchUpInside)
        
        amountSortButton.backgroundColor = .systemBackground
        amountSortButton.setTitle("Amount", for: .normal)
        amountSortButton.setTitleColor(.black, for: .normal)
        amountSortButton.titleLabel?.adjustsFontSizeToFitWidth = true
        amountSortButton.titleLabel?.font = .systemFont(ofSize: 16)
        amountSortButton.addTarget(self, action: #selector(pressedAmountBtn), for: .touchUpInside)
        
        sideSortButton.backgroundColor = .systemBackground
        sideSortButton.setTitle("Side", for: .normal)
        sideSortButton.setTitleColor(.black, for: .normal)
        sideSortButton.titleLabel?.adjustsFontSizeToFitWidth = true
        sideSortButton.titleLabel?.font = .systemFont(ofSize: 16)
        sideSortButton.addTarget(self, action: #selector(pressedSideBtn), for: .touchUpInside)
    }
    
    
    // MARK: Actions
    
    @objc
    private func pressedInstrumentBtn() {
        configureButtons()
        currentDealSorttedType = .instrument
        instrumentSelected = !instrumentSelected
        if instrumentSelected {
            instrumentSortButton.setTitle("⬇️Instrument", for: .normal)
        } else {
            instrumentSortButton.setTitle("⬆️Instrument", for: .normal)
        }
    }
    
    @objc
    private func pressedPriceBtn() {
        configureButtons()
        currentDealSorttedType = .price
        priceSelected = !priceSelected
        if priceSelected {
            priceSortButton.setTitle("⬇️Price", for: .normal)
        } else {
            priceSortButton.setTitle("⬆️Price", for: .normal)
        }
    }
    
    @objc
    private func pressedAmountBtn() {
        configureButtons()
        currentDealSorttedType = .amount
        amountSelected = !amountSelected
        if amountSelected {
            amountSortButton.setTitle("⬇️Amount", for: .normal)
        } else {
            amountSortButton.setTitle("⬆️Amount", for: .normal)
        }
    }
    
    @objc
    private func pressedSideBtn() {
        configureButtons()
        currentDealSorttedType = .side
        sideSelected = !sideSelected
        if amountSelected {
            sideSortButton.setTitle("⬇️ Side", for: .normal)
        } else {
            sideSortButton.setTitle("⬆️ Side", for: .normal)
        }
    }
}


// MARK: UITableViewDataSource, UITableViewDelegate

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DealCell.reuseIidentifier, for: indexPath) as? DealCell
        cell?.configure(model: model[indexPath.row])
        return cell ?? UITableViewCell()
    }
}
