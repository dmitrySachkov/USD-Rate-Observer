//
//  MonthRateParser.swift
//  USD Rate Observer
//
//  Created by Dmitry Sachkov on 15.06.2021.
//

import Foundation

class MonthRateParserXML: NSObject, XMLParserDelegate {
    
    static let shared = MonthRateParserXML()
    
    var elementName: String = String()
    var value = String()
    var date = Date()
    var array: [MonthRate] = []
    
    //MARK: - Add ParserXML
    func parserXML(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let parser = XMLParser(contentsOf: url)
        parser?.delegate = self
        parser?.parse()
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

        if elementName == "Record" {
            value = String()
            if let dateString = attributeDict["Date"] {
                let df = DateFormatter()
                df.dateFormat = "dd.MM.yyyy"
                date = df.date(from: dateString)!
            }
        }

        self.elementName = elementName
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "Record" {
            let usd = MonthRate(date: date, value: value)
            array.append(usd)
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        if (!data.isEmpty) {
            if self.elementName == "Value" {
                value += data
            } else if self.elementName == "_Date" {
                let df = DateFormatter()
                df.dateFormat = "dd.MM.yyyy"
                date = df.date(from: data)!
            }
        }
    }
}
