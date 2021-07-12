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
        cell.textLabel?.text = todoTitle
        return cell
    }
    // セルの削除機能
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            todoList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var todoList = [String]()
    
    struct ToDo :Codable{
        let id: Int
        let title : String
        let is_complete : String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //RefreshControlを追加する処理
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        
        let url = URL(string: "http://127.0.0.1:8001/api/todo/")!  //URLを生成
        let request = URLRequest(url: url)               //Requestを生成
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in  //非同期で通信を行う
            guard let data = data else { return }
            let decoder : JSONDecoder = JSONDecoder()
            do {
                let objects:[ToDo] = try decoder.decode([ToDo].self, from: data)
                print(objects)
                // メインスレッドで実行
                DispatchQueue.main.async {
                    for i in 0...objects.count - 1{
                        self.todoList.insert(objects[i].title, at: 0)
                        self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableView.RowAnimation.right)
                    }
                }
                
            } catch let error {
                print(error)
            }
        }
        task.resume()
    }
    
    @objc func handleRefreshControl() {
        /*
         更新したい処理をここに記入（データの受け取りなど）
         */
        
        let url = URL(string: "http://127.0.0.1:8001/api/todo/")!  //URLを生成
        let request = URLRequest(url: url)               //Requestを生成
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in  //非同期で通信を行う
            guard let data = data else { return }
            let decoder : JSONDecoder = JSONDecoder()
            do {
                let objects:[ToDo] = try decoder.decode([ToDo].self, from: data)
                print(objects)
                
                self.todoList.removeAll()
                
                for i in 0...objects.count - 1{
                    self.todoList.insert(objects[i].title, at: 0)
                }
                
                //上記の処理が終了したら下記が実行されます。
                DispatchQueue.main.async {
                    self.tableView.reloadData()  //TableViewの中身を更新する場合はここでリロード処理
                    self.tableView.refreshControl?.endRefreshing()  //これを必ず記載すること
                }
                
            } catch let error {
                print(error)
            }
        }
        task.resume()
        
        
    }
    
    
    @IBAction func addBtnAction(_ sender: Any) {
        let alertController = UIAlertController(title: "ToDo追加", message: "ToDoを入力してください", preferredStyle: UIAlertController.Style.alert)
        
        alertController.addTextField(configurationHandler: nil)
        
        let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default){ (action: UIAlertAction) in
            if let textField = alertController.textFields?.first {
                self.todoList.insert(textField.text!, at: 0)
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableView.RowAnimation.right)
            }
        }
        
        alertController.addAction(onAction);
        
        let cancelButton = UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.cancel, handler: nil)
        
        alertController.addAction(cancelButton)
        
        present(alertController, animated: true, completion: nil)
    }
}
