import Cocoa
import UserNotifications

class ViewController: NSViewController {

  @IBOutlet weak var tableView: NSTableView!
    
  var dataManager = DataManager()
  var formatter = DateFormatter()
  let defaults = UserDefaults.standard
  var data: [[String: String]] = [[:]]
    
    
    @IBAction func onAddPress(_ sender: NSButton) {
        performSegue(withIdentifier: "onAddPress", sender: self)
    }
    
    @IBAction func onOptionsPress(_ sender: NSButton) {
        performSegue(withIdentifier: "onOptionsPress", sender: self)
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
    func didAddTask(taskName: String, time: String, rowId: String) {
        
        var adjustedTime: String {
            if Array(time)[0] == "0" {
                return String(time.dropFirst())
            } else {
                return time
            }
        }
         
        formatter.dateFormat = "hh:mm a"
        
        self.data.append(["taskName" : taskName, "time" : adjustedTime, "rowId": rowId, "sortDate": time])
        self.data.sort {formatter.date(from: $0["time"]!)! < formatter.date(from: $1["time"]!)!}
        self.defaults.set(self.data, forKey: "taskArray")
        tableView.reloadData()
    }
    
    func didRemoveTask(row: Int) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [data[row]["rowId"] ?? "None"])
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                print(request)
            }
        })
        self.data.remove(at: row)
        self.defaults.set(self.data, forKey: "taskArray")
        tableView.reloadData()
    }
    
    func didGetTask(_ savedData: [[String : String]]) {
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
    cell.taskLabel?.stringValue = data[row]["taskName"] ?? ""
    cell.timeLabel?.stringValue = data[row]["time"] ?? ""
    
    return cell
  }
}

