//
//  File.swift
//  AsyncDownSamplingImage
//
//  Created by Dmitry Kononchuk on 15.06.2023.
//  Copyright © 2023 Dmitry Kononchuk. All rights reserved.
//

import Foundation
import UIKit

public final class ImageCacheKey : NSObject {
    public var url: NSURL
    public var width: NSNumber
    public var height: NSNumber
    
    init(url: URL, size: DownSamplingSize) {
        self.url = url as NSURL
        self.width = NSNumber(value: size.width ?? 0)
        self.height = NSNumber(value: size.height ?? 0)
    }
    
    public override var description: String { return "ImageCacheKey: \(url) \(width) \(height)" }
    
    public override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? ImageCacheKey else {
            return false
        }
        return url == other.url && width == other.width && height == other.height
    }
    
    public override var hash: Int {
        return url.hashValue ^ width.hashValue ^ height.hashValue
    }
    
}

public protocol ImageCacheProtocol {
    subscript(_ key: ImageCacheKey) -> CGImage? { get set }
    
    /// Set cache limit.
    ///
    /// - Parameters:
    ///   - countLimit: The maximum number of objects the cache should hold.
    ///   If `0`, there is no count limit. The default value is `0`.
    ///   - totalCostLimit: The maximum total cost that the cache can hold before
    ///   it starts evicting objects.
    ///   When you add an object to the cache, you may pass in a specified cost for the object,
    ///   such as the size in bytes of the object.
    ///   If `0`, there is no total cost limit. The default value is `0`.
    func setCacheLimit(countLimit: Int, totalCostLimit: Int)
    
    /// Empties the cache.
    func removeCache()
}

struct TemporaryImageCache: ImageCacheProtocol {
    // MARK: - Private Properties
    
    public static var shared = TemporaryImageCache()
    
    private let cache: NSCache<ImageCacheKey, CGImage> = {
        let cache = NSCache<ImageCacheKey, CGImage>()
        return cache
    }()
    
    // MARK: - Subscripts
    
    subscript(_ key: ImageCacheKey) -> CGImage? {
        get {
            cache.object(forKey: key as ImageCacheKey)
        }
        set {
            newValue == nil
                ? cache.removeObject(forKey: key as ImageCacheKey)
                : cache.setObject(newValue!, forKey: key as ImageCacheKey)
        }
    }
    
    // MARK: - Public Methods
    
    func setCacheLimit(countLimit: Int = 0, totalCostLimit: Int = 0) {
        cache.countLimit = countLimit
        cache.totalCostLimit = totalCostLimit
    }
    
    func removeCache() {
        cache.removeAllObjects()
    }
}
