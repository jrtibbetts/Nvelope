//  Copyright © 2017 nrith. All rights reserved.

import UIKit

/// The main view controller of the Nvelope application. It will tokenize and
/// display any text that you drop onto or enter manually into it, or the
/// contents of a URL.s
open class TextInputViewController: UIViewController {

    // MARK: - Outlets

    /// The main text view.
    @IBOutlet weak var textView: UITextView!

    /// The web view that displays the contents of a URL that was entered
    /// manually.
    @IBOutlet weak var webView: UIWebView!

    /// The text field that's in the instructional view that "floats" over the
    /// text or web view. When a user enters a URL and hits enter, the
    /// floating view fades out and topUrlField springs to the top of the view.
    @IBOutlet weak var floatingUrlField: UITextField!

    /// The text field that's at the top of the web view.
    @IBOutlet weak var topUrlField: UITextField!

    /// The grid of part-of-speech buttons that can be toggled to highlight
    /// tokens of the desired type in the text or web view.
    @IBOutlet weak var tokenTypeButtons: UICollectionView!

    override open func viewDidLoad() {
        super.viewDidLoad()

        
    }

}

