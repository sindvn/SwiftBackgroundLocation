import Foundation
import CoreLocation


public protocol BackgroundLocationCacheable {
    func saveRegionsCoordinates(regions:[CLCircularRegion])
    func coordinates(for region: CLRegion) -> CLLocationCoordinate2D
}

public struct BackgroundLocationCache: BackgroundLocationCacheable {
    
    private let defaults: UserDefaults
    
    public init(defaults: UserDefaults) {
        self.defaults = defaults
    }
    
    public func saveRegionsCoordinates(regions:[CLCircularRegion]) {
        regions.forEach { region in
            defaults.set(region.center.latitude, forKey: String(format: CacheFormat.latFormat, region.identifier))
            defaults.set(region.center.longitude, forKey: String(format: CacheFormat.longFormat, region.identifier))
            defaults.set(region.radius, forKey: String(format: CacheFormat.radiusFormat, region.identifier))
            defaults.synchronize()
        }
    }
    
    public func coordinates(for region: CLRegion) -> CLLocationCoordinate2D {
        let lat  = defaults.float(forKey: String(format: CacheFormat.latFormat, region.identifier))
        let long = defaults.float(forKey: String(format: CacheFormat.longFormat, region.identifier))
        return CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))
    }

    private struct CacheFormat {
        static let latFormat = "\(Constants.suitName).region.coordinates.%@.lat"
        static let longFormat = "\(Constants.suitName).region.coordinates.%@.long"
        static let radiusFormat = "\(Constants.suitName).region.%@.radius"
    }
}
