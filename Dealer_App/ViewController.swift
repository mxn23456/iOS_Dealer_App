//
//  ViewController.swift
//  Dealer_App
//
//  Created by minh nguyen on 12/18/15.
//  Copyright © 2015 minh nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: Properties
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var transDescLabel: UILabel!
    @IBOutlet weak var transDescTextField: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    
    
    var pickerData: [String]=[String]()
    var invCollection: [Inv] = [Inv]()
    let urlPath = "https://whispering-falls-5358.herokuapp.com/invs.json"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //connect Data
        self.picker.delegate = self
        self.picker.dataSource = self
        
        // load sample invs for testing
        //loadSampleInvs()
        
        updateInvs()
        //inputDataIntoPicker()
        
        //pickerData = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6"]
        //print("about to call setNeedsDisplay")
        //self.picker.setNeedsDisplay()
        //print("called setNeedsDisplay")
        //print("picker's collection: " + invCollection.description)
        
        
    }
    
    //input data into the array
    func inputDataIntoPicker(){
        for inv in invCollection{
            let invDesc = inv.invDesc
            pickerData.append(invDesc)
        }
    }
    
    
    //This is a test to load local invs for demonstration purposes
    func loadSampleInvs(){
        let inv1 = Inv(invDesc: "car 1", image: nil)
        let inv2 = Inv(invDesc: "car 2", image: nil)
        let inv3 = Inv(invDesc: "car 3", image: nil)
        let inv4 = Inv(invDesc: "car 4", image: nil)
        let inv5 = Inv(invDesc: "car 5", image: nil)
        let inv6 = Inv(invDesc: "car 6", image: nil)
        
        invCollection += [inv1,inv2,inv3,inv4,inv5,inv6]
        
        
    }
    
    
    func httpGet(request: NSURLRequest!, callback: (String, String?) -> Void) {
        //var retrievedData = false
        //while !retrievedData{
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
        //}
    }
    
    func loadPicker(anyObj:AnyObject) {
        //  var dictArray: [Dictionary<String, Int>] = []
        invCollection = [Inv]()
        let newInv = Inv(invDesc: "New Investment",image: nil)
        invCollection.append(newInv)
        
        if  anyObj is Array<AnyObject> {
            
           // print("inCollection before load:" + invCollection.description)
            
            for json in anyObj as! Array<AnyObject>{
                //  let id = (json["id"] as AnyObject? as? String) ?? "" // to get rid of null
                let inv_desc  =  (json["inv_desc"]  as AnyObject? as? String) ?? ""
                let inv = Inv(invDesc: inv_desc, image: nil)
                invCollection.append(inv)
            }// for
            //print("invCollection after load:" +  invCollection.description)
            
        } // if
        
        
    }//func
    
    
    
    //This funciton retrieves list of invs (in order) from the server, updates the invCollection, then refreshes the picker's list
    func updateInvs(){
        let request = NSMutableURLRequest(URL: NSURL(string: urlPath)!)
        httpGet(request){
            (data, error) -> Void in
            if error != nil {
                print(error)
            } else {
                //print(data)
                // convert String to NSData
                let data: NSData = data.dataUsingEncoding(NSUTF8StringEncoding)!
                // let error: NSError?
                
                // convert NSData to 'AnyObject'
                var anyObj: AnyObject?
                do{
                    anyObj = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))
                } catch _ {}
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.loadPicker(anyObj!)
                    self.inputDataIntoPicker()
                    self.picker.reloadAllComponents()
                })


                
            }
        }
        //self.picker.setNeedsDisplay()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // Catpure the picker view selection
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        let selectedRow = String(row)
        print("selected row:" + selectedRow)
        let selectedDescription = invCollection[row].invDesc
        print("selected description:" + selectedDescription)
        print("")
        
    }
    
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
    }
    
    
    
    //MARK: Actions
    @IBAction func setSubmit(sender: UIButton) {

        print("Submit clicked")
        let selectedRow = picker.selectedRowInComponent(0)
        print("selected row:" + String(selectedRow))
        let selectedInv = invCollection[selectedRow]
        let selectedDescription = selectedInv.invDesc
        print("selected description:" + selectedDescription)
        let invTran = InvTran(amount: Int(amountTextField.text!)!, transDesc: transDescTextField.text!)
        print("amount: " + String(invTran.amount))
        print("transaction description: " + invTran.transDesc)
        print("date created: " + invTran.getDate())
        print("")
        postInvTranToRails(selectedInv,investmentTrans: invTran)
    }
    
    func postInvTranToRails(investment: Inv, investmentTrans: InvTran){
        
    }
    
    
    
}

