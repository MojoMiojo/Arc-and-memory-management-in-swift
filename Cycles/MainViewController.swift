/// Copyright (c) 2019 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

//MARK: MainViewController Class
class MainViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    runScenario()
  }
  
  func  runScenario () {
    let user =  User (name: "John" )
    let iPhone =  Phone (model: "iPhone Xs" )
    let subscription : CarrierSubscription
    let greetingMaker: () -> String
    let mermaid: WWDCGreeting
    
    user.add(phone: iPhone)
    
    subscription = CarrierSubscription(
      name: "TelBel",
      countryCode: "0032",
      number: "31415926",
      user: user)
    
    mermaid = WWDCGreeting(who: "caffeinated mermaid")
    
    iPhone.provision(carrierSubscription: subscription)
    print(subscription.completePhoneNumber())

    greetingMaker = mermaid.greetingMaker

    print(greetingMaker()) // TRAP!
  }// end runScenario
  
}// end MainViewController class

//MARK: User Class
class User {
  let name: String
  private(set)  var phones: [Phone] = []
  var subscriptions: [CarrierSubscription] = []
  
  func add(phone: Phone) {
    phones.append(phone)
    phone.owner = self
  }
  
  init(name: String) {
    self.name = name
    print("User \(name) was initialized")
  }
  
  deinit {
    print("Deallocating user named: \(name)")
  }
}

//MARK: Phone Class
class  Phone {
  let model: String
  weak var owner: User?
  
  var carrierSubscription: CarrierSubscription?
  
  func provision(carrierSubscription: CarrierSubscription) {
    self.carrierSubscription = carrierSubscription
  }
  
  func decommission() {
    carrierSubscription = nil
  }
  
  init ( model : String ) {
    self .model = model
    print ( "Phone \(model) was initialized" )
  }
  
  deinit {
    print ( "Deallocating phone named: \(model) " )
  }
}

//MARK: CarrierSubscription Class
class CarrierSubscription {
  let name: String
  let countryCode: String
  let number: String
  unowned let user: User
  
  lazy var completePhoneNumber: () -> String = { [unowned self] in
    self.countryCode + " " + self.number
  }
  
  init(name: String, countryCode: String, number: String, user: User) {
    self.name = name
    self.countryCode = countryCode
    self.number = number
    self.user = user
    user.subscriptions.append(self)
    print("CarrierSubscription \(name) is initialized")
  }
  
  deinit {
    print("Deallocating CarrierSubscription named: \(name)")
  }
}

//MARK: WWDCGreeting Class
class WWDCGreeting {
  let who: String
  
  init(who: String) {
    self.who = who
    print("WWDCGreeting \(who) is initialized")
  }

  lazy var greetingMaker: () -> String = { [weak self] in
    guard let self = self else {
      return "No greeting available."
    }
    return "Hello \(self.who)."
  }
  
  deinit {
    print("Deallocating WWDCGreeting named: \(who)")
  }
}
