import Cocoa
import UserNotifications

class ViewController: NSViewController {

  @IBOutlet weak var tableView: NSTableView!
    
  var dataManager = DataManager()
  var encoder = JSONEncoder()
  var decoder = JSONDecoder()
  var formatter = DateFormatter()
  let defaults = UserDefaults.standard
  var data: [Task] = []
    
    
    @IBAction func onAddPress(_ sender: NSButton) {
        performSegue(withIdentifier: "onAddPress", sender: self)
    }
    
    @IBAction func onOptionsPress(_ sender: NSButton) {
        performSegue(withIdentifier: "onOptionsPress", sender: self)
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                print(request)
            }
        })
    }
    
    
    
    @IBAction func onRemovePress(_ sender: NSButton) {
        if tableView.selectedRow != -1 {
            dataManager.removeTask(row: tableView.selectedRow)
        } else {
            return
        }
    }
    
    override func viewDidLoad() {
    super.viewDidLoad()
    
    DataManager.delegate = self
    dataManager.getTasks()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.reloadData()
  }

}

extension ViewController: DataManagerDelegate {
    func didAddTask(task: Task) {
        self.data.append(task)
        self.data.sort(by: {$0.sortOrder < $1.sortOrder})
        
        do {
            try self.defaults.setObject(self.data, forKey: "taskArray")
            print(data)
        } catch {
            print(error.localizedDescription)
        }
        tableView.reloadData()
    }
    
    func didRemoveTask(row: Int) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [data[row].rowId])
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                print(request)
            }
        })
        self.data.remove(at: row)
        do {
            try self.defaults.setObject(self.data, forKey: "taskArray")
            print(data)
        } catch {
            print(error.localizedDescription)
        }
        tableView.reloadData()
        tableView.reloadData()
    }
    
    func didGetTask(_ savedData: [Task]) {
        self.data = savedData
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
}


extension ViewController: NSTableViewDataSource, NSTableViewDelegate {
    
  func numberOfRows(in tableView: NSTableView) -> Int {
    return (data.count)
  }

  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    
    guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "taskCell"), owner: self) as? CustomTableCell else { return nil }
    cell.taskLabel?.stringValue = data[row].taskName 
    cell.timeLabel?.stringValue = data[row].notificationTime 
    
    return cell
  }
}

extension UserDefaults: ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: forKey)
        } catch {
            throw ObjectSavableError.unableToEncode
        }
    }
    
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable {
        guard let data = data(forKey: forKey) else { throw ObjectSavableError.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw ObjectSavableError.unableToDecode
        }
    }
}

