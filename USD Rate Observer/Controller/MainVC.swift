//
//  ViewController.swift
//  USD Rate Observer
//
//  Created by Dmitry Sachkov on 14.06.2021.
//

import UIKit

class MainVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var rateLbl: UILabel!
    
    let date = Date()
    var toDay = ""
    var urlString = ""
    var ratePoint = 0.0


    override func viewDidLoad() {
        super.viewDidLoad()
        
        Notification.shared.getNotificationRequestAuthrization()
        urlString = getDate(day: date)
        MonthRateParserXML.shared.parserXML(urlString: urlString)
        DayRateParserXML.shared.fetchUSD()
        setupTableView()
        setupDayRate(array: DayRateParserXML.shared.currencyRateArray)
       
    }

    //MARK: - Set up TableView
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
   
    //MARK: - SetUp the day rate
    func setupDayRate(array: [DayRate]) {
        dateLbl.text = toDay
        for i in array {
            if i.charCode == "USD" {
                rateLbl.text = i.value
                ratePoint = Double(i.value) ?? 0
            }
        }
    }
    
    //MARK: - Configure the url for fetch month rates
    func getDate(day: Date) -> String {
        var dayMonthAgo = ""
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        var components = DateComponents()
        components.month = -1
        let earlyMonth = Calendar.current.date(byAdding: components, to: date)
        dayMonthAgo = df.string(from: earlyMonth!)
        toDay = df.string(from: date)
        let urlString = "http://www.cbr.ru/scripts/XML_dynamic.asp?date_req1=\(dayMonthAgo)&date_req2=\(toDay)&VAL_NM_RQ=R01235"
        return urlString
    }
}

//MARK: - Configure the TableView
extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MonthRateParserXML.shared.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CurrencyCell
        let currencyRate = MonthRateParserXML.shared.array[indexPath.row]
        cell.setupCell(date: currencyRate.date, rate: currencyRate.value)
        return cell
    }
}
