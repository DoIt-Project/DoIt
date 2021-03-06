//
//  PostService.swift
//  DoIt
//
//  Created by Yulia on 05.12.2021.
//
//

import Firebase

class TaskService {
    
    static let shared = TaskService()
    
    func uploadTask(task: Task, completion: @escaping(Error?, String)->Void){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let values = [
                      "title": task.title,
                      "description": task.description ?? "",
                      "deadline": Int(task.deadline?.timeIntervalSince1970 ?? 0),
                      "is_done": task.isDone,
                      "uid": uid,
                      "timestamp": Int(NSDate().timeIntervalSince1970),
                      "color": UIColor().HexFromColor(color: task.color),
                      "chapter_id": task.chapterId
        ] as [String : Any]
        
        REF_TASKS.childByAutoId().updateChildValues(values) { (error, ref) in
            guard let taskID = ref.key else { return }
            REF_USER_TASKS.child(uid).updateChildValues([taskID : 1], withCompletionBlock: { error, _ in
                completion(error, taskID)
            })
        }
    }
    
    func updateTask(task: Task, completion: @escaping(Error?)->Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let values = [
                      "title": task.title,
                      "description": task.description ?? "",
                      "deadline": Int(task.deadline?.timeIntervalSince1970 ?? 0),
                      "is_done": task.isDone,
                      "uid": uid,
                      "timestamp": Int(NSDate().timeIntervalSince1970),
                      "color": UIColor().HexFromColor(color: task.color),
                      "chapter_id": task.chapterId
        ] as [String : Any]
        
        REF_TASKS.child(task.taskId).updateChildValues(values) { (error, ref) in
            completion(error)
        }
    }
    
    func removeTask(task: Task, completion: @escaping(DatabaseCompletion)){
        guard (Auth.auth().currentUser?.uid) != nil else {return}
        REF_TASKS.child(task.taskId).removeValue(completionBlock: { error, ref in
            if let error = error {
                completion(error, ref)
            }
            REF_USER_TASKS.child(task.uid).child(task.taskId).removeValue(completionBlock: completion)
        })
    }
    
    func updateTaskDone(task: Task, completion: @escaping(DatabaseCompletion)){
        guard (Auth.auth().currentUser?.uid) != nil else {return}
        let values: [String: Any] = ["is_done": task.isDone]
        REF_TASKS.child(task.taskId).updateChildValues(values, withCompletionBlock: completion)
    }
    
    func updateTaskImage(taskId: String, image: UIImage, completion: @escaping(URL?)-> Void){
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {return}
        guard (Auth.auth().currentUser?.uid) != nil else {return}
            let ref = STORAGE_TASK_IMAGES.child(NSUUID().uuidString)

            ref.putData(imageData, metadata: nil) { (meta, err) in
                ref.downloadURL { (url, err) in
                    guard let taskImageUrl = url?.absoluteString else {return}
                    let values = ["taskImageUrl": taskImageUrl]
                    REF_TASKS.child(taskId).updateChildValues(values) { (err, ref) in
                        completion(url)
                    }
                }
            }
        }
    
    func fetchTask(taskId: String, completion: @escaping(Task) -> Void){
        REF_TASKS.child(taskId).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {return}
            completion(Task(id: taskId, dictionary: dictionary))
        }
    }
    
    func fetchTasks(forUser user: UserModel, completion: @escaping([Task]) -> Void) {
        var tasks = [Task]()
        REF_USER_TASKS.child(user.uid).observe(.childAdded) { snapshot in
            let taskId = snapshot.key
            
            self.fetchTask(taskId: taskId) { task in
                tasks.append(task)
                completion(tasks)
            }
        }
    }
}
