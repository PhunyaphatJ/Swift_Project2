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
class Employee{
    static private var count:Int = 0
    var id:Int
    var name:String
    var age:Int?
    var salary:Double

    init(name:String,age:Int?,salary:Double){
        Employee.count += 1
        self.id = Employee.count
        self.name = name
        self.age = age
        self.salary = salary
    }

    convenience init(name:String,salary:Double){
        self.init(name:name,age:nil,salary:salary)
    }

    func show(){
        print("ID: \(id) name: \(name) age: \(age != nil ? "\(age!)" : "nil") salary: \(salary)")
    }
}

class Programmer:Employee{
    static private var count:Int = 0 
    
}