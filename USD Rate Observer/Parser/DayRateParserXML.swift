//
//  DayRateParserXML.swift
//  USD Rate Observer
//
//  Created by Dmitry Sachkov on 14.06.2021.
//

import Foundation

class DayRateParserXML: NSObject, XMLParserDelegate  {
    
    static let shared = DayRateParserXML()
    
    var currencyRateArray = [DayRate]()
    var elementName = String()
    var value = String()
    var charCode = String()
    let urlString = "http://www.cbr.ru/scripts/XML_daily.asp?"
    
    //MARK: - Add XMLParser
    func fetchUSD() {
        guard let url = URL(string: urlString) else { return }
        let parser = XMLParser(contentsOf: url)
        parser?.delegate = self
        parser?.parse()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

        if elementName == "Value" {
            value = String()
        } else if elementName == "CharCode" {
            charCode = String()
        }
        self.elementName = elementName
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "Value" {
            let curency = DayRate(charCode: charCode, value: value)
            currencyRateArray.append(curency)
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        if (!data.isEmpty) {
            if self.elementName == "Value" {
                value += data
            } else if self.elementName == "CharCode" {
                charCode += data
            }
        }
    }
}
