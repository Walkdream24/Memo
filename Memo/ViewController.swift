//
//  ViewController.swift
//  Memo
//
//  Created by 中重歩夢 on 2018/08/24.
//  Copyright © 2018年 Ayumu Nakashige. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{

    
    @IBOutlet weak var taskTableView: UITableView!
    
    
    var tasks:[Task] = []
    var tasksToShow:[String:[String]] = ["ToDo":[], "Shopping":[], "Assignment":[]]
    let taskCategories:[String] = ["ToDo", "Shopping", "Assignment"]
    
    private let segueEditTaskViewController = "SegueEditTaskViewController"
    //taskCategories[]に格納されている文字列がtableViewのセクションになる
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return taskCategories.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return taskCategories[section]
    }
    
    //taskToShowにカテゴリー（taskToShowのキーとなっている)ごとのnameが格納されている　（挿入するデータ数を返す）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tasksToShow[taskCategories[section]]!.count
    }
    
    //挿入したいデータを生成する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = taskTableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.reuseIdentifier, for: indexPath)as? TaskTableViewCell else{
            fatalError("Unexpected Index Path")
        }
        
        
        let sectionData = tasksToShow[taskCategories[indexPath.section]]
        let cellData = sectionData?[indexPath.row]
        cell.textLabel?.text = "\(cellData!)"
        
        return cell
        
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        taskTableView.dataSource = self
        taskTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //CaoreDataからデータをfetchする
        getData()
        
        //taskTableViewを再読み込みする
        taskTableView.reloadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destinationViewController = segue.destination as? AddTaskViewController else{
            return
        }
        //contextをAddTaskViewController.swiftのcontextへ渡す
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        destinationViewController.context = context
        if let indexPath = taskTableView.indexPathForSelectedRow,
            segue.identifier == segueEditTaskViewController{
            
            let editedCategory = taskCategories[indexPath.section]
            let editedName = tasksToShow[editedCategory]?[indexPath.row]
            
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "name = %@ and category = %@", editedName!,editedCategory )
            
            do{
                let task = try context.fetch(fetchRequest)
                destinationViewController.task = task[0]
                
            }catch{
                print("Fetching Failed")
            }
        
        
        }
    }
    
    func getData(){
        //データ保存時と同様にcontextを定義
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do{
            //CoreDataからデータをfetchしてtasksに格納
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
            
            tasks = try context.fetch(fetchRequest)
            
            //tasksToShowの配列を空にする（同じデータを複数表示しないため）
            for key in tasksToShow.keys {
                tasksToShow[key] = []
            }
            //fetchしたデータをtaskToShow配列に格納する
            for task in tasks {
                tasksToShow[task.category!]?.append(task.name!)
            }
        }catch{
            print("Fetching Failed")
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = UILabel()
        title.text = taskCategories[section]
        title.textAlignment = NSTextAlignment.center
        title.backgroundColor = UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1.0)
        
        title.textColor = .brown
        title.font = UIFont(name: "Helvetica Neue", size: 20.0)
        
        return title
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 40.0
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if editingStyle == .delete{
            //削除したいデータのみをfetchする
            //削除したいデータのname, categoryを取得
            let deletedCategory = taskCategories[indexPath.section]
            let deletedName = tasksToShow[deletedCategory]?[indexPath.row]
            
            //取得したname, categoryに合致するデータのみをfetchするようにfetchRequestを作成
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
            
            fetchRequest.predicate = NSPredicate(format: "name = %@ and category = %@", deletedName!,deletedCategory )
            
            //そのfetchRequestを満たすデータをfetchしてTask（配列だが要素を１種類しか持たない）に代入し、削除する
            
            do{
                let task = try context.fetch(fetchRequest)
                context.delete(task[0])
                
            }catch{
                print("Fetching Failed")
            }
            
            //削除した後のデータを保存する
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            //削除後の全データをfetchする
            getData()
        }
        
        //taskTableViewを再読み込みする
        taskTableView.reloadData()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

