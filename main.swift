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
    var customers:[Customer] = []

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



class Customer:Person{
    static private var count = 0
    let custID:Int
    var password:String
    // var orders:[Orders] = []

    init(name:String,age:Int,password:String){
        Customer.count += 1
        custID = Customer.count
        self.password = password
        super.init(name: name, age: age)
    }

     func checkPassword(pass:String) -> Bool{
        if password == pass{
            return true
        }
        return false
   }

    override func show(){
        print("ID: \(custID) name: \(name) age: \(age ?? 0)")
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
        print("Order id\(orderID)")
        for item in orderDetails{
            print("id: \(item.product.productID) quantity : \(item.quantity) price: \(item.total)")
        }
        print("total: \(total)")
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
            }else if let customer = item as? Customer{
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
            }else if let customer = item as? Customer,customer.custID == id{
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

//categories
var categoires = Store<Category>()
categoires.add(item: Category(name: "Food"))
categoires.add(item: Category(name:"Snack"))
categoires.add(item: Category(name: "Electronic"))

//products
var products = Store<Product>()
products.add(item: Product(name:"Candy1",quantity:10,price:10,categoID: 2))
products.add(item: Product(name: "Candy2", quantity: 20, price: 50,categoID: 2))

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
company.addEmployee(employee: Seller(name: "Seller Manger", age: 30, salary: 50000,isManager: true,password: "1234"))
company.addEmployee(employee: Seller(name: "Seller1", age: 30, salary: 25000,isManager: false,password: "4321"))
company.addEmployee(employee: Employee(name: "Admin", salary: 30000, password: "1234"))

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
        print("------------------------------------------")
        default:
            print("wrong")
    }

    for item in items{
        if let product = item as? Product{
            product.show()
        }
    }
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
    print("admin Main")
    pauseFunc(text: "asdf")
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
        print("4.Logout")
        if let input = readLine(){
            switch input{
                case "1":
                    addNewPage()
                case "2":
                    restock()
                case "3":
                    showAll(items: products.getAllItems())
                    pauseFunc(text: "")
                case "4":
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
                        products.add(item: Product(name: name, quantity: quantity, price: price, categoID: category))
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
        var copyProducts = products.getAllItems()
        copyProducts.sort(by: {$0.quantity < $1.quantity})
        showAll(items: copyProducts)
        print("Product ID : ",terminator: "")
        if let id = Int(readLine()!){
            if let product = products.searchID(id: id){
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

//Customer Page

func shopping(){
    buy: while true {
    print("enter y/n : ")
    if let input = readLine() {
        switch input {
        case "Y", "y":
                    let order = Order(custID: customerNow?.custID ?? 0)
                    loopBuy:repeat{
                        //show all Products
                        showAll(items: products.getAllItems())
                        print("Enter product ID:")
                        if let productID = Int(readLine()!) {
                            if let product = products.searchID(id: productID) {
                                if product.checkQuantity(){
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
                                customers.add(item: Customer(name: name, age: age, password: password))
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
                    showOrderByCustID(orders: orders.getAllItems(), id: customerNow?.custID ?? 0)
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