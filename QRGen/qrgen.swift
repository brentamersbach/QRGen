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
//            print("Input text to encode:")
//            if let input = readLine(strippingNewline: true) {
//                textToEncode = input
//            } else {
//                throw ExitCode.validationFailure
//            }
            let stdinput = FileHandle.standardInput
            let data = stdinput.availableData
            if let input = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)
            {
                textToEncode = input
            } else {
                throw ExitCode.validationFailure
            }
        }
        
        if outputPath.isEmpty {
            if textToEncode.lengthOfBytes(using: .utf8) <= 12 {
                let filename = textToEncode
            } else {
                let filename = textToEncode.utf8.prefix(12)
            }
            let fileManager = FileManager.default
            outputPath = fileManager.currentDirectoryPath + "/\(textToEncode).png"
            if fileManager.fileExists(atPath: outputPath) {
                print("File already exists at \(outputPath). Please specify a different output path.")
                throw ExitCode.validationFailure
            }
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

