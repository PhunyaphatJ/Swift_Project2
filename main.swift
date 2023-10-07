import Foundation;

//class
class Company{
    static var id = 0
    var employees = Store<Employee>()
    var countEmployee:Int{employees.count}

    func addEmployee(employee:Employee){
        employees.add(item: employee)
    }

    func search(id:Int)->Employee?{
        return employees.searchID(id: id)
    }

    func show(){
        employees.show()
    }
}


class Person{
    var name:String
    var age:Int?

    init(name:String,age:Int?){
        self.name = name
        self.age = age
    }
}


class Employee:Person{
    var id:Int
    var salary:Double
    var isManager:Bool

    init(name:String,age:Int?,salary:Double,isManager:Bool){
        Company.id += 1
        self.id = Company.id
        self.salary = salary
        self.isManager = isManager
        super.init(name: name, age: age)
    }


    convenience init(name:String,salary:Double){
        self.init(name:name,age:nil,salary:salary,isManager: false)
    }

    func show(){
        print("ID: \(id) name: \(name) age: \(age != nil ? "\(age!)" : "nil") salary: \(salary)")
    }
}

class Seller:Employee{
    let departmentID = 10
    var customers:[Customer] = []


    override init(name:String,age:Int?,salary:Double,isManager:Bool){
        super.init(name: name, age: age, salary: salary,isManager: isManager)
    }

}

class IT:Employee{
    let departmentID = 20

    override init(name:String,age:Int?,salary:Double,isManager:Bool){
        super.init(name: name, age: age, salary: salary, isManager: isManager)
    }
    
}

class Account:Employee{
    let departmentID = 30

    override init(name:String,age:Int?,salary:Double,isManager:Bool){
        super.init(name: name, age: age, salary: salary, isManager: isManager)
    }
}



class Customer:Person{
    static private var count = 0
    let cust_id:Int
    var password:String
    // var orders:[Orders] = []

    init(name:String,age:Int,password:String){
        Customer.count += 1
        cust_id = Customer.count
        self.password = password
        super.init(name: name, age: age)
    }

     func checkPassword(pass:String) -> Bool{
        if password == pass{
            return true
        }
        return false
   }
    
}

class Order{
    static private var count = 0
    var order_id:Int
    var cust_id:Int
    var orderDetails:[(product:Product,quantity:Int,total:Double)] = []
    var total:Double{
        return orderDetails.reduce(0) {(result,item)in
            return result + (Double(item.quantity) * item.product.price)
        }
}

    init(cust_id:Int){
        Order.count += 1
        self.order_id = Order.count
        self.cust_id = cust_id
    }

    func buy(item:Product,quantity:Int){
        if let index = orderDetails.firstIndex(where: {$0.product.product_id == item.product_id}){
            orderDetails[index].quantity += quantity
            orderDetails[index].total += (item.price * Double(quantity))
            item.quantity -= quantity
        }else{
            orderDetails.append((product:item,quantity:quantity,total:item.price * Double(quantity)))
            item.quantity -= quantity
        }
    }

    func searchByCustomerID(id:Int) -> Bool{
        if cust_id == id{
            return true
        }
        return false
    }

    func show(){
        print("Order id\(order_id)")
        for item in orderDetails{
            print("id: \(item.product.product_id) quantity : \(item.quantity) price: \(item.total)")
        }
        print("total: \(total)")
    }
    
}

class Product{
    static private var count = 0
    let product_id:Int
    var name:String
    var quantity:Int
    var price:Double


    init(name:String,quantity:Int,price:Double){
        Product.count += 1
        self.product_id = Product.count
        self.name = name
        self.quantity = quantity
        self.price = price
    }

    func add(quantity:Int){
        if quantity < 0{
            return
        }
        self.quantity += quantity
    }

    func reduce(quantity:Int){
        if quantity < 0{
            return
        }
        self.quantity -= quantity
    }

    func checkQuantity()->Bool{
        if quantity == 0{
            return false
        }
        return true
    }

}

//end class & struct

//data store
struct Store<T>{
    var items:[T] = []
    var count:Int {items.count}

    mutating func add(item:T){
        items.append(item)
    }
    
    // mutating func remove()->T{
    //     return items
    // }

    func show(){
        for item in items{
            if let product = item as? Product{
                print(product.name,product.quantity)
            }else if let order = item as? Order{
                print("cust_ID ",order.cust_id,"order_id ",order.order_id)
                order.show()
                return
            }else if let employee = item as? Employee{
                print(employee.id)
            }else if let customer = item as? Customer{
                print("ID: \(customer.cust_id) Name: \(customer.name)")
            }
        }
    }

    func searchID(id:Int)->T?{
        for item in items{
            if let product = item as? Product,product.product_id == id{
                return product as? T
            }else if let order = item as? Order,order.order_id == id{
                return order as? T
            }else if let employee = item as? Employee,employee.id == id{
                return employee as? T
            }else if let customer = item as? Customer,customer.cust_id == id{
                return customer as? T
            }
        }
        return nil
    }
   

