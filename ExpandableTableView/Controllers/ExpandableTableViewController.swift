//
//  ListMedicines.swift
//  AssignmentTest
//
//  Created by Angelos Staboulis on 13/2/21.
//

import UIKit
protocol ExpandableProtocol:AnyObject{
    func createHeaderView(section:Int)->UIView
    func handleHeightRow(indexPath:IndexPath)->CGFloat
    func setupCell(indexPath:IndexPath)->MedicineCell
    func handleRows(section:Int)->Int
}
class ExpandableTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var sections=["","Τετάρτη","Πέμπτη","Παρασκευή","Σάββατο"]
    var quantities=["","14.11","14.11","15.11","16.11"]
    var medicinesArray = [ExpandModel]()
    var expanded:Bool!=false
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
   
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension ExpandableTableViewController {
    func setupView(){
        medicinesArray.append(ExpandModel(isExpanded: false, medicines: [],quantities:[]))
        medicinesArray.append(ExpandModel(isExpanded: true, medicines: ["Panadol","Nurofen","Algofren","Depon"],quantities:["300 ml","150 ml","300 ml","2 χάπια"]))
        medicinesArray.append(ExpandModel(isExpanded: true, medicines: ["Panadol","Nurofen"],quantities:["300 ml","150 ml"]))
        medicinesArray.append(ExpandModel(isExpanded: true, medicines: ["Depon"],quantities:["2 χάπια"]))
        medicinesArray.append(ExpandModel(isExpanded: true, medicines: ["Panadol","Zantac"],quantities: ["300 ml","150 ml"]))
      
        if (UIApplication.shared.windows.first?.safeAreaInsets.bottom)! > 0 {
            tableView.contentInset = UIEdgeInsets(top: -150, left: 0, bottom: 0, right: 0)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
            tableView.register(UINib(nibName: "MedSubHeader", bundle: nil), forCellReuseIdentifier: "medSubHeader")
            tableView.register(UINib(nibName: "MedicineCell", bundle: nil), forCellReuseIdentifier: "medicineCell")
        }
        else{
            tableView.contentInset = UIEdgeInsets(top: -150, left: 0, bottom: 0, right: 0)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
            tableView.register(UINib(nibName: "MedSubHeader", bundle: nil), forCellReuseIdentifier: "medSubHeader")
            tableView.register(UINib(nibName: "MedicineCell", bundle: nil), forCellReuseIdentifier: "medicineCell")
        }
    }
}
extension ExpandableTableViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
            5
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           createHeaderView(section: section)
    }
  
   
    @objc func handleExpandCollapse(sender:UIButton){
        var indexPaths = [IndexPath]()
        let section = sender.tag
        for row in medicinesArray[section].medicines.indices{
                let indexPath = IndexPath(row: row, section: section)
                indexPaths.append(indexPath)
        }
        let expanded = medicinesArray[section].isExpanded
        medicinesArray[section].isExpanded = !expanded
        sender.setTitle(expanded ? "Expand" : "Collapse", for: .normal)
        if expanded {
            tableView.deleteRows(at: indexPaths, with: .automatic)
        }
        else {
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
        
       
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        handleHeightRow(indexPath: indexPath)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        handleHeightHeader(section: section)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return handleRows(section: section)
     
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return setupCell(indexPath: indexPath)
    }
    
}

extension ExpandableTableViewController:ExpandableProtocol{
    func handleRows(section: Int) -> Int {
        if !medicinesArray[section].isExpanded {
            return 0
        }
        return medicinesArray[section].medicines.count
    }
    
