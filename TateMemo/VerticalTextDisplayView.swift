import SwiftUI

struct VerticalTextDisplayView: View {
    let text: String
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 背景
                Color.white
                
                // 縦書きテキスト（改行対応）
                HStack(alignment: .top, spacing: 0) {
                    ForEach(Array(verticalTextColumns.enumerated()), id: \.offset) { columnIndex, column in
                        VStack(alignment: .trailing, spacing: 0) {
                            ForEach(Array(column.enumerated()), id: \.offset) { charIndex, character in
                                Text(String(character))
                                    .font(.custom("Hiragino Mincho ProN", size: 36))
                                    .frame(width: 36, height: 36)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding()
            }
        }
    }
    
    // テキストを縦書きの列に分割（右から左の順序）
    private var verticalTextColumns: [[Character]] {
        let lines = text.components(separatedBy: .newlines)
        var columns: [[Character]] = []
        
        for line in lines {
            if !line.isEmpty {
                columns.append(Array(line))
            }
        }
        
        // 右から左の順序にするため、配列を逆順にする
        return columns.reversed()
    }
} 