   func searchName(name:String) ->T?{
        for item in items{
            if let employeeName = item as? Employee,employeeName.name == name{
                return employeeName as? T
            }else if let custName = item as? Customer,custName.name == name{
                return custName as? T
            }
        }
        return nil
   }
 
    func getAllItems()->[T]{
        return items
    }

}


//product
var products = Store<Product>()
products.add(item: Product(name:"product1",quantity:10,price:10))
products.add(item: Product(name: "product2", quantity: 20, price: 50))

//customers
var customers = Store<Customer>()
customers.add(item: Customer(name: "Customer1", age: 20,password: "1234"))
customers.add(item: Customer(name: "Customer2", age: 22,password: "555"))

//orders
var orders = Store<Order>()

//test
// Test loop


//end test

//company
let company = Company()
company.addEmployee(employee: Seller(name: "Seller Manger", age: 30, salary: 50000,isManager: true))
company.addEmployee(employee: Seller(name: "seller1", age: 30, salary: 25000,isManager: false))

//end data store

//func 
func showOrderByCustID(orders:[Order],id:Int){
  for order in orders{
    if order.searchByCustomerID(id:id){
        order.show()
    }
  }
}



//func page
func pauseFunc(text:String){
    print(text,terminator:"")
    _ = readLine()
}

var customerNow:Customer?
var employeeNow:Employee?

func loginCustomer(){
    var counter = 0
     while true{
        system("clear")
        print("+-----------------+")
        print("|      Login      |")
        print("+-----------------+")
        print("Enter User: ",terminator: "")
        if let userName = readLine(){
            if let user = customers.searchName(name: userName){
                print("Enter password:",terminator: "")
                if let password = readLine(){
                    if user.checkPassword(pass: password){
                        customerNow = user
                        pauseFunc(text: "login successful")
                        customerMainPage()
                        break
                    }else{
                        pauseFunc(text: "incorrect password..")
                    }
                }
            }else{
                pauseFunc(text: "incorrect user..")
            }
        }
        counter += 1
        if counter == 3{
            firstPage()
        }
     }
}

func logoutCustomer(){
    customerNow = nil
    firstPage()
}


func shopping(){
    buy: while true {
    print("enter y/n : ")
    if let input = readLine() {
        switch input {
        case "Y", "y":
                    let order = Order(cust_id: customerNow?.cust_id ?? 0)
                    loopBuy:repeat{
                        print("Enter product ID:")
                        if let productID = Int(readLine()!) {
                            if let product = products.searchID(id: productID) {
                                if product.checkQuantity(){
                                    print(product.quantity)
                                    print("Enter Quantity: ")
                                    if let quantity = Int(readLine()!){
                                        if quantity <= product.quantity{
                                            order.buy(item: product, quantity: quantity)
                                        }else{
                                            print("input quantity > prodcut quantity")
                                        }
                                    }else{
                                        print("worng input")
                                    }
                                }else{
                                    print("product quantity is empty")
                                    continue loopBuy
                                }
                            } else {
                                print("Product not found")
                            }
                        } else {
                            print("Invalid input for product ID")
                        }
                        checkCon:while true{
                            print("Continue Shopping? Y/N: ")
                            if let continueShop = readLine(){
                                switch continueShop {
                                case "y","Y":
                                    continue loopBuy
                                case "n","N":
                                    orders.add(item: order)
                                    break buy
                                default:
                                    print("wrong input")
                                    continue checkCon
                                }
                            }
                        }
                    }while true
        case "N", "n":
            break buy
        default:
            print("wrong")
        }
    } else {
        print("wrong")
    }
}
    orders.show()
}


func firstPage(){
    while true{
        system("clear")
        print("1.For Seller")
        print("2.For Customer")
        if let input = readLine(){
            switch input{
                case "1":
                    print("seller")
                case "2":
                    loginCustomer()
                default:
                    pauseFunc(text: "wrong input please try again..")
                    continue
            }
        }
    }

}

func customerMainPage(){
    while true{
        system("clear")
        print("1.Buy")
        print("2.My Orders")
        print("3.My Profile")
        print("4.Logout")
        if let input = readLine(){
            switch input{
                case "1":
                    shopping()
                case "2":
                    print("Orders #\(customerNow?.cust_id ?? 0)")
                    showOrderByCustID(orders: orders.getAllItems(), id: customerNow?.cust_id ?? 0)
                    pauseFunc(text: "")
                case "3":
                    print("My Profile")
                case "4":
                    logoutCustomer()
                default:
                    pauseFunc(text: "wrong input please try again..")
            }
        }
    }
}
//


func main(){
  
    firstPage()
}

main()