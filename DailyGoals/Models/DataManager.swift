import Cocoa

protocol DataManagerDelegate {
    func didAddTask(task: Task)
    func didRemoveTask(row: Int)
    func didGetTask(_ data: [Task])
    func didFailWithError(error: Error)
}

class DataManager: NSObject {
    
    static var delegate: DataManagerDelegate?
    let defaults = UserDefaults.standard
    var data: [Task]?
    
    func addTask (task: Task) {
        DataManager.self.delegate?.didAddTask(task: task)
        return
    }
    
    func removeTask (row: Int) {
        DataManager.self.delegate?.didRemoveTask(row: row)
        return
    }
    
    func getTasks() {
        do {
            let savedData = (try defaults.getObject(forKey: "taskArray", castTo: [Task].self))
            DataManager.self.delegate?.didGetTask(savedData)
        } catch {
            print(error.localizedDescription)
        }
    }
}



