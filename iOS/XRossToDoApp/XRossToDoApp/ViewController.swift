//
//  ViewController.swift
//  XRossToDoApp
//
//  Created by 飯島大樹 on 2021/07/12.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        let todoTitle = todoList[indexPath.row]
        cell.textLabel?.text = todoTitle.title
        return cell
    }
    // セルの削除機能
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            HttpModel().DeleteData(url: "http://" + ip + ":" + port + "/api/todo/", id: todoList[indexPath.row].id){(message) in
                self.alert(title: "送信結果", message: message)
                
                self.todoList.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
            }
            
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    let ip : String = "192.168.0.17"
    let port : String = "8000"
    
    var todoList = [TodoData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //RefreshControlを追加する処理
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        
        //  クロージャはメインスレッドで実行される
        HttpModel().GetData(url: "http://" + ip + ":" + port + "/api/todo/",handler: updateTableView)
    }
    
    //  実行はメインスレッドで行う必要がある
    func updateTableView(todoData:[TodoData])->Void{
        self.todoList.removeAll()
        
        for i in 0...todoData.count - 1{
            self.todoList.insert(todoData[i], at: 0)
        }
        
        self.tableView.reloadData()                     //TableViewの中身を更新する場合はここでリロード処理
        self.tableView.refreshControl?.endRefreshing()  //これを必ず記載すること
    }
    
    @objc func handleRefreshControl() {
        //  クロージャはメインスレッドで実行される
        HttpModel().GetData(url: "http://" + ip + ":" + port + "/api/todo/",handler: updateTableView)
    }
    
    
    @IBAction func addBtnAction(_ sender: Any) {
        let alertController = UIAlertController(title: "ToDo追加", message: "ToDoを入力してください", preferredStyle: UIAlertController.Style.alert)
        
        alertController.addTextField(configurationHandler: nil)
        
        let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default){ (action: UIAlertAction) in
            if let textField = alertController.textFields?.first {

                
                let todoData = TodoData(id: 0, title: textField.text!, is_complete: "false")
                let jsonData : Data = try! JSONEncoder().encode(todoData)
                
                HttpModel().PostData(url: "http://" + self.ip + ":" + self.port + "/api/todo/", contentData: jsonData){(message) in
                    self.alert(title: "送信結果", message: message)
                    
                    
                    
//                    self.todoList.insert(textField.text!, at: 0)
//                    self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableView.RowAnimation.right)
                }
            }
        }
        
        alertController.addAction(onAction);
        
        let cancelButton = UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.cancel, handler: nil)
        
        alertController.addAction(cancelButton)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func alert(title:String, message:String) {
        var alertController: UIAlertController!
            alertController = UIAlertController(title: title,
                                       message: message,
                                       preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK",
                                           style: .default,
                                           handler: nil))
            present(alertController, animated: true)
        }
}
