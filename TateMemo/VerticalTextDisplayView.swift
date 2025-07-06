import SwiftUI
import UIKit
import CoreText

// SwiftUI から使用するラッパービュー
struct VerticalTextDisplayView: UIViewRepresentable {
    let text: String

    func makeUIView(context: Context) -> VerticalTextUIView {
        let view = VerticalTextUIView()
        view.backgroundColor = .white
        view.text = text
        return view
    }

    func updateUIView(_ uiView: VerticalTextUIView, context: Context) {
        uiView.text = text
        uiView.setNeedsDisplay()
    }
}

// CoreText を使って縦書きを描画する UIView
class VerticalTextUIView: UIView {
    var text: String = ""

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        // 1. 座標系を初期化
        context.textMatrix = .identity

        // 2. UIKitのデフォルト座標は左上原点なので、左下原点に変換（Y軸を反転）
        context.translateBy(x: 0, y: bounds.height)
        context.scaleBy(x: 1.0, y: -1.0)

        // 3. 縦書きのために、左下を原点として反時計回りに90度回転
        context.rotate(by: -.pi / 2)
        context.translateBy(x: -bounds.height, y: 0)  // 描画位置を調整

        // 4. 描画領域（縦書きのために幅・高さを入れ替える）
        let path = CGMutablePath()
        path.addRect(CGRect(x: 0, y: 0, width: bounds.height, height: bounds.width))

        // 5. 縦書きテキストを CoreText で描画
        let attrString = NSAttributedString(string: text, attributes: [
            .font: UIFont(name: "Hiragino Mincho ProN", size: 40) ?? UIFont.systemFont(ofSize: 40),
            .foregroundColor: UIColor.black,
            kCTVerticalFormsAttributeName as NSAttributedString.Key: true
        ])

        let framesetter = CTFramesetterCreateWithAttributedString(attrString)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attrString.length), path, nil)
        CTFrameDraw(frame, context)
    }
}
