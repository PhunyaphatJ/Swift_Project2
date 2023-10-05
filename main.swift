import Foundation;

//data store
struct Queue{
    var items:[Any] = []
    var count:Int {items.count}

    mutating func enqueue(item:Any){
        items.append(item)
    }
    
    mutating func dequeue()->Any{
        items.removeFirst()
    }

}


//class
class Person{
    var name:String
    var age:Int?

    init(name:String,age:Int?){
        self.name = name
        self.age = age
    }
}


class Employee:Person{
    static private var count:Int = 0
    var id:Int
    var salary:Double

    init(name:String,age:Int?,salary:Double){
        Employee.count += 1
        self.id = Employee.count
        self.salary = salary
        super.init(name: name, age: age)
    }


    convenience init(name:String,salary:Double){
        self.init(name:name,age:nil,salary:salary)
    }

    func show(){
        print("ID: \(id) name: \(name) age: \(age != nil ? "\(age!)" : "nil") salary: \(salary)")
    }
}

// class Programmer:Employee{
//     static private var count:Int = 0 
    
// }

class Seller:Employee{

    var customers:[Customer] = []


    override init(name:String,age:Int?,salary:Double){
        super.init(name: name, age: age, salary: salary)
    }

}


class Customer:Person{
    static private var count = 0
    let cust_id:Int
    // var orders:[Orders] = []

    init(name:String,age:Int){
        Customer.count += 1
        cust_id = Customer.count
        super.init(name: name, age: age)
    }
    
}

struct Order{
    static private var count = 0
    var order_id:Int
    var cust_id:Int
    var orderDetails
    
}