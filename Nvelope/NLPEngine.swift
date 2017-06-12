//  Copyright © 2017 nrith. All rights reserved.

import Foundation

/// Manages NLP functionality that's used throughout the app.
public struct NLPEngine {

    // MARK: - Properties

    /// The schemes that the tagger is configured for.
    public var schemes: [NSLinguisticTagScheme] {
        return tagger.tagSchemes
    }

    /// The text to tag. All engine operations are executed on this value.
    public var string: String? {
        didSet {
            tagger.string = string
                // retag()?
        }
    }

    /// Get all of the part-of-speech tags (e.g. "name", "pronoun", or "verb")
    /// that are parsed from the string that was set on this engine.
    /// Punctuation and whitespace are ignored, and names that are adjacent to
    /// each other are joined into a single name tag.
    public var partOfSpeechTags: [NSLinguisticTag] {
        let range = NSMakeRange(0, string?.count ?? 0)
        let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
        return tagger.tags(in: range, unit: .word, scheme: .nameTypeOrLexicalClass, options: options, tokenRanges: nil)
    }

    /// The NLP tagger.
    private var tagger: NSLinguisticTagger

    // MARK: - Initializers

    /// Create an engine that will tag a specified set of schemes. If no
    /// schemes are specified, then the tagger will default to using the
    /// `.nameTypeOrLexicalClass` scheme.
    ///
    /// - parameter schemes: The `NSLinguisticTagSchemes` to be used by the
    ///   tagger. If none are specified, then `.nameTypeOrLexicalClass` will
    ///   be used as the sole default scheme.
    public init(schemes: [NSLinguisticTagScheme] = [.nameTypeOrLexicalClass]) {
        tagger = NSLinguisticTagger(tagSchemes: schemes, options: 0)
    }

    // MARK: - Other methods

}
