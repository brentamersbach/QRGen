//
//  qrGenerator.swift
//  QRGen
//
//  Created by Brent Amersbach on 2/18/25.
//

import Cocoa

struct qrGenerator {
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

    func saveImage(_ image: NSImage, to path: String) throws {
        if let tiffData = image.tiffRepresentation {
            let pathUrl = path.isEmpty ? URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString) : URL(fileURLWithPath: path)
            let rep = NSBitmapImageRep(data: tiffData)
            let pngData = rep?.representation(using: .png, properties: [:])
            try pngData!.write(to: pathUrl)
        } else {
            throw NSError(domain: "", code: 0, userInfo: nil)
        }
    }
}
