import UIKit

private enum DealsSortedType {
    case date
    case instrument
    case price
    case amount
    case side
}

final class ViewController: UIViewController {
    
    // MARK: Private property
    
    private let server = Server()
    private var model: [Deal] = []
    private var currentDealSortedType: DealsSortedType = .date
    private var isInstrumentSelected = false
    private var isPriceSelected = false
    private var isAmountSelected = false
    private var isSideSelected = false
    
    
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
}


// MARK: Private methods

private
extension ViewController {
    func getDataFromServer() {
        let queue = DispatchQueue(label: "GetDeals", attributes: .concurrent)
        server.subscribeToDeals { [weak self] deals in
            guard let self else { return }
            queue.async(flags: .barrier) {
                self.model.append(contentsOf: deals)
                self.sortedData(mode: self.currentDealSortedType)
            }
        }
    }
    
    func setupUI() {
        navigationItem.title = "Deals"
        settingsTableView()
        settingsStackView()
        configureButtons()
    }
    
    func sortedData(mode: DealsSortedType) {
        switch mode {
            case .date:
                model.sort() {$0.dateModifier < $1.dateModifier}
                
            case .instrument:
                if isInstrumentSelected {
                    model.sort() { $0.instrumentName < $1.instrumentName}
                } else {
                    model.sort() { $0.instrumentName > $1.instrumentName}
                }
                
            case .price:
                if isPriceSelected {
                    model.sort() {$0.price < $1.price}
                } else {
                    model.sort() {$0.price > $1.price}
                }
                
            case .amount:
                if isAmountSelected {
                    model.sort() {$0.amount < $1.amount}
                } else {
                    model.sort() {$0.amount > $1.amount}
                }
                
            case .side:
                if isSideSelected {
                    model = model.filter({ $0.side == .sell }) + model.filter({ $0.side == .buy})
                } else {
                    model = model.filter({ $0.side == .buy }) + model.filter({ $0.side == .sell})
                }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func settingsTableView() {
        tableView.register(UINib(nibName: DealCell.reuseIdentifier, bundle: nil),
                           forCellReuseIdentifier: DealCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func settingsStackView() {
        topButtonsStackView.addArrangedSubview(instrumentSortButton)
        topButtonsStackView.addArrangedSubview(priceSortButton)
        topButtonsStackView.addArrangedSubview(amountSortButton)
        topButtonsStackView.addArrangedSubview(sideSortButton)
    }
    
    func configureButtons() {
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
}


// MARK: Actions

private
extension ViewController {
    @objc
    func pressedInstrumentBtn() {
        configureButtons()
        currentDealSortedType = .instrument
        isInstrumentSelected.toggle()
        if isInstrumentSelected {
            instrumentSortButton.setTitle("⬇️Instrument", for: .normal)
        } else {
            instrumentSortButton.setTitle("⬆️Instrument", for: .normal)
        }
    }
    
    @objc
    func pressedPriceBtn() {
        configureButtons()
        currentDealSortedType = .price
        isPriceSelected.toggle()
        if isPriceSelected {
            priceSortButton.setTitle("⬆️Price", for: .normal)
        } else {
            priceSortButton.setTitle("⬇️Price", for: .normal)
        }
    }
    
    @objc
    func pressedAmountBtn() {
        configureButtons()
        currentDealSortedType = .amount
        isAmountSelected.toggle()
        if isAmountSelected {
            amountSortButton.setTitle("⬆️Amount", for: .normal)
        } else {
            amountSortButton.setTitle("⬇️Amount", for: .normal)
        }
    }
    
    @objc
    func pressedSideBtn() {
        configureButtons()
        currentDealSortedType = .side
        isSideSelected.toggle()
        if isSideSelected {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: DealCell.reuseIdentifier,
                                                 for: indexPath) as? DealCell
        cell?.configure(model: model[indexPath.row])
        return cell ?? UITableViewCell()
    }
}
