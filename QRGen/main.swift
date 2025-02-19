//
//  main.swift
//  QRGen
//
//  Created by Brent Amersbach on 2/18/25.
//

import Cocoa
import ArgumentParser

//TODO: Option to specify output file
//TODO: Get input string from stdin

print(String(CommandLine.arguments.count))
var input: String = ""
if CommandLine.arguments.count > 1 {
    input = CommandLine.arguments.last ?? ""
}

if input.lengthOfBytes(using: .utf8) <= 0 {
    print("Input text to encode:")
    input = readLine(strippingNewline: true) ?? ""
}

if input.isEmpty {
    exit(1)
}

#if DEBUG
var path = FileManager.default.homeDirectoryForCurrentUser.path
path.append("/Desktop/\(input).png")
#else
var path = FileManager.default.currentDirectoryPath
path.append("/\(input).png")
#endif

let generator = qrGenerator()
let qrCode = generator.generateQRCode(from: input)
try generator.saveImage(qrCode!, to: path)

exit(0)
