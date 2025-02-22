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
    
    @Option(name: [.customShort("s"), .customLong("scale")], help: "Scaling factor for output image")
    var scale: Double = 20
    
    @Argument(help: "Text to encode")
    var textToEncode: String = ""
    
    mutating func run() throws {
        if textToEncode.isEmpty {
            let stdinput = FileHandle.standardInput
            let data = stdinput.availableData
            if let input = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) {
                textToEncode = input
            } else {
                throw ExitCode.validationFailure
            }
        }
        
        let fileManager = FileManager.default
        if outputPath.isEmpty {
            var filename = ""
            if textToEncode.lengthOfBytes(using: .utf8) <= 12 {
                filename = textToEncode
            } else {
                filename = String(textToEncode.prefix(12))
            }
            outputPath = fileManager.homeDirectoryForCurrentUser.path() + "/Desktop/\(filename).png"
        }
        if fileManager.fileExists(atPath: outputPath) {
            print("File already exists at \(outputPath). Please specify a different output path.")
            throw ExitCode.validationFailure
        }
        
        let generator = generator()
        let size = CGFloat(scale)
        let qrCode = generator.generateQRCode(from: textToEncode, withScale: size)
        do {
            try generator.saveImage(qrCode!, to: outputPath)
        } catch {
            print(error.localizedDescription)
            throw ExitCode.failure
        }
        print("File saved to: \(outputPath)")
        throw ExitCode.success
    }
}

