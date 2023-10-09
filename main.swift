import Foundation;

//class
class Company{
    static var id = 0
    var employees = Store<Employee>()
    var shops = Store<Shop>()

    var countEmployee:Int{employees.count}

    func addEmployee(employee:Employee){
        employees.add(item: employee)
    }

    func addShop(shop:Shop){
        shops.add(item: shop)
    }

    func getShopByID(id:Int)->Shop?{
        return shops.searchID(id: id)
    }

    func search(id:Int)->Employee?{
        return employees.searchID(id: id)
    }

    func show(){
        employees.show()
    }

    func searchName(name:String,password:String) -> Employee?{
      if let employee = employees.searchName(name: name) {
            if employee.checkPassword(password:password){
                return employee
            }
        }
        return nil
    }

}


class Person{
    var name:String
    var age:Int?

    init(name:String,age:Int?){
        self.name = name
        self.age = age
    }

    func show(){
        print("name:\(name) age\(age ?? 0)")
    }
}


class Employee:Person{
    var id:Int
    var salary:Double
    var isManager:Bool
    var password:String

    init(name:String,age:Int?,salary:Double,isManager:Bool,password:String){
        Company.id += 1
        self.id = Company.id
        self.salary = salary
        self.isManager = isManager
        self.password = password
        super.init(name: name, age: age)
    }


    convenience init(name:String,salary:Double,password:String){
        self.init(name:name,age:nil,salary:salary,isManager: false,password: password)
    }

    override func show(){
        print("ID: \(id) name: \(name) age: \(age != nil ? "\(age!)" : "nil") salary: \(salary)")
    }

    func checkPassword(password:String) -> Bool{
        if password == self.password{
            return true
        }
        return false
    }
}

class Seller:Employee{
    let departmentID = 10
    // var customers:[Customer] = []

    override init(name:String,age:Int?,salary:Double,isManager:Bool,password:String){
        super.init(name: name, age: age, salary: salary,isManager: isManager,password: password)
    }

}

class IT:Employee{
    let departmentID = 20

    override init(name:String,age:Int?,salary:Double,isManager:Bool,password:String){
        super.init(name: name, age: age, salary: salary, isManager: isManager,password: password)
    }
    
}

class Account:Employee{
    let departmentID = 30

    override init(name:String,age:Int?,salary:Double,isManager:Bool,password:String){
        super.init(name: name, age: age, salary: salary, isManager: isManager,password: password)
    }
}


class Order{
    static private var count = 0
    var orderID:Int
    var custID:Int
    var orderDetails:[(product:Product,quantity:Int,total:Double)] = []
    var total:Double{
        return orderDetails.reduce(0) {(result,item)in
            return result + (Double(item.quantity) * item.product.price)
        }
    }   

    init(custID:Int){
        Order.count += 1
        self.orderID = Order.count
        self.custID = custID
    }


    func buy(item:Product,quantity:Int){
        if let index = orderDetails.firstIndex(where: {$0.product.productID == item.productID}){
            orderDetails[index].quantity += quantity
            orderDetails[index].total += (item.price * Double(quantity))
            item.quantity -= quantity
        }else{
            orderDetails.append((product:item,quantity:quantity,total:item.price * Double(quantity)))
            item.quantity -= quantity
        }
    }

    func searchByCustomerID(id:Int) -> Bool{
        if custID == id{
            return true
        }
        return false
    }

    func show(){
        let pOrderID = "\(orderID)".padding(toLength: 37, withPad: " ", startingAt: 0)
        print("============================================")
        print("|".padding(toLength: 4, withPad: " ", startingAt: 0),pOrderID,"|")
        print("--------------------------------------------")
        for item in orderDetails{
            let space1 = "".padding(toLength: 4, withPad: " ", startingAt: 0)
            let pID = "\(space1)\(item.product.productID)".padding(toLength: 10, withPad: " ", startingAt: 0)
            let pQuantity = "\(space1)\(item.quantity)".padding(toLength: 10, withPad: " ", startingAt: 0)
            let pTotal = "\(space1)\(item.total)".padding(toLength: 9, withPad: " ", startingAt: 0)
            print("|\(space1)\(space1) | \(pID)|\(pQuantity)|\(pTotal)|")
            print("--------------------------------------------")
        }
        let pTotal = "\(total)".padding(toLength: 20, withPad: " ", startingAt: 0)
        print("                               total: \(pTotal)")
        print("============================================")
    }
    
}

