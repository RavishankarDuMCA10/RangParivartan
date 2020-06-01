//
//  RangParivartanTests.swift
//  RangParivartanTests
//
//  Created by Ravi Shankar Kushwaha on 01/06/20.
//  Copyright © 2020 Self. All rights reserved.
//

import XCTest
@testable import RangParivartan

class RangParivartanTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    var rangParivartan: RangParivartan!

    override func setUp() {
        rangParivartan = RangParivartan()
    }

    func testAdd() {
        XCTAssertEqual(rangParivartan.add(a: 1, b: 1), 2)
    }

}
