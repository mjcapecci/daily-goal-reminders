import Cocoa

protocol DataManagerDelegate {
    func didAddTask(taskName: String, time: String, rowId: String)
    func didRemoveTask(row: Int)
    func didGetTask(_ data: [[String: String]])
    func didFailWithError(error: Error)
}

class DataManager: NSObject {
    
    static var delegate: DataManagerDelegate?
    let defaults = UserDefaults.standard
    var data: [[String : String]]?
    
    func addTask (taskName: String, time: String, rowId: String) {
        DataManager.self.delegate?.didAddTask(taskName: taskName, time: time, rowId: rowId)
        return
    }
    
    func removeTask (row: Int) {
        DataManager.self.delegate?.didRemoveTask(row: row)
        return
    }
    
    func getTasks() {
        if let savedTasks = defaults.array(forKey: "taskArray") as? [[String : String]] {
            self.data = savedTasks
            DataManager.self.delegate?.didGetTask(savedTasks)
        }
    }
}



