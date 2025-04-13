import Foundation
import ImageIO

public struct DownSampling {
    public enum Error: LocalizedError {
        case failedToFetchImage
        case failedToDownsample
    }

    public static func perform(
        at url: URL,
        size: DownSamplingSize
    ) async throws -> CGImage {
        let cacheKey = ImageCacheKey(url: url, size: size)
        if let image = TemporaryImageCache.shared[cacheKey] {
            return image
        }
        let imageSourceOption = [kCGImageSourceShouldCache: true] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithURL(url as CFURL, imageSourceOption) else {
            throw Error.failedToFetchImage
        }

        let maxDimensionsInPixels = size.maxDimensionsInPixels

        let downsampledOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCache: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimensionsInPixels,
        ] as CFDictionary
        guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(
            imageSource,
            0,
            downsampledOptions
        ) else {
            throw Error.failedToDownsample
        }
        TemporaryImageCache.shared[cacheKey] = downsampledImage
        return downsampledImage
    }
}

fileprivate extension DownSamplingSize {
    var maxDimensionsInPixels: Double {
        switch self {
        case .size(let cGSize, let scale):
            max(cGSize.width, cGSize.height) * scale
        case .width(let double, let scale):
            double * scale
        case .height(let double, let scale):
            double * scale
        }
    }
}
