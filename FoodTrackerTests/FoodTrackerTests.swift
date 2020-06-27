//
//  FoodTrackerTests.swift
//  FoodTrackerTests
//
//  Created by LeeAlvis on 21/6/2020.
//

import XCTest
@testable import FoodTracker

class FoodTrackerTests: XCTestCase {

    // MARK: Meal Class Tests
    
    func testMealInitializationSucceeds() {
        // Zero rating
        let zeroRatingMeal = Meal.init(name: "zero", photo: nil, rating: 0)
        XCTAssertNotNil(zeroRatingMeal)
        
        // Highest rating
        let highestRatingMeal = Meal.init(name: "highest", photo: nil, rating: 5)
        XCTAssertNotNil(highestRatingMeal)
    }
    
    func testMealInitializationFails() {
        // Negative rating
        let negativeRatingMeal = Meal.init(name: "negative", photo: nil, rating: -1)
        XCTAssertNil(negativeRatingMeal)
        
        // Empty name
        let emptyNameMeal = Meal.init(name: "", photo: nil, rating: 0)
        XCTAssertNil(emptyNameMeal)
        
        // Exceed maximum rating
        let exceedRatingMeal = Meal.init(name: "exceed", photo: nil, rating: 6)
        XCTAssertNil(exceedRatingMeal)
    }
}
