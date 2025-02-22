//
//  qrGenerator.swift
//  QRGen
//
//  Created by Brent Amersbach on 2/18/25.
//

import Cocoa

struct generator {
    func generateQRCode(from string: String, withScale scale: CGFloat) -> NSImage? {
        let data = string.data(using: String.Encoding.utf8)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: scale, y: scale)

            if let output = filter.outputImage?.transformed(by: transform) {
                let rep = NSCIImageRep(ciImage: output)
                let outputImage = NSImage(size: rep.size)
                outputImage.addRepresentation(rep)
                return outputImage
            }
        }

        return nil
    }

    func saveImage(_ image: NSImage, to path: String) throws {
        if let tiffData = image.tiffRepresentation {
            let pathUrl = URL(fileURLWithPath: path)
            let rep = NSBitmapImageRep(data: tiffData)
            let pngData = rep?.representation(using: .png, properties: [:])
            try pngData!.write(to: pathUrl)
        } else {
            throw NSError(domain: "", code: 0, userInfo: nil)
        }
    }
}
