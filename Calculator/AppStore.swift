//

import Foundation
import Combine

// This is the store (entry point for this kind of view model)
// It has three published properties (this creates observables
// or publishers, that give you a stream of events whenever value
// have changed.
class AppStore: ObservableObject {
    @Published var x: String = ""
    @Published var y: String = ""
    @Published var result: Double?

    // This maintains the subscriptions.
    private var disposeBag = Set<AnyCancellable>()

    init() {
        // Because you will have a stream of events (the user types in the user interface)
        // then we need to be able to combine these two inputs and turn it into
        // a stream of possible values (optionals).
        // Once we have that optional value going (which we know is not going to fail)
        // then we can perform your calculation as you wanted. The calculation
        // as such doesn't need to be a class, I made it a struct
        // just to demostrate, but it could've easily be just a func without any parent
        // struct holding in place. A more complex logic might require different func composition.
        Publishers
            .CombineLatest($x, $y) // combining the two inputs
            .map({ (Double($0.0), Double($0.1)) }) // turn it into doubles (maybe)
            .map({ inputs -> (Double, Double)? in // we turn the two possible values into a single possible value
                let (x, y) = inputs
                return x.flatMap({ a in
                    y.map({ (a, $0 ) })
                })
            })
            .map({ $0.map(Calculator.calculateTuple) }) // then we turn that possible value into a calculation (maybe)
            .assign(to: \AppStore.result, on: self) // and assign it back to the result to be published.
            .store(in: &disposeBag)
    }

    deinit {
        disposeBag.removeAll() // this keeps subscriptions from firing once the object is no longer required.
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
