import UIKit
import CoreText

class VerticalTextInputView: UIView {
    
    // MARK: - テキスト保持
    private let textStorage = NSTextStorage()
    private let layoutManager = NSLayoutManager()
    private let textContainer = NSTextContainer(size: CGSize.zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
        private func commonInit() {
        // TextKitのセットアップ
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        textContainer.lineFragmentPadding = 0
        textContainer.widthTracksTextView = true
        textContainer.heightTracksTextView = true

        // 初期テキスト
        textStorage.setAttributedString(NSAttributedString(string: "", attributes: [
            .font: UIFont(name: "Hiragino Mincho ProN", size: 18)!
        ]))

        isUserInteractionEnabled = true
        becomeFirstResponder()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textContainer.size = bounds.size
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        // CoreText描画の代わりにTextKitを利用
        let range = layoutManager.glyphRange(for: textContainer)
        layoutManager.drawBackground(forGlyphRange: range, at: .zero)
        layoutManager.drawGlyphs(forGlyphRange: range, at: .zero)
    }
    
    func updateText(_ newText: String) {
        textStorage.setAttributedString(NSAttributedString(string: newText, attributes: [
            .font: UIFont(name: "Hiragino Mincho ProN", size: 18)!
        ]))
        setNeedsDisplay()
    }
    

}
