//  Copyright © 2017 nrith. All rights reserved.

@testable import Nvelope
import XCTest

class NLPEngineTests: XCTestCase {

    // MARK: - init()
    func testInitializerWithNoArgumentsUsesNameTypeOrLexicalClassScheme() {
        let engine = NLPEngine()
        XCTAssertEqual(engine.schemes.count, 1)
        XCTAssertTrue(engine.schemes.first! == NSLinguisticTagScheme.nameTypeOrLexicalClass)
    }

    func testInitializerWithSpecificSchemes() {
        let schemes: [NSLinguisticTagScheme] = [.nameTypeOrLexicalClass, .lemma]
        let engine = NLPEngine(schemes: schemes)
        XCTAssertEqual(engine.schemes.count, 2)
        XCTAssertTrue(engine.schemes.contains(.nameTypeOrLexicalClass))
        XCTAssertTrue(engine.schemes.contains(.lemma))
    }

    // MARK: - string
    func testStringSetterAndGetter() {
        var engine = NLPEngine()
        let string = "It was the best of times, it was the worst of times."
        engine.string = string
        XCTAssertEqual(engine.string, string)
    }

    // MARK: - Tags

    func testPartOfSpeechTagsForEmptyStringAreEmpty() {
        let engine = NLPEngine()
        let tags = engine.partOfSpeechTags
        XCTAssertTrue(tags.isEmpty)
    }

    func testPartOfSpeechTagsForSingleSentenceAreNotEmpty() {
        var engine = NLPEngine()
        let string = "They say that Richard Cory once owned half of this whole town."
        engine.string = string
        let tags = engine.partOfSpeechTags
        XCTAssertEqual(tags.count, 11)
    }

}
