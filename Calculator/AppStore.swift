//

import Foundation
import Combine

class AppStore: ObservableObject {
    @Published var x: String = ""
    @Published var y: String = ""
    @Published var result: Double?

    private var disposeBag = Set<AnyCancellable>()

    init() {
        Publishers
            .CombineLatest($x, $y)
            .map({ (Double($0.0), Double($0.1)) })
            .map({ inputs -> (Double, Double)? in
                let (x, y) = inputs
                return x.flatMap({ a in
                    y.map({ (a, $0 ) })
                })
            })
            .map({ $0.map(Calculator.calculateTuple) })
            .assign(to: \AppStore.result, on: self)
            .store(in: &disposeBag)
    }
}

struct Calculator {
    static func calculate(x: Double, y: Double) -> Double {
        return (3 * x) + y
    }

    static func calculateTuple(input: (Double, Double)) -> Double {
        return calculate(x: input.0, y: input.1)
    }
}
