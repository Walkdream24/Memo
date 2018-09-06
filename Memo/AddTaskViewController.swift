//
//  AddTaskViewController.swift
//  Memo
//
//  Created by 中重歩夢 on 2018/08/24.
//  Copyright © 2018年 Ayumu Nakashige. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController {
    
    
    @IBOutlet weak var taskTextField: UITextField!
    
    @IBOutlet weak var categorySegmentedControl: UISegmentedControl!
    
    
    var taskCategory = "ToDo"
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var task: Task?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let task = task{
            taskTextField.text = task.name
            taskCategory = task.category!
            
            switch task.category! {
            case "ToDo" :
                categorySegmentedControl.selectedSegmentIndex = 0
                
            case "Shopping" :
                categorySegmentedControl.selectedSegmentIndex = 1
                
            case "Assignment" :
                categorySegmentedControl.selectedSegmentIndex = 2
                
            default :
                categorySegmentedControl.selectedSegmentIndex = 0
            }
            
            
        }

        // Do any additional setup after loading the view.
    }

    
    
    
    @IBAction func categoryChosen(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex{
        case 0:
            taskCategory = "ToDo"
            
        case 1:
            taskCategory = "Shopping"
            
        case 2:
            taskCategory = "Assignment"
            
        default :
            taskCategory = "ToDo"
        }
        
    }
    

    
    @IBAction func plusButtonTappend(_ sender: Any) {
        
        //TextFieldに何も記入されていない場合は何もせず１つ目のビューに戻る
        
        let taskName = taskTextField.text
        if taskName == "" {
            dismiss(animated: true, completion: nil)
            return
        }
        //受け取った値が空であれば、新しいTask型オブフェクトを作成する
        if task == nil {
            task = Task(context: context)
            
        }
        
        if let task = task{
            
            task.name = taskName
            task.category = taskCategory
        }
        
    
        
        //上で作成したデータをデータベースに保存
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        dismiss(animated: true, completion: nil)
        
    
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