class Category{
    static private var count = 0
    let categoryID:Int
    var categoryName:String

    init(name:String){
        Category.count += 1
        self.categoryID = Category.count
        self.categoryName = name
    }

    func show(){
        print("ID: \(categoryID) Name: \(categoryName)")
    }
}

class Product{
    static private var count = 0
    let productID:Int
    var categoryID:Int
    var name:String
    var quantity:Int
    var price:Double


    init(name:String,quantity:Int,price:Double,categoID:Int){
        Product.count += 1
        self.productID = Product.count
        self.categoryID = categoID
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


    func show(){
       let pID = "\(productID)".padding(toLength: 4, withPad: " ", startingAt: 0)
       let pName = name.padding(toLength: 10, withPad: " ", startingAt: 0)
       let pQuantity = "\(quantity)".padding(toLength: 14, withPad: " ", startingAt: 0)
       let pPrice = "\(price)".padding(toLength: 9, withPad: " ", startingAt: 0)
       print("|\(pID)|\(pName)|\(pQuantity)|\(pPrice)|")
       print("------------------------------------------")
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
                product.show()
            }else if let order = item as? Order{
                print("custID ",order.custID,"orderID ",order.orderID)
                order.show()
                return
            }else if let employee = item as? Employee{
                print(employee.id)
            }else if let customer = item as? Shop.Customer{
                print("ID: \(customer.custID) Name: \(customer.name)")
            }else if let category = item as? Category{
                category.show()
            }
        }
    }

    func searchID(id:Int)->T?{
        for item in items{
            if let product = item as? Product,product.productID == id{
                return product as? T
            }else if let order = item as? Order,order.orderID == id{
                return order as? T
            }else if let employee = item as? Employee,employee.id == id{
                return employee as? T
            }else if let customer = item as? Shop.Customer,customer.custID == id{
                return customer as? T
            }else if let shop = item as? Shop,shop.shopID == id{
                return shop as? T
            }
        }
        return nil
    }
   

   func searchName(name:String) ->T?{
        for item in items{
            if let employeeName = item as? Employee,employeeName.name == name{
                return employeeName as? T
            }else if let custName = item as? Shop.Customer,custName.name == name{
                return custName as? T
            }else if let order = item as? Order,company.getShopByID(id: 1)?.customers.searchID(id: order.custID)?.name == name{
                return order as? T
            }
        }
        return nil
   }
 
    func getAllItems()->[T]{
        return items
    }

}

class Shop{
    static var count = 0
    let shopID :Int
    var products = Store<Product>()
    var customers = Store<Customer>()
    var orders = Store<Order>()
    
    init(){
        Shop.count += 1
        self.shopID = Shop.count
    }

    func buy(order:Order,customer:Customer){
        while true{
            do{
                system("clear")
                order.show()
                let total = order.total * (1 - (customer.member.discount))
                if customer.member == .member{
                    print("Your Member")
                    print("Discount 4%")
                }else{
                    print("Your not a Member")
                    print("Discount 2%")
                }
                print("Total Price : \(total)")
                print("Enter Your Money :",terminator: "")
                    if let money = Double(readLine()!){
                        if money < total{
                            throw BuyError.insuffcient(moneyNeeded: total - money)
                        }else{
                            orders.add(item: order)
                            print("thank you for buying..")
                            let change = money - total
                            pauseFunc(text: "\(change == 0 ? "" : "change : \(change)")")
                            customerMainPage()
                        }
                    }else{
                        pauseFunc(text: "money must be Double")
                    }
            }catch BuyError.insuffcient(let moneyNeeded){
                pauseFunc(text: "not enough money Please add more money : \(moneyNeeded)")
                continue
            }catch{
                print("some error")
            }
        }
    }

