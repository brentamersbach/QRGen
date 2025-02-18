//
//  main.swift
//  QRGen
//
//  Created by Brent Amersbach on 2/18/25.
//

import Cocoa

//TODO: Get input string from stdin

func generateQRCode(from string: String) -> NSImage? {
    let data = string.data(using: String.Encoding.ascii)

    if let filter = CIFilter(name: "CIQRCodeGenerator") {
        filter.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 3, y: 3)

        if let output = filter.outputImage?.transformed(by: transform) {
            let rep = NSCIImageRep(ciImage: output)
            let outputImage = NSImage(size: rep.size)
            outputImage.addRepresentation(rep)
            return outputImage
        }
    }

    return nil
}

generateQRCode(from: "Hello World!")

//TODO: Save image out to file
