//
//  main.swift
//  QRGen
//
//  Created by Brent Amersbach on 2/18/25.
//

import Foundation
import ArgumentParser

//TODO: Option to specify output file

@main
struct QRGen: ParsableCommand {
    @Argument(help: "Text to encode")
    var textToEncode: String = ""
    
    @Option(name: [.customShort("o"), .customLong("output")], help: "Path to save QR code")
    var path: String = ""
    
    mutating func run() throws {
        if textToEncode.isEmpty {
            print("Input text to encode:")
            if let input = readLine(strippingNewline: true) {
                textToEncode = input
            } else {
                throw ExitCode.validationFailure
            }
        }
        
        if path.isEmpty {
            path = FileManager.default.currentDirectoryPath + "/\(textToEncode).png"
        }
        
        let generator = generator()
        let qrCode = generator.generateQRCode(from: textToEncode)
        do {
            try generator.saveImage(qrCode!, to: path)
        } catch {
            print(error.localizedDescription)
        }
        print("File saved to: \(path)")
    }
}