    enum BuyError:Error{
        case insuffcient(moneyNeeded:Double)
    }

    class Customer:Person{
        static private var count = 0
        let custID:Int
        var password:String
        var member:Tier
        // var orders:[Orders] = []

        init(name:String,age:Int,password:String){
            Customer.count += 1
            custID = Customer.count
            self.password = password
            self.member = Tier.standard
            super.init(name: name, age: age)
        }

        func checkPassword(pass:String) -> Bool{
            if password == pass{
                return true
            }
            return false
        }

        func rankUp(){
            member = .member
        }

        static func customerShowHead(){
            print("+-----------------------------------------+")
            print("|   ID   |      Name      |     Member    |")
            print("+-----------------------------------------+")
        }

        override func show(){
            let space1 = "".padding(toLength: 3, withPad: " ", startingAt: 0)
            let space2 = "".padding(toLength: 4, withPad: " ", startingAt: 0)
            let space3 = "".padding(toLength: 4, withPad: " ", startingAt: 0)
            let id = "\(custID)".padding(toLength: 5, withPad: " ", startingAt: 0)
            let nameP = "\(name)".padding(toLength: 12, withPad: " ", startingAt: 0)
            let memberP = "\(member)".padding(toLength: 11, withPad: " ", startingAt: 0)
            print("|\(space1)\(id)|\(space2)\(nameP)|\(space3)\(memberP)|")
        }
    }

    enum Tier:Int{
        case standard = 0,member = 1
         var discount:Double{
            switch self{
                case .standard:
                    return 0.02
                case .member:
                    return 0.04
            }
        }

    }
}


//categories
var categoires = Store<Category>()
categoires.add(item: Category(name: "Food"))
categoires.add(item: Category(name:"Snack"))
categoires.add(item: Category(name: "Electronic"))

//company
let company = Company()
company.addEmployee(employee: Seller(name: "Seller Manger", age: 30, salary: 50000,isManager: true,password: "1234"))
company.addEmployee(employee: Seller(name: "Seller1", age: 30, salary: 25000,isManager: false,password: "4321"))
company.addEmployee(employee: Employee(name: "Admin", salary: 30000, password: "1234"))


company.addShop(shop: Shop())
//add Products
company.getShopByID(id: 1)?.products.add(item: Product(name:"Candy1",quantity:100,price:10,categoID: 2))
company.getShopByID(id: 1)?.products.add(item: Product(name:"Candy2",quantity:200,price:50,categoID: 2))

//add Orders
let defaultProduct = Product(name: "default", quantity: 0, price: 0, categoID: 0)

let order1 = Order(custID: 1)
order1.buy(item: company.getShopByID(id: 1)?.products.searchID(id: 1) ?? defaultProduct, quantity: 10)
order1.buy(item: company.getShopByID(id: 1)?.products.searchID(id: 2) ?? defaultProduct, quantity: 5)
let order2 = Order(custID: 2)
order2.buy(item: company.getShopByID(id: 1)?.products.searchID(id: 2) ?? defaultProduct, quantity: 15)
order2.buy(item: company.getShopByID(id: 1)?.products.searchID(id: 1) ?? defaultProduct, quantity: 10)
company.getShopByID(id: 1)?.orders.add(item: order1)
company.getShopByID(id: 1)?.orders.add(item: order2)

//add Customers
company.getShopByID(id: 1)?.customers.add(item: Shop.Customer(name: "Customer1", age: 22, password: "1234"))
company.getShopByID(id: 1)?.customers.add(item: Shop.Customer(name: "Customer2", age: 32, password: "4321"))
company.getShopByID(id: 1)?.customers.searchID(id: 1)?.rankUp()
//end data store

//func 
func showOrderByCustID(orders:[Order],id:Int){
  for order in orders{
    if order.searchByCustomerID(id:id){
        order.show()
    }
  }
}

