//
//  HttpModel.swift
//  XRossToDoApp
//
//  Created by 飯島大樹 on 2021/07/17.
//

import UIKit

class HttpModel: NSObject {
    func GetData(url:String,handler: @escaping ([TodoData])->Void) -> Void {
        let url = URL(string: url)!  //URLを生成
        let request = URLRequest(url: url)               //Requestを生成
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in  //非同期で通信を行う
            guard let data = data else { return }
            let decoder : JSONDecoder = JSONDecoder()
            do {
                let objects:[TodoData] = try decoder.decode([TodoData].self, from: data)
                print(objects)
                // メインスレッドで実行
                DispatchQueue.main.async {
                    handler(objects)
                }
                
            } catch let error {
                print(error)
            }
        }
        task.resume()
    }
    
    func PostData(url:String,contentData : Data,handler : @escaping (String)->Void) -> Void {
        let url = URL(string: url)!  //URLを生成
        var request = URLRequest(url: url)               //Requestを生成
        request.httpMethod = "POST"
        request.httpBody = contentData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in  //非同期で通信を行う
            guard let data = data else {
                // メインスレッドで実行
                DispatchQueue.main.async {
                    handler("送信失敗??")
                }
                return
                
            }
            
            let message = String(data:data,encoding: .utf8)!
            // メインスレッドで実行
            DispatchQueue.main.async {
                handler("送信成功:" + message)
            }
            
        }
        task.resume()
    }
    
    func DeleteData(url:String,id:Int,handler : @escaping (String)->Void) -> Void {
        let url = URL(string: url + String(id))!  //URLを生成
        var request = URLRequest(url: url)               //Requestを生成
        request.httpMethod = "DELETE"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in  //非同期で通信を行う
            guard let data = data else {
                // メインスレッドで実行
                DispatchQueue.main.async {
                    handler("送信失敗??")
                }
                return
                
            }
            
            let message = String(data:data,encoding: .utf8)!
            // メインスレッドで実行
            DispatchQueue.main.async {
                handler("送信成功:" + message)
            }
            
        }
        task.resume()
    }
}
