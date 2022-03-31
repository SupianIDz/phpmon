//
//  NginxConfigParserTest.swift
//  phpmon-tests
//
//  Created by Nico Verbruggen on 29/11/2021.
//  Copyright © 2021 Nico Verbruggen. All rights reserved.
//

import XCTest

class NginxConfigParserTest: XCTestCase {
    
    static var regularUrl: URL {
        return Bundle(for: Self.self).url(forResource: "nginx-site", withExtension: "test")!
    }
    
    static var isolatedUrl: URL {
        return Bundle(for: Self.self).url(forResource: "nginx-site-isolated", withExtension: "test")!
    }
    
    static var proxyUrl: URL {
        return Bundle(for: Self.self).url(forResource: "nginx-proxy", withExtension: "test")!
    }
    
    func testCanDetermineIsolation() throws {
        XCTAssertNil(
            NginxConfigParser(filePath: NginxConfigParserTest.regularUrl.path).isolatedVersion
        )
        
        XCTAssertEqual(
            "8.1",
            NginxConfigParser(filePath: NginxConfigParserTest.isolatedUrl.path).isolatedVersion
        )
    }
    
}