func showAll<T>(items:[T]){
    switch items{
        case is [Product]:
            print("+----------------------------------------+")
            print("| ID |   Name   |   Quantity   |  Price  |")
            print("+----------------------------------------+")
        case is [Order]:
            print("+------------------------------------------+")
            print("| OrderID | ProductID | Quantity |  Price  |")
            print("+-----------------------------------------+")
        case is [Shop.Customer]:
            Shop.Customer.customerShowHead()
        default:
            print("wrong")
    }

    for item in items{
        if let product = item as? Product{
            product.show()
        }else if let order = item as? Order{
            order.show()
        }else if let customer = item as? Shop.Customer{
            customer.show()
        }else if let employee = item as? Employee{
            employee.show()
        }
    }
    print("+-----------------------------------------+")
}



//func page
func pauseFunc(text:String){
    print(text,terminator:"")
    _ = readLine()
}

func firstPage(){
    while true{
        system("clear")
        print("1.For Employee")
        print("2.For Customer")
        if let input = readLine(){
            switch input{
                case "1":
                    employeePage()
                case "2":
                    logAndRegisPage()
                default:
                    pauseFunc(text: "wrong input please try again..")
                    continue
            }
        }
    }
}

func employeePage(){
    while true{
        system("clear")
        print("1.For Admin")
        print("2.For Seller")
        if let input = readLine(){
            switch input{
                case "1":
                    loginAdmin()
                case "2":
                    loginSeller()
                default:
                    pauseFunc(text: "wrong input please try again..")
                    continue
            }
        }
    }
}

func loginAdmin(){
    var counter = 0
     while true{
        system("clear")
        print("+-----------------+")
        print("|      Login      |")
        print("+-----------------+")
        print("Enter User: ",terminator: "")
        if let userName = readLine(){
            print("Enter password:",terminator: "")
            if let password = readLine(){
                if let user = company.searchName(name: userName, password: password){
                    if user.name == "Admin" && user.checkPassword(password: password){
                        pauseFunc(text: "login successful..")
                        adminMainPage()
                    }else{
                        pauseFunc(text: "incorrect user or password..")
                    }
                }else{
                    pauseFunc(text: "incorrect user or password..")
                 }
                }
            }
            counter += 1
            if counter == 3{
                firstPage()
        }
    }
}

func adminMainPage(){
    while true{
        system("clear")
        print("1.Add new Employee")
        print("2.")
        print("3.Show Employee")
        print("--------------------")
        print("Enter : ",terminator: "")
        if let input = readLine(){
            switch input{
                case "1":
                    addEmployeePage()
                case "2":
                    print("2222")
                case "3":
                    showEmployeePage()
                default:
                    pauseFunc(text: "wrong input please try again..")
            }
        }
    }
}

func addEmployeePage(){
    while true{
        print("Enter Name : ",terminator: "")
        if let name = readLine(){
            print("Enter Age : ",terminator: "")
            if let age = Int(readLine()!){
                print("Enter Salary : ",terminator: "")
                if let salary = Double(readLine()!){
                    if let password = readLine(){
                        addEmployee(name: name, age: age, salary: salary, password: password)
                    }
                }else{
                    pauseFunc(text: "salary Must be Double")
                }
            }else{
                pauseFunc(text: "age must be Int")
            }
        }
    }
}

func addEmployee(name:String,age:Int?,salary:Double,password:String){
    while true{
        print("Select Dapartment : ",terminator: "")
        print("1.Seller")
        print("2.IT")
        print("3.Accounter")
        if let input = readLine(){
            switch input{
                case "1":
                    company.addEmployee(employee: Seller(name: name, age: age, salary: salary, isManager: false, password: password))
                    adminMainPage()
                case "2":
                    company.addEmployee(employee: IT(name: name, age: age, salary: salary, isManager: false, password: password))
                    adminMainPage()
                case "3":
                    company.addEmployee(employee: Account(name: name, age: age, salary: salary, isManager: false, password: password))
                    adminMainPage()
                default:
                    pauseFunc(text: "wrong input please try again..")
            }
        }
    }
}

