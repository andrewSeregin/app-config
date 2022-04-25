import XCTest
@testable import AppConfig

final class AppConfigTests: XCTestCase {
    func testRawConfig() {
        let rawConfig = RawConfig([
            "key_1": NSNumber(value: true),
            "key_2": NSNumber(value: 1),
            "key_3": NSNumber(value: 2.0)
        ])
        
        let key_1Value = rawConfig[keyPath: \.key_1] as? Bool
        let key_2Value = rawConfig[keyPath: \.key_2] as? Int
        let key_3Value = rawConfig[keyPath: \.key_3] as? Double
        
        do {
            try XCTAssertTrue(XCTUnwrap(key_1Value))
            try XCTAssertEqual(XCTUnwrap(key_2Value), 1)
            try XCTAssertEqual(XCTUnwrap(key_3Value), 2.0)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}

fileprivate extension RawConfig {
    var key_1: Any? {
        self[#function]
    }
}
