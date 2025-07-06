import SwiftUI
import UIKit

struct TategakiTextView: UIViewRepresentable {
    @Binding var text: String

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        
        textView.text = text
        textView.delegate = context.coordinator
        textView.font = UIFont(name: "Hiragino Mincho ProN", size: 18) ?? UIFont.systemFont(ofSize: 18)
        textView.backgroundColor = UIColor.white
        textView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        // 縦書き表示の設定
        textView.textAlignment = .right
        
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: TategakiTextView

        init(_ parent: TategakiTextView) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
    }
}