func showEmployeePage(){
    while true{
        print("1.Show All")
        print("2.Show By ID")
        print("3.Show By Name")
        print("----------------")
        print("Enter : ",terminator: "")
        if let input = readLine(){
            switch input{
                case "1":
                    showAll(items: company.employees.getAllItems())
                    pauseFunc(text: "")
                case "2":
                    print("by id")
                case "3":
                    print("by Name")
                default:
                    pauseFunc(text: "wrong input please try again..")
            }
        }
    }
}

var sellerNow:Seller?
func loginSeller(){
    var counter = 0
     while true{
        system("clear")
        print("+-----------------+")
        print("|      Login      |")
        print("+-----------------+")
        print("Enter User: ",terminator: "")
        if let userName = readLine(){
            print("Enter password:",terminator: "")
            if let password = readLine(){
                if let user = company.searchName(name: userName, password: password){
                    sellerNow = user as? Seller
                    pauseFunc(text: "login successful..")
                    sellerMainPage()
                    break
                }else{
                    pauseFunc(text: "incorrect user or password..")
                 }
                }
            }
            counter += 1
            if counter == 3{
                firstPage()
        }
    }
}

func logoutSeller(){
    sellerNow = nil
    firstPage()
}

func sellerMainPage(){
    while true{
        system("clear")
        print("1.Add New Product")
        print("2.Restock")
        print("3.Check Products")
        print("4.Show Order")
        print("5.Show Customers")
        print("6.Subscribe")
        print("7.Logout")
        print("------------------------------")
        print("Enter : ",terminator: "")
        if let input = readLine(){
            switch input{
                case "1":
                    addNewPage()
                case "2":
                    restockPage()
                case "3":
                    showAll(items: company.getShopByID(id: 1)!.products.getAllItems())
                    pauseFunc(text: "")
                case "4":
                    showOrderPage()
                case "5":
                    showCustomerPage()
                case "6":
                    toMembershipPage()
                case "7":
                    logoutSeller()
                default:
                    pauseFunc(text: "wrong input please try again..")
            }
        }
    }
}

func addNewPage(){
    while true{
        system("clear")
        print("Do you want to add new Product (Y:N) : ",terminator: "")
        if let input = readLine(){
            switch input{
                case "y","Y":
                    addProduct()
                case "n","N":
                    sellerMainPage()
                default:
                    pauseFunc(text: "wrong input please try again...")
            }
        }
    }
}

func addProduct(){
    while true{
        system("clear")
        print("Category ID : ",terminator: "")
        if let category = Int(readLine()!){
            print("Name : ",terminator: "")
            if let name = readLine(){
                print("Quantity : ",terminator: "")
                if let quantity = Int(readLine()!){
                    print("Price : ",terminator: "")
                    if let price = Double(readLine()!){
                        company.getShopByID(id: 1)!.products.add(item: Product(name: name, quantity: quantity, price: price, categoID: category))
                        pauseFunc(text: "completed..")
                        print("Do you want to Add (Y:N) : ",terminator: "")
                        if let input = readLine(){
                            switch input{
                                case "Y","y":
                                    continue
                                default:
                                    sellerMainPage()
                            }
                        }
                    }else{
                        pauseFunc(text: "price must be Double")
                    }
                }else{
                    pauseFunc(text: "quantity must be Int")
                }
            }
        }else{
            pauseFunc(text: "category must be Int")
        }
    }
}

func restockPage(){
    while true{
        system("clear")
        print("Do You want to Restock (Y:N) : ",terminator: "")
        if let input = readLine(){
            switch input{
                case "Y","y":
                    restock()
                case "N","n":
                    sellerMainPage()
                default:
                    pauseFunc(text: "wrong input please try again..")
            }
        }
    }
}

