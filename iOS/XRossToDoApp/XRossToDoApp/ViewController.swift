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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
