import Foundation
import XCPlayground


func httpGet(request: NSURLRequest!, callback: (String, String?) -> Void) {
    let session = NSURLSession.sharedSession()
    let task = session.dataTaskWithRequest(request){
        (data, response, error) -> Void in
        if error != nil {
            callback("", error!.localizedDescription)
        } else {
            let result = NSString(data: data!, encoding:
                NSASCIIStringEncoding)!
            callback(result as String, nil)
        }
    }
    task.resume()
}

func parseJson(anyObj:AnyObject) -> Array<String>{
    
    var list:Array<String> = []
    
  //  var dictArray: [Dictionary<String, Int>] = []
    
    
    if  anyObj is Array<AnyObject> {
        
        
        //var b:Business = Business()
        
        for json in anyObj as! Array<AnyObject>{
          //  let id = (json["id"] as AnyObject? as? String) ?? "" // to get rid of null
            let inv_desc  =  (json["inv_desc"]  as AnyObject? as? String) ?? ""
            list.append(inv_desc)
        }// for
        
        
    } // if
    
    return list
    
}//func


var request = NSMutableURLRequest(URL: NSURL(string: "http://whispering-falls-5358.herokuapp.com/invs.json")!)
httpGet(request){
    (data, error) -> Void in
    if error != nil {
        print(error)
    } else {
        print(data)
        // convert String to NSData
        var data: NSData = data.dataUsingEncoding(NSUTF8StringEncoding)!
        var error: NSError?
        
        // convert NSData to 'AnyObject'
        var anyObj: AnyObject?
        do{
            anyObj = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))
        } catch _ {}
        // convert 'AnyObject' to Array<Business>
        var list = parseJson(anyObj!)
        print("Error: \(error)")
    }
}



//===============


//XCPSetExecutionShouldContinueIndefinitely(true)