func restock(){
    while true{
        var copyProducts = company.getShopByID(id: 1)!.products.getAllItems()
        copyProducts.sort(by: {$0.quantity < $1.quantity})
        showAll(items: copyProducts)
        print("")
        print("Product ID : ",terminator: "")
        if let id = Int(readLine()!){
            if let product = company.getShopByID(id: 1)!.products.searchID(id: id){
                print("Quantity : ",terminator: "")
                if let quantity = Int(readLine()!){
                    product.add(quantity: quantity)
                    pauseFunc(text: "complete..")
                    sellerMainPage()
                }else{
                    pauseFunc(text: "Quantity must be Int..")
                }
            }else{
                pauseFunc(text: "not found this ID..")
            }
        }else{
            pauseFunc(text: "ID must be Int..")
        }
    }
}

func showOrderPage(){
    while true{
        system("clear")
        print("1.Show All")
        print("2.Show By Order ID")
        print("3.Show By Customer Name")
        print("4.Exit")
        print("Enter : ",terminator: "")
        if let input = readLine(){
            switch input{
                case "1":
                    showAll(items: company.getShopByID(id: 1)!.orders.getAllItems())
                    pauseFunc(text: "")
                case "2":
                    searchByIDPage()
                case "3":
                    searchNamePage()
                case "4":
                    sellerMainPage()
                default:
                    pauseFunc(text: "wrong input please try again..")
            }
        }
    }
}

func searchByIDPage(){
    var counter = 0
    while true{
        print("ID : ",terminator: "")
        if let id = Int(readLine()!){
            if let order = company.getShopByID(id: 1)!.orders.searchID(id: id){
                order.show()
                print("Do you want to search again (Y:N) : ",terminator: "")
                if let input = readLine(){
                    switch input{
                        case "Y","y":
                            continue
                        default:
                            showOrderPage()
                    }
                }
            }else{
                pauseFunc(text: "not found this id")
                counter += 1
                if counter == 3 {break}
            }
        }else{
            pauseFunc(text: "wrong input please try again..")
        }
    }
}

func searchNamePage(){
    var counter = 0
       while true{
        print("Name : ",terminator: "")
        if let name = readLine(){
            if let order = company.getShopByID(id: 1)!.orders.searchName(name: name){
                order.show()
                print("Do you want to search again (Y:N) : ",terminator: "")
                if let input = readLine(){
                    switch input{
                        case "Y","y":
                            continue
                        default:
                            showOrderPage()
                    }
                }
            }else{
                pauseFunc(text: "not found this Name")
                 counter += 1
                if counter == 3 {break}
            }
        }
    }
}

func showCustomerPage(){
    while true{
        system("clear")
        print("1.Show All")
        print("2.Show By ID")
        print("3.Show By Name")
        print("4.Exit")
        print("------------------------------")
        print("Enter : ",terminator: "")
        if let input = readLine(){
            switch input{
                case "1":
                    showAll(items: company.getShopByID(id: 1)!.customers.getAllItems())
                    pauseFunc(text: "")
                case "2":
                    showCustomerByID()
                case "3":
                    showCustomerByName()
                case "4":
                    sellerMainPage()
                default:
                    pauseFunc(text: "wrong input please try again..")
            } 

        }

    }
}

func showCustomerByID(){
    while true{
        print("Do you want to Search (Y:N): ",terminator: "")
        if let input = readLine(){
            switch input{
                case "Y","y":
                    print("Enter ID : ",terminator: "")
                    if let id = Int(readLine()!){
                        if let user = company.getShopByID(id: 1)!.customers.searchID(id: id){
                            Shop.Customer.customerShowHead()
                            user.show()
                            print("-------------------------------------------")
                        }else{
                            pauseFunc(text: "not found this id")
                        }
                    }else{
                        pauseFunc(text: "id must be Int")
                    }
                case "N","n":
                    showCustomerPage()
                default:
                    pauseFunc(text: "wrong input please try again..")
            }
        }
    }
}

func showCustomerByName(){
    while true{
        print("Do you want to Search (Y:N): ",terminator: "")
        if let input = readLine(){
            switch input{
                case "Y","y":
                    print("Enter Name : ",terminator: "")
                    if let name = readLine(){
                        if let user = company.getShopByID(id: 1)!.customers.searchName(name: name){
                            Shop.Customer.customerShowHead()
                            user.show()
                            print("-------------------------------------------")
                        }else{
                            pauseFunc(text: "not found this id")
                        }
                    }else{
                        pauseFunc(text: "id must be Int")
                    }
                case "N","n":
                    showCustomerPage()
                default:
                    pauseFunc(text: "wrong input please try again..")
            }
        }
    }
}