    func setupCell(indexPath:IndexPath)->MedicineCell{
        let cell:MedicineCell = tableView.dequeueReusableCell(withIdentifier: "medicineCell") as! MedicineCell
        if indexPath.row < medicinesArray.count {
                    cell.medicine.text = medicinesArray[indexPath.section].medicines[indexPath.row]
                    cell.quanity.text = medicinesArray[indexPath.section].quantities[indexPath.row]
        }
        return cell
    }
    func handleHeightHeader(section:Int)->CGFloat{
        if section == 0 {
            return CGFloat(164)
        }
        else {
            return CGFloat(34)
        }
    }
    func handleHeightRow(indexPath:IndexPath)->CGFloat{
        if indexPath.row == 0 && indexPath.section == 0 {
            return CGFloat(190)
        }
        else {
            return CGFloat(54)
        }
    }
    func createHeaderView(section:Int)->UIView{
        let viewHeader = UIView(frame: CGRect(x: 0, y: 0, width: 650, height: 66))
        let btnClose = UIButton(frame: .zero)
        if UIScreen.main.bounds.width == 375 {
            btnClose.frame = CGRect(x: 230, y: -10, width: 200, height: 56)
        }
        else{
            btnClose.frame = CGRect(x: 250, y: -10, width: 200, height: 56)
        }
        btnClose.tag = section
        btnClose.setTitle("Collapse", for: .normal)
        btnClose.addTarget(self, action: #selector(handleExpandCollapse(sender:)), for:.touchDown)
        viewHeader.addSubview(btnClose)
        if (UIApplication.shared.windows.first?.safeAreaInsets.bottom)! > 0 {
            if UIScreen.main.bounds.width == 1125 {
                viewHeader.backgroundColor = UIColor.lightGray
                let day = UILabel(frame:  CGRect(x: 10, y: -5, width: 300, height: 45))
                let quantity = UILabel(frame:  CGRect(x: 250, y: -5, width: 300, height: 45))
                quantity.translatesAutoresizingMaskIntoConstraints = false
                day.text = sections[section]
                quantity.text = quantities[section]
                viewHeader.addSubview(day)
                viewHeader.addSubview(quantity)
            }
            else if UIScreen.main.bounds.width == 375 {
                viewHeader.backgroundColor = UIColor.lightGray
                let day = UILabel(frame:  CGRect(x: 10, y: -5, width: 300, height: 45))
                let quantity = UILabel(frame:  CGRect(x: 200, y: -5, width: 300, height: 45))
                day.text = sections[section]
                quantity.text = quantities[section]
                viewHeader.addSubview(day)
                viewHeader.addSubview(quantity)
            }
            else if UIScreen.main.bounds.width == 390 {
                viewHeader.backgroundColor = UIColor.lightGray
                let day = UILabel(frame:  CGRect(x: 10, y: -5, width: 300, height: 45))
                let quantity = UILabel(frame:  CGRect(x: 210, y: -5, width: 300, height: 45))
                day.text = sections[section]
                quantity.text = quantities[section]
                viewHeader.addSubview(day)
                viewHeader.addSubview(quantity)
            }
            else if UIScreen.main.bounds.width == 414 {
                viewHeader.backgroundColor = UIColor.lightGray
                let day = UILabel(frame:  CGRect(x: 10, y: -5, width: 100, height: 45))
                let quantity = UILabel(frame:  CGRect(x: 230, y: -5, width: 300, height: 45))
                day.text = sections[section]
                quantity.text = quantities[section]
                viewHeader.addSubview(day)
                viewHeader.addSubview(quantity)
            }
            else if UIScreen.main.bounds.width == 1242 {
                viewHeader.backgroundColor = UIColor.lightGray
                let day = UILabel(frame:  CGRect(x: 30, y: -5, width: 300, height: 45))
                let quantity = UILabel(frame:  CGRect(x: 150, y: -5, width: 300, height: 45))
                day.text = sections[section]
                quantity.text = quantities[section]
                viewHeader.addSubview(day)
                viewHeader.addSubview(quantity)
            }
            else{
                viewHeader.backgroundColor = UIColor.lightGray
                let day = UILabel(frame:  CGRect(x: 10, y: -5, width: 300, height: 45))
                let quantity = UILabel(frame:  CGRect(x: 245, y: -5, width: 300, height: 45))
                day.text = sections[section]
                quantity.text = quantities[section]
                viewHeader.addSubview(day)
                viewHeader.addSubview(quantity)
            }
        }
        else {
            if UIScreen.main.bounds.width == 414 {
                viewHeader.backgroundColor = UIColor.lightGray
                let day = UILabel(frame:  CGRect(x: 10, y: -5, width: 300, height: 45))
                let quantity = UILabel(frame:  CGRect(x: 240, y: -5, width: 300, height: 45))
                day.text = sections[section]
                quantity.text = quantities[section]
                viewHeader.addSubview(day)
                viewHeader.addSubview(quantity)
            }
            else {
                viewHeader.backgroundColor = UIColor.lightGray
                let day = UILabel(frame:  CGRect(x: 10, y: -5, width: 300, height: 45))
                let quantity = UILabel(frame:  CGRect(x: 200, y: -5, width: 300, height: 45))
                day.text = sections[section]
                quantity.text = quantities[section]
                viewHeader.addSubview(day)
                viewHeader.addSubview(quantity)
            }
        }
        
        return viewHeader
    }
}
