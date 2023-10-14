import Foundation;

//class
class Company{
    static var id = 0
    var employees:[Employee] = []
    var shops:[Shop] = []

    var countEmployee:Int{employees.count}

    func addEmployee(employee:Employee){
        employees.append(employee)
    }

    func addShop(shop:Shop){
        shops.append(shop)
    }

    func getShopById(id:Int)->Shop?{
        return shops[id - 1]
    }

    func getEmployeeById(id:Int)->Employee?{
        return employees[id - 1]
    }

    func getEmployeeByName(name:String)->Employee?{
        for employee in employees{
            if employee.name == name{
                return employee
            }
        }
        return nil
    }

    func login(user:String,password:String)->Employee?{
        for employee in employees{
            if employee.login(user: user, password: password){
                return employee
            }
        }
        return nil
    }

    func show(){
        Employee.showAll(employees: employees)
    }

}


class Person{
    var name:String {
        willSet{
            print("will set name : \(newValue)")
        }

        didSet{
            print("before : \(oldValue) after : \(name)")
        }
    }
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
    var departmentID:Int{
        return 0
    }
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

    func login(user:String,password:String)->Bool{
        if name == user && self.password == password{
            return true
        }
        return false
    }

    static func employeeShowhead(){
            print("+------------------------------------------------------------------------------+")
            print("|  ID  |         Name         |  age  |   salary  |   Manager  |   Department  |")
            print("+------------------------------------------------------------------------------+")
    }

    static func getEmployeeByName(employees:[Employee],name:String)->Employee?{
        for employee in employees{
            if employee.name == name{
                return employee
            }
        }
        return nil
    }


    static func showAll(employees:[Employee]){
        for employee in employees{
            employee.show()
        }
    }

    override func show(){ 
        let space1 = "".padding(toLength: 2, withPad: " ", startingAt: 0)
        let idP = "\(id)".padding(toLength: 4, withPad: " ", startingAt: 0)
        let space2 = "".padding(toLength: 5, withPad: " ", startingAt: 0)
        let nameP = "\(name)".padding(toLength: 17, withPad: " ", startingAt: 0)
        let space3 = "".padding(toLength: 3, withPad: " ", startingAt: 0)
        let ageP = "\(age != nil ? "\(age!)" : "nil")".padding(toLength: 4, withPad: " ", startingAt: 0)
        let space4 = "".padding(toLength: 3, withPad: " ", startingAt: 0)
        let salaryP = "\(salary)".padding(toLength: 8, withPad: " ", startingAt: 0)
        let space5 = "".padding(toLength: 6, withPad: " ", startingAt: 0)
        let managerP = "\(isManager ? "✓" : "x")".padding(toLength: 6, withPad: " ", startingAt: 0)
        print("|\(space1)\(idP)|\(space2)\(nameP)|\(space3)\(ageP)|\(space4)\(salaryP)|\(space5)\(managerP)|",terminator: "")
    }

    func checkPassword(password:String) -> Bool{
        if password == self.password{
            return true
        }
        return false
    }

    func checkDepartmentID(id:Int) -> Bool{
        if departmentID == id{
            return true
        }
        return false
    }

    func getEmployeeByName(name:String)->Employee?{
        if self.name == name{
            return self
        }
        return nil
    }
}

class Seller:Employee{
    override var departmentID:Int {10}
    static var countSeller = 0

    override init(name:String,age:Int?,salary:Double,isManager:Bool,password:String){
        Seller.countSeller += 1
        super.init(name: name, age: age, salary: salary,isManager: isManager,password: password)
    }

    override func show(){
        super.show()
        let space = "".padding(toLength: 3, withPad: " ", startingAt: 0)
        let sellerP = "Seller".padding(toLength: 10, withPad: " ", startingAt: 0)
        print(space,sellerP,"|")
    }

}

class IT:Employee{
    override var departmentID:Int{20}
    static var countIT = 0