func toMembershipPage(){
    while true{
        system("clear")
        print("Enter (Y:N) : ",terminator: "")
        if let input = readLine(){
            switch input{
                case "Y","y":
                    toMembership()
                case "N","n":
                    sellerMainPage()
                default:
                    pauseFunc(text: "wrong input please try again")
            }
        }
    }
}

func toMembership(){
    while true{
        print("Enter ID : ",terminator: "")
        if let id = Int(readLine()!){
            if let customer = company.getShopByID(id: 1)?.customers.searchID(id: id){
                customer.rankUp()
                pauseFunc(text: "complete..")
                toMembershipPage()
            }else{
                pauseFunc(text: "not found this id")
            }
        }else{
            pauseFunc(text: "id must be int")
        }
    }
}

//Customer Page

func shopping(){
    buy: while true {
    system("clear")
    print("enter y/n : ")
    if let input = readLine() {
        switch input {
        case "Y", "y":
                    let order = Order(custID: customerNow?.custID ?? 0)
                    loopBuy:repeat{
                        //show all Products
                        system("clear")
                        showAll(items: company.getShopByID(id: 1)!.products.getAllItems())
                        print("Enter product ID:",terminator: "")
                        if let productID = Int(readLine()!) {
                            if let product = company.getShopByID(id: 1)!.products.searchID(id: productID) {
                                if product.checkQuantity(){
                                    print("Enter Quantity: ",terminator: "")
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
                                    company.getShopByID(id: 1)!.buy(order: order,customer: customerNow!)
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
}


func logAndRegisPage(){
    while true{
        system("clear")
        print("1.Login")
        print("2.Register")
        if let input = readLine(){
            switch input{
                case "1":
                    loginCustomer()
                case "2":
                    register()
                default:
                    pauseFunc(text: "wrong input please try again..")
            }
        }
    }
}
var customerNow:Shop.Customer?
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
            if let user = company.getShopByID(id: 1)!.customers.searchName(name: userName){
                print("Enter password:",terminator: "")
                if let password = readLine(){
                    if user.checkPassword(pass: password){
                        customerNow = user
                        pauseFunc(text: "login successful..")
                        customerMainPage()
                        sellerMainPage()
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

func register(){
    register:while true{
        print("Enter Name: ",terminator: "")
        if let name = readLine(){
            print("Enter Age: ",terminator: "")
            if let age = Int(readLine()!){
                print("Enter Password: ",terminator: "")
                if let password = readLine(){
                    print("Name: \(name) age: \(age) Is this correct? (Y:N) : ",terminator: "")
                    if let input = readLine(){
                        switch input{
                            case "Y","y":
                                company.getShopByID(id: 1)!.customers.add(item: Shop.Customer(name: name, age: age, password: password))
                                pauseFunc(text: "register complete")
                                logAndRegisPage()
                            case "N","n":
                                continue register
                            default:
                                 pauseFunc(text: "wrong input please try again..")
                        }
                    }
                }
            }else{
                pauseFunc(text: "age must be Int")
            }
        }
    }
}


func registerPage(){
    while true{
        system("clear")
        print("+-----------------+")
        print("|     register    |")
        print("+-----------------+")
        print("Do you want to register (Y:N) : ",terminator: "")
        if let input = readLine(){
            switch input{
                case "Y","y":
                    register()
                case "N","n":
                    logAndRegisPage()
                default:
                    pauseFunc(text: "wrong input please try again..") 
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
                    print("Orders #\(customerNow?.custID ?? 0)")
                    showOrderByCustID(orders: company.getShopByID(id: 1)!.orders.getAllItems(), id: customerNow?.custID ?? 0)
                    pauseFunc(text: "")
                case "3":
                    customerNow?.show()
                    pauseFunc(text: "")
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