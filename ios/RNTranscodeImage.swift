import Foundation
import UIKit

enum CompressFormat {
    case JPEG
    case PNG
}

@objc(RNTranscodeImage)
class RNTranscodeImage: NSObject {
    static let E_DECODE = "E_DECODE"
    static let E_ENCODE = "E_ENCODE"

    /**
     * Convert an image to a different file type.
     *
     * If output format will be guessed from the destination file name
     * if it is not provided in the options.
     */
    @objc func transcodeImage(_ source: String, destination: String, options: NSDictionary, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
        DispatchQueue.global(qos: .userInitiated).async {
            let destFile = URL(fileURLWithPath: destination)
            let formatStr = options["outputFormat"] as? String ?? destFile.pathExtension
            let outputFormat: CompressFormat
            switch formatStr.lowercased() {
            case "jpg", "jpeg":
                outputFormat = .JPEG
            case "png":
                outputFormat = .PNG
            default:
                reject(
                    RNTranscodeImage.E_ENCODE,
                    "Cannot determine output format for '\(destination)'",
                    nil
                )
                return
            }

            guard let bitmap = UIImage(contentsOfFile: source) else {
                reject(
                    RNTranscodeImage.E_DECODE,
                    "Failed to decode '\(source)'",
                    nil
                )
                return
            }

            let potentialData: Data?
            switch outputFormat {
            case .JPEG:
                let quality = options["quality"] as? Int ?? 90
                potentialData = bitmap.jpegData(compressionQuality: CGFloat(quality) / 100.0)
            case .PNG:
                potentialData = bitmap.pngData()
            }

            guard let outData = potentialData else {
                reject(
                    RNTranscodeImage.E_ENCODE,
                    "Failed to compress '\(destination)' (format: \(outputFormat))",
                    nil
                )
                return
            }

            do {
                try outData.write(to: destFile)
            } catch {
                reject(
                    RNTranscodeImage.E_ENCODE,
                    "Failed to write '\(destination)' \(error)",
                    error
                )
                return
            }

            let manager = FileManager()
            let attrs = try? manager.attributesOfItem(atPath: destination)
            let fileSize = attrs?[FileAttributeKey.size] as? Int ?? 0
            resolve(["size": fileSize])
        }
    }
}
