//  Copyright © 2017 nrith. All rights reserved.

import UIKit

/// The main view controller of the Nvelope application. It will tokenize and
/// display any text that you drop onto or enter manually into it, or the
/// contents of a URL.s
open class TextInputViewController: UIViewController {

    // MARK: - Outlets

    /// The main text view.
    @IBOutlet weak var textView: UITextView! {
        didSet {
            if let textView = textView {
                keyboardObserver = KeyboardObserver(scrollView: textView)
            }
        }
    }


    // MARK: - Other properties

    private var isTagging: Bool = false

    /// The utility that adjusts the text view's bottom content inset
    /// when the keyboard is shown or hidden.
    private var keyboardObserver: KeyboardObserver?

    private var tagger = NLPEngine()

    private var tags: [NSLinguisticTag] = [] {
        didSet {
            isTagging = true

            print("\n")

            let attributedString = NSMutableAttributedString()

            textView.text.split(separator: " ").enumerated().forEach { (element) in
                let tag = tags[element.offset]
                let word = String(element.element)
                let color: UIColor

                switch tag {
                case .adjective:
                    color = UIColor.red.withAlphaComponent(0.8)
                case .adverb:
                    color = UIColor.green.withAlphaComponent(0.8)
                case .classifier:
                    color = .blue
                case .closeParenthesis,
                     .closeQuote,
                     .openQuote,
                     .openParenthesis,
                     .otherWhitespace,
                     .whitespace:
                    color = .black
                case .conjunction:
                    color = .brown
                case .noun,
                     .number:
                    color = .red
                case .pronoun:
                    color = UIColor.red.withAlphaComponent(0.9)
                case .verb:
                    color = .green
                default:
                    color = .darkGray
                }

                print("Word: \(word), color: \(color)")
                let attributedWord = NSAttributedString(string: "\(word) ",
                                                        attributes: [.foregroundColor: color,
                                                                     .font: textView.font])
                attributedString.append(attributedWord)
            }

            textView.attributedText = attributedString

            isTagging = false
        }
    }

}

extension TextInputViewController: UITextViewDelegate {

    public func textViewDidChange(_ textView: UITextView) {
        guard isTagging == false else { return }

        let text = textView.text

        if text?.trimmingCharacters(in: .whitespacesAndNewlines) != text {
            tagger.string = textView.text
            tags = tagger.partOfSpeechTags
        }
    }
}

/// A utility class that manages a scroll view and adjusts its content insets
/// appropriately when the keyboard is shown or hidden. By default, this
/// adjustment happens just before the keyboard is shown and just after it's
/// hidden, but subclasses can override the four `show*()` and `hide*()`
/// methods to change this behavior.
open class KeyboardObserver: NSObject {

    /// The scroll view that this observer manipulates.
    private var scrollView: UIScrollView

    /// The insets of the scroll view's contents *before* the keyboard is
    /// shown. These are captured just before the keyboard is shown and
    /// restored right after it's hidden.
    private var originalContentInsets = UIEdgeInsets()

    /// Construct a keyboard observer and register for notifications.
    ///
    /// - parameter scrollView: The scroll view that this observer manipulates.
    public init(scrollView: UIScrollView) {
        self.scrollView = scrollView
        super.init()
        registerForNotifications()
    }

    deinit {
        unregisterFromNotifications()
    }

    /// Called when the `NSNotification.Name.UIKeyboardWillShow` notification
    /// is received. This will store the scroll view's current `contentInsets`
    /// and then adjust the bottom inset by increasing the bottom inset by the
    /// height of the keyboard.
    ///
    /// - parameter notification: The `NSNotification.Name.UIKeyboardWillShow`
    ///   notification.
    @objc open func showKeyboard(notification: Notification) {
        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as! CGRect
        let keyboardSize = keyboardFrame.size
        originalContentInsets = scrollView.contentInset
        let newEdgeInsets = UIEdgeInsets(top: originalContentInsets.top,
                                         left: originalContentInsets.left,
                                         bottom: keyboardSize.height + originalContentInsets.bottom,
                                         right: originalContentInsets.right)
        scrollView.contentInset = newEdgeInsets
        scrollView.scrollIndicatorInsets = newEdgeInsets
    }

    /// Called when the `NSNotification.Name.UIKeyboardDidShow` notification is
    /// received. This implementation does nothing.
    ///
    /// - parameter notification: The `NSNotification.Name.UIKeyboardDidShow`
    ///   notification.
    @objc open func showedKeyboard(notification: Notification) {
        // Nada.
    }

    /// Called when the `NSNotification.Name.UIKeyboardWillHide` notification
    /// is received. This implementation does nothing.
    ///
    /// - parameter notification: The `NSNotification.Name.UIKeyboardWillHide`
    ///   notification.
    @objc open func hideKeyboard(notification: Notification) {
        // Zilch.
    }

    /// Called when the `NSNotification.Name.UIKeyboardDidHide` notification
    /// is received. This will restore the scroll view's original content
    /// insets.
    ///
    /// - parameter notification: The `NSNotification.Name.UIKeyboardWillHide`
    ///   notification.
    @objc open func hidKeyboard(notification: Notification) {
        scrollView.contentInset = originalContentInsets
        scrollView.scrollIndicatorInsets = originalContentInsets
    }

    // MARK: - Registration

    /// Register with the default `NotificationCenter` to receive all four
    /// kinds of keyboard-visibility events.
    private func registerForNotifications() {
        let notifier = NotificationCenter.default
        notifier.addObserver(self,
                             selector: #selector(showKeyboard(notification:)),
                             name: UIResponder.keyboardWillShowNotification,
                             object: nil)
        notifier.addObserver(self,
                             selector: #selector(showedKeyboard(notification:)),
                             name: UIResponder.keyboardDidShowNotification,
                             object: nil)
        notifier.addObserver(self,
                             selector: #selector(hideKeyboard(notification:)),
                             name: UIResponder.keyboardWillHideNotification,
                             object: nil)
        notifier.addObserver(self,
                             selector: #selector(hidKeyboard(notification:)),
                             name: UIResponder.keyboardDidHideNotification,
                             object: nil)
    }

    /// Unregister from all keyboard-visibility events.
    private func unregisterFromNotifications() {
        let notifier = NotificationCenter.default
        notifier.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notifier.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        notifier.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        notifier.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }

}

