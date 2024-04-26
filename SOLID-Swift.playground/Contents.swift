import UIKit


print("-------- Single responsibility principle ----------")

/*

 Single responsible
 */


struct Product {
    let price: Double
}

struct Invoice {
    let products: [Product]
    let id = NSUUID().uuidString
    var discountPrecentage: Double = 0

    var total: Double {
        var total = products.map{ $0.price }.reduce(0, {$0 + $1})
        let discountAmount = total * (discountPrecentage / 100)
        return total - discountAmount
    }

    func printInvoice() {
        let printer = InvoicePrinter(invoice: self)
        printer.printInvoice()
    }

    func saveInvoice() {
        let persistance = InvoicePersistance(invoice: self)
        persistance.saveInvoice()
    }

}

struct InvoicePersistance {

    var invoice: Invoice
    
    func saveInvoice() {
        print("Save to data base")
    }

}

struct InvoicePrinter {

    var invoice : Invoice


    func printInvoice() {
        print("------------------------")
        print("Invoice ID : \(invoice.id)")
        print("Total Cost $\(invoice.total)")
        print("Dscounts: \(invoice.discountPrecentage)")

        print("------------------------")
    }
}

let products : [Product] = [.init(price: 99.99), .init(price: 9.99), .init(price: 24.99)]
let invoice = Invoice(products: products)
invoice.printInvoice()
invoice.saveInvoice()

print("-------- Open/Closed Principle ----------")

/*
 Open/Closed Principle

 Note ->>>>> Software entities(classes, modules, functions) should be open for extentions, But close for modificatons.
 In Other words, we can add addional functionality(extention) without touching the existing code(modification) of an object
 */

extension Int {

    func squared() -> Int {
        return self * self
    }

}

var num = 2
num.squared()

protocol InvoicePersistancable {
    func save(invoice: Invoice)
}

struct InvoicePersistableOCP {

    let persistance: InvoicePersistancable

    func save(invoice: Invoice) {
        persistance.save(invoice: invoice)
    }
}

struct CoreDataPersistance: InvoicePersistancable {

    func save(invoice: Invoice) {
        print("Invoice ID \(invoice.id)")
    }


}

struct DatabasePeristance: InvoicePersistancable {

    func save(invoice: Invoice) {
        print("Invoice ID for database \(invoice.id)")
    }

}

let saveInvoiceToDatabase = DatabasePeristance()
let databasePersistance = InvoicePersistableOCP(persistance: saveInvoiceToDatabase)
databasePersistance.save(invoice: invoice)



print("-------- Liskov Substitution Principle (LSP) ----------")

/*
 Notes ---> Derived or child classess/structures must be subsititutable for their base or parent classes
 */


enum APIError: Error {
    case invalidURL
    case invalidResponse
    case invalidStatusCode
}

struct MockUserService {

    func fetchUser() async throws {
        do {
            throw APIError.invalidResponse
        } catch {
            print("Error : \(error)")
        }
    }
}

let mockService = MockUserService()
Task { try await mockService.fetchUser() }

print("-------- Interface segregation principle (ISP) ----------")
/*
 Notes ---> Do not force any client to implement an interface which is irrelevent to them
 */

protocol DoubleTapProtocol {
    func doubleTap()
}

protocol SingleTapProtocol {
    func singleTap()
}

protocol LongTapProtocol {
    func longTap()
}

struct SuperButton : DoubleTapProtocol, SingleTapProtocol, LongTapProtocol {
    func doubleTap() {
        print("Double Tap")
    }
    
    func singleTap() {
        print("Single Tap")
    }
    
    func longTap() {
        print("long Tap")
    }
}

struct SingleTapButton: SingleTapProtocol {
    func singleTap() {
        print("Single Tap Protocol")
    }

}

let mySuperButton = SuperButton()
mySuperButton.longTap()

let singleButton = SingleTapButton()
singleButton.singleTap()

print("-------- Dependency Inversion Principle (DIP) ----------")
/*
 Notes ---> High Level modules should not depend on low-level modules, but should depend on abstraction
            If a high level module imports any low-level module then the code becomes the tightly coupled
            Change in one class could break another class
 */


protocol PaymentMethod {

    func excute(amount: Double)
}

struct DebitCardPayment : PaymentMethod {

    func excute(amount: Double) {
        print("Payment success for Debit Card \(amount)")
    }

}

struct ApplePayment : PaymentMethod {

    func excute(amount: Double) {
        print("Payment success for Apple Card \(amount)")
    }
}

struct StripePayment : PaymentMethod {

    func excute(amount: Double) {
        print("Payment success for Stripe Card \(amount)")
    }
}

struct PaymentDIP {

    var payment: PaymentMethod

    func makePayment(amount: Double) {
        payment.excute(amount: amount)
    }
}

let applePayPaymentMethod = ApplePayment()

let applePay = PaymentDIP(payment: applePayPaymentMethod)
applePay.makePayment(amount: 200)