    override init(name:String,age:Int?,salary:Double,isManager:Bool,password:String){
        IT.countIT += 1
        super.init(name: name, age: age, salary: salary, isManager: isManager,password: password)
    }

    override func show(){
        super.show()
        let space = "".padding(toLength: 3, withPad: " ", startingAt: 0)
        let sellerP = "IT".padding(toLength: 10, withPad: " ", startingAt: 0)
        print(space,sellerP,"|")
    }
    
}

class Account:Employee{
    override var departmentID:Int{30}
    static var countAccount = 0

    override init(name:String,age:Int?,salary:Double,isManager:Bool,password:String){
        Account.countAccount += 1
        super.init(name: name, age: age, salary: salary, isManager: isManager,password: password)
    }

      override func show(){
        super.show()
        let space = "".padding(toLength: 3, withPad: " ", startingAt: 0)
        let sellerP = "Accounter".padding(toLength: 10, withPad: " ", startingAt: 0)
        print(space,sellerP,"|")
    }
}


class Order{
    static private var count = 0
    var orderID:Int
    var custID:Int
    var orderDetails:[(product:Product,quantity:Int,total:Double)] = []
    var total:Double{
        return orderDetails.reduce(0) {(result,item)in
            return result + (Double(item.quantity) * item.product.priceTax)
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
            orderDetails[index].total += (item.priceTax * Double(quantity))
            item.quantity -= quantity
        }else{
            orderDetails.append((product:item,quantity:quantity,total:item.priceTax * Double(quantity)))
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
            let pTotal = "\(space1)\(String(format: "%.2f",item.total))".padding(toLength: 9, withPad: " ", startingAt: 0)
            print("|\(space1)\(space1) | \(pID)|\(pQuantity)|\(pTotal)|")
            print("--------------------------------------------")
        }
        let pTotal = "\(String(format: "%.2f",total))".padding(toLength: 20, withPad: " ", startingAt: 0)
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
    var priceTax:Double{
        get{price * (1 + 0.07)}
        set{price = newValue / (1 + 0.07)}
    }


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

    static func getProductById(products:[Product],id:Int)->Product?{
        for product in products{
            if product.productID == id{
                return product
            }
        }
        return nil
    }


    func show(){
       let pID = "\(productID)".padding(toLength: 4, withPad: " ", startingAt: 0)
       let pName = name.padding(toLength: 10, withPad: " ", startingAt: 0)
       let pQuantity = "\(quantity)".padding(toLength: 14, withPad: " ", startingAt: 0)
       let pPrice = "\(String(format: "%.2f",priceTax))".padding(toLength: 9, withPad: " ", startingAt: 0)
       print("|\(pID)|\(pName)|\(pQuantity)|\(pPrice)|")
       print("------------------------------------------")
    }
}

//end class & struct


class Shop{
    static var count = 0
    let shopID :Int
    var name:String
    // var products = Store<Product>()
    var products:[Product] = []
    var customers:[Customer] = []
    var orders:[Order] = []
    
