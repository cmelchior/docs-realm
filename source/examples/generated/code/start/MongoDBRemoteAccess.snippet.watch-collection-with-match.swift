app.login(credentials: Credentials.anonymous) { (result) in
    DispatchQueue.main.async {
        switch result {
        case .failure(let error):
            print("Login failed: \(error)")
        case .success(let user):
            print("Login as \(user) succeeded!")
            // Continue below
        }
        
        // Set up the client, database, and collection.
        let client = app.currentUser!.mongoClient("mongodb-atlas")
        let database = client.database(named: "ios")
        let collection = database.collection(withName: "CoffeeDrinks")
        
        // Watch the collection. In this example, we use a queue and delegate,
        // both of which are optional arguments.
        let queue = DispatchQueue(label: "io.realm.watchQueue")
        let delegate =  MyChangeStreamDelegate()
        let matchFilter = [ "fullDocument._partition": AnyBSON("Store 42") ]
        let changeStream = collection.watch(matchFilter: matchFilter, delegate: delegate, queue: queue)
        // An update to a relevant document triggers a change event.
        let queryFilter: Document = ["_id": AnyBSON(drinkObjectId) ]
        let documentUpdate: Document = ["$set": ["containsDairy": "true"]]

        collection.updateOneDocument(filter: queryFilter, update: documentUpdate) { result in
            switch result {
            case .failure(let error):
                print("Call to MongoDB failed: \(error.localizedDescription)")
                return
            case .success(let updateResult):
                print("Successfully updated the document")
            }
        }
        // After you're done watching for events, close the change stream.
        changeStream.close()
    }
}
