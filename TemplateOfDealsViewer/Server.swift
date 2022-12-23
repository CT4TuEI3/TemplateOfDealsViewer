import Foundation

final class Server {
  let queue = DispatchQueue(label: "DealsMakeQueue")
  let instrumentNames = [
    "EUR/USD_TOD",
    "GBP/USD_SPOT",
    "USD/JPY_TOM",
    "USD/CHF_SPOT",
    "USD/GBP_SPOT",
    "USD/CAD_TOM",
    "USD/RUB_TOM",
    "EUR/RUB_TOD",
    "CHF/RUB_TOM",
    "USD/AMD_SPOT",
    "EUR/GEL_SPOT",
    "UAH/RUB_SPOT",
    "USD/RUB_ON",
    "EUR/USD_TN"
  ]
  
  func subscribeToDeals(callback: @escaping ([Deal]) -> Void) {
    queue.async {
      var deals: [Deal] = []
      let dealsCount = Int64.random(in: 1_000_000..<1_001_000)
      let dealsCountInPacket = 100
      var j = 0
      for i in 0...dealsCount {
        let currentTimeStamp = Date().timeIntervalSince1970
        let timeStampRandomizer = Double.random(in: 50_000...50_000_000)
        let deal = Deal(
          id: i,
          dateModifier: Date(timeIntervalSince1970: Double.random(in: currentTimeStamp - timeStampRandomizer...currentTimeStamp)),
          instrumentName: self.instrumentNames.shuffled().first!,
          price: Double.random(in: 60...70),
          amount: Double.random(in: 1_000_000...50_000_000),
          side: Deal.Side.allCases.randomElement()!
        )
        deals.append(deal)
        
        j += 1
        
        if j == dealsCountInPacket || i == dealsCount {
          j = 0
          let delay = UInt32.random(in: 0...300_000)
          usleep(delay)
          let newDeals = deals
          DispatchQueue.main.async {
            callback(newDeals)
          }
          deals = []
        }
      }
    }
    
  }
}

struct Deal {
  let id: Int64
  let dateModifier: Date
  let instrumentName: String
  let price: Double
  let amount: Double
  let side: Side
  
  enum Side: CaseIterable {
    case sell, buy
  }
}
