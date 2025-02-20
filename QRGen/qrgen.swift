//
//  main.swift
//  QRGen
//
//  Created by Brent Amersbach on 2/18/25.
//

import Foundation
import ArgumentParser

@main
struct qrgen: ParsableCommand {
    @Option(name: [.customShort("o"), .customLong("output-path")], help: "Path to save QR code")
    var outputPath: String = ""
    
    @Argument(help: "Text to encode")
    var textToEncode: String = ""
    
    mutating func run() throws {
        if textToEncode.isEmpty {
            print("Input text to encode:")
            if let input = readLine(strippingNewline: true) {
                textToEncode = input
            } else {
                throw ExitCode.validationFailure
            }
        }
        
        if outputPath.isEmpty {
            outputPath = FileManager.default.currentDirectoryPath + "/\(textToEncode).png"
        }
        
        let generator = generator()
        let qrCode = generator.generateQRCode(from: textToEncode)
        do {
            try generator.saveImage(qrCode!, to: outputPath)
        } catch {
            print(error.localizedDescription)
        }
        print("File saved to: \(outputPath)")
    }
}