    init(name:String){
        Shop.count += 1
        self.shopID = Shop.count
        self.name = name
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
                print("Total Price : \(String(format: "%.2f",total))")
                print("Enter Your Money :",terminator: "")
                    if let money = Double(readLine()!){
                        if money < total{
                            throw BuyError.insuffcient(moneyNeeded: total - money)
                        }else{
                            orders.append(order)
                            print("thank you for buying..")
                            let change = money - total
                            pauseFunc(text: "\(change == 0 ? "" : "change : \(String(format: "%.2f",change))")")
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

    func getCustomerById(id:Int)->Customer?{
            for customer in self.customers{
                if customer.searchId(id: id) != nil{
                    return customer
                }
            }
            return nil
    }

    func getCustomerByName(name:String)->Customer?{
        for customer in customers{
          if customer.name == name{
            return customer
          }
       }
       return nil
    }

    func getOrderById(id:Int)->Order?{
        for order in orders{
            if order.orderID == id{
                return order
            }
        }
        return nil
    }

    func getOrderByCustName(name:String)->Order?{
       if let customer = self.getCustomerByName(name: name){
            for order in orders{
                if order.custID == customer.custID{
                    return order
                }
            }
       }
       return nil
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

        func searchId(id:Int)->Customer?{
            if custID == id{
                return self
            }
            return nil
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
var categoires:[Category] = []
categoires.append(Category(name: "Food"))
categoires.append(Category(name:"Snack"))
categoires.append(Category(name: "Electronic"))

//company
let company = Company()
company.addEmployee(employee: Seller(name: "Seller Manger", age: 30, salary: 50000,isManager: true,password: "1234"))
company.addEmployee(employee: Seller(name: "Seller1", age: 30, salary: 25000,isManager: false,password: "4321"))
company.addEmployee(employee: IT(name: "Admin", salary: 30000, password: "1234"))
company.addEmployee(employee: IT(name: "IT Manager", age: 40, salary: 50000, isManager: true, password: "7777"))
company.addEmployee(employee: IT(name: "IT1", age: 25, salary: 25000, isManager: false, password: "1111"))
company.addEmployee(employee: Account(name: "Account Manager", age: 50, salary: 60000, isManager: true, password: "abcde"))
company.addEmployee(employee: Account(name: "Account1", age: 30, salary: 30000, isManager: false, password: "jaja"))


company.addShop(shop: Shop(name: "Shop1"))
//add Products
company.getShopById(id: 1)?.products.append(Product(name:"Candy1",quantity:100,price:10,categoID: 2))
company.getShopById(id: 1)?.products.append(Product(name:"Candy2",quantity:200,price:50,categoID: 2))

//add Orders
let defaultProduct = Product(name: "default", quantity: 0, price: 0, categoID: 0)
let order1 = Order(custID: 1)
let order2 = Order(custID: 2)
if let product = company.getShopById(id: 1)?.products,let productId1 = Product.getProductById(products: product, id: 1){
    order1.buy(item: productId1 , quantity: 10)
    order2.buy(item: productId1, quantity: 15)
    order2.buy(item: productId1, quantity: 10)
}
if let product = company.getShopById(id: 1)?.products,let productId2 = Product.getProductById(products: product, id: 2){
    order1.buy(item: productId2 , quantity: 5)
}
company.getShopById(id: 1)?.orders.append(order1)
company.getShopById(id: 1)?.orders.append(order2)

//add Customers
company.getShopById(id: 1)?.customers.append(Shop.Customer(name: "Customer1", age: 22, password: "1234"))
company.getShopById(id: 1)?.customers.append(Shop.Customer(name: "Customer2", age: 32, password: "4321"))
company.getShopById(id: 1)?.getCustomerById(id: 1)?.rankUp()

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
        case is [Employee]:
            Employee.employeeShowhead()
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
    switch items{
        case is [Employee]:
            print("+------------------------------------------------------------------------------+")
        case is [Shop.Customer]:
            print("+-----------------------------------------+")
        default:
            print("")
    }
}


func showByDepartment(employees:[Employee],id:Int){
    Employee.employeeShowhead()
    for employee in employees{
        if employee.checkDepartmentID(id: id){
            employee.show()
        }
    }
    print("+------------------------------------------------------------------------------+")
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
                if let user = company.login(user: userName, password: password){
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
        print("2.Dapartment")
        print("3.Show Employee")
        print("4.Change Information")
        print("5.logout")
        print("--------------------")
        print("Enter : ",terminator: "")
        if let input = readLine(){
            switch input{
                case "1":
                    addEmployeePage()
                case "2":
                    departmentPage()
                case "3":
                    showEmployeePage()
                case "4":
                    changeInfoPage()
                case "5":
                    firstPage()
                default:
                    pauseFunc(text: "wrong input please try again..")
            }
        }
    }
}

func addEmployeePage(){
    while true{
        system("clear")
        print("Enter Name : ",terminator: "")
        if let name = readLine(){
            print("Enter Age : ",terminator: "")
            if let age = Int(readLine()!){
                print("Enter Salary : ",terminator: "")
                if let salary = Double(readLine()!){
                    print("Enter Password : ",terminator: "")
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
    loop:while true{
        print("1.Seller")
        print("2.IT")
        print("3.Accounter")
        print("Select Dapartment : ",terminator: "")
        if let input = readLine(){
            switch input{
                case "1":
                    company.addEmployee(employee: Seller(name: name, age: age, salary: salary, isManager: false, password: password))
                case "2":
                    company.addEmployee(employee: IT(name: name, age: age, salary: salary, isManager: false, password: password))
                case "3":
                    company.addEmployee(employee: Account(name: name, age: age, salary: salary, isManager: false, password: password))
                default:
                    pauseFunc(text: "wrong input please try again..")
                    continue loop
            }
            adminMainPage()
        }
    }
}

func departmentPage(){
    while true{
        system("clear")
        print("1.Seller")
        print("2.IT")
        print("3.Account")
        print("4.Exit")
        print("\nEnter : ",terminator: "")
        if let input = readLine(){
            system("clear")
            switch input{
                case "1":
                    print("Seller")
                    print("total Seller : \(Seller.countSeller)")
                    showByDepartment(employees: company.employees, id: 10)
                    pauseFunc(text: "")
                case "2":
                    print("IT")
                    print("total IT : \(IT.countIT)")
                    showByDepartment(employees: company.employees, id: 20)
                    pauseFunc(text: "")
                case "3":
                    print("Account")
                    print("total Accounter : \(Account.countAccount)")
                    showByDepartment(employees: company.employees, id: 30)
                    pauseFunc(text: "")
                case "4":
                    adminMainPage()
                default:
                    pauseFunc(text: "wrong input please try again..")
            }
        }
    }
}

func showEmployeePage(){
    while true{
        system("clear")
        print("1.Show All")
        print("2.Show By ID")
        print("3.Show By Name")
        print("4.Exit")
        print("----------------")
        print("Enter : ",terminator: "")
        if let input = readLine(){
            switch input{
                case "1":
                    showAll(items: company.employees)
                    pauseFunc(text: "")
                    system("clear")
                case "2":
                    employeeShowByIDPage()
                case "3":
                    employeeShowByNamePage()
                case "4":
                    adminMainPage()
                default:
                    pauseFunc(text: "wrong input please try again..")
            }
        }
    }
}

func employeeShowByIDPage(){
    while true{
        system("clear")
        print("Enter ID : ",terminator: "")
        if let id = Int(readLine()!){
            if let employee = company.getEmployeeById(id: id){
                Employee.employeeShowhead()
                employee.show()
                print("+------------------------------------------------------------------------------+")
                pauseFunc(text: "")
                showEmployeePage()
            }else{
                pauseFunc(text: "not found this ID")
            }
        }else{
            pauseFunc(text: "id must be Int")
        }
    }
}

func employeeShowByNamePage(){
     while true{
        system("clear")
        print("Enter Name : ",terminator: "")
        if let name = readLine(){
            if let employee = company.getEmployeeByName(name: name){
                Employee.employeeShowhead()
                employee.show()
                print("+------------------------------------------------------------------------------+")
                pauseFunc(text: "")
                showEmployeePage()
            }else{
                pauseFunc(text: "not found this Name")
            }
        }
    }
}

func changeInfoPage(){
    while true{
        system("clear")
        print("Do you want to change Infomation (Y:N) : ",terminator: "")
        if let input = readLine(){
            switch input{
                case "Y","y":
                    changeName()
                case "N","n":
                    adminMainPage()
                default:
                    pauseFunc(text: "wrong input please try again..")
            }
        }
    }
}

func changeName(){
    while true{
        print("Enter ID : ",terminator: "")
        if let id = Int(readLine()!){
            if let user = company.getEmployeeById(id: id){
                print("Enter Name : ",terminator: "")
                if let name = readLine(){
                    print("Are u ok \(name) (Y:N) : ",terminator: "")
                    if let input = readLine(){
                        switch input{
                            case "Y","y":
                                user.name = name
                                pauseFunc(text: "")
                                adminMainPage()
                            case "N","n":
                                continue
                            default:
                                pauseFunc(text: "wrong input")  
                        }
                    }
                }
            }else{
                pauseFunc(text: "not found this id")
            }
        }else{
            pauseFunc(text: "ID must be Int")
        }
    }
}


//

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
                if let user = company.login(user: userName, password: password){
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
                    showAll(items: company.getShopById(id: 1)!.products)
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
                        company.getShopById(id: 1)!.products.append(Product(name: name, quantity: quantity, price: price, categoID: category))
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
        var copyProducts = company.getShopById(id: 1)!.products
        copyProducts.sort(by: {$0.quantity < $1.quantity})
        showAll(items: copyProducts)
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
        print("")
        print("Product ID : ",terminator: "")
        if let id = Int(readLine()!){
            if let product = Product.getProductById(products: company.getShopById(id: 1)!.products, id: id){
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
                    showAll(items: company.getShopById(id: 1)!.orders)
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
        system("clear")
        print("ID : ",terminator: "")
        if let id = Int(readLine()!){
            if let order = company.getShopById(id: 1)!.getOrderById(id: id){
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
        system("clear")
        print("Name : ",terminator: "")
        if let name = readLine(){
            if let order = company.getShopById(id: 1)!.getOrderByCustName(name: name){
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
                    showAll(items: company.getShopById(id: 1)!.customers)
                    pauseFunc(text: "")
                case "2":
                    showCustomerByID()
                    pauseFunc(text: "")
                case "3":
                    showCustomerByName()
                    pauseFunc(text: "")
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
        system("clear")
        print("Do you want to Search (Y:N): ",terminator: "")
        if let input = readLine(){
            switch input{
                case "Y","y":
                    print("Enter ID : ",terminator: "")
                    if let id = Int(readLine()!){
                        if let customer = company.getShopById(id: 1)!.getCustomerById(id: id){
                            Shop.Customer.customerShowHead()
                            customer.show()
                            pauseFunc(text: "-------------------------------------------")
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
        system("clear")
        print("Do you want to Search (Y:N): ",terminator: "")
        if let input = readLine(){
            switch input{
                case "Y","y":
                    print("Enter Name : ",terminator: "")
                    if let name = readLine(){
                        if let user = company.getShopById(id: 1)!.getCustomerByName(name: name){
                            Shop.Customer.customerShowHead()
                            user.show()
                            pauseFunc(text: "-------------------------------------------")

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
            if let customer = company.getShopById(id: 1)?.getCustomerById(id: id){
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
                        showAll(items: company.getShopById(id: 1)!.products)
                        print("Enter product ID:",terminator: "")
                        if let productID = Int(readLine()!) {
                            if let product = company.getShopById(id: 1)?.products,let thisProduct = Product.getProductById(products: product, id: productID) {
                                if thisProduct.checkQuantity(){
                                    print("Enter Quantity: ",terminator: "")
                                    if let quantity = Int(readLine()!){
                                        if quantity <= thisProduct.quantity{
                                            order.buy(item: thisProduct, quantity: quantity)
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
                                    company.getShopById(id: 1)!.buy(order: order,customer: customerNow!)
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
            if let user = company.getShopById(id: 1)!.getCustomerByName(name: userName){
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
                                company.getShopById(id: 1)!.customers.append(Shop.Customer(name: name, age: age, password: password))
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
                    showOrderByCustID(orders: company.getShopById(id: 1)!.orders, id: customerNow?.custID ?? 0)
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
    // company.getShopById(id: 1)?.products
    firstPage()
}

main()