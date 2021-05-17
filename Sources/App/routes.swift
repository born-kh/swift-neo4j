import Vapor
import Theo


func theoClient(completion: @escaping (BoltClient) -> ()) {
    do {
        let client = try BoltClient(hostname: "localhost",
                                    port: 7687,
                                    username: "born",
                                    password: "plate-blast-salami-status-regard-2157",
                                    encrypted: true)
        client.connect { result in
            
            let isSuccess = try! result.get()
            assert(isSuccess)
            completion(client)
        }
    } catch {
        print("Error! \(String(describing: error))")
    }
}

func routes(_ app: Application) throws {
    


    
    app.get { req -> EventLoopFuture<String> in
           
           let promise: EventLoopPromise<String> = req.eventLoop.makePromise()
           
           theoClient() { theo in
               let newNode = Node(label: "New", properties: [ "createdTime": Date().timeIntervalSince1970 ])
               theo.createAndReturnNode(node: newNode) { result in
                   do {
                       let node = try result.get()
                       assert(node.labels.first! == "New")
                       promise.completeWith(.success("Newly created node!"))
                   } catch {
                       promise.completeWith(.failure(error))
                   }
               }
           }
           
           return promise.futureResult
       }
    app.get("hello") { req -> String in
   
     return "hello"

    
    }
}
