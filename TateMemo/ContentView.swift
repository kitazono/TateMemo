import SwiftUI

// MARK: - メモ保存・読み込み機能
/// UserDefaultsからメモを読み込む
func loadMemos() -> [String] {
    return UserDefaults.standard.stringArray(forKey: "savedMemos") ?? []
}

/// UserDefaultsにメモを保存する
func saveMemos(_ memos: [String]) {
    UserDefaults.standard.set(memos, forKey: "savedMemos")
}

// MARK: - メインコンテンツビュー
/// 縦書きメモアプリのメイン画面
/// メモの一覧表示、追加、削除機能を提供
struct ContentView: View {
    // MARK: - 状態管理
    /// 保存されたメモの配列
    @State private var memos: [String] = loadMemos()
    /// メモ追加画面の表示状態
    @State private var showingAddMemo = false

    var body: some View {
        NavigationView {
            List {
                // メモ一覧の表示
                ForEach(memos.indices, id: \.self) { index in
                    NavigationLink(destination: MemoDetailView(
                        text: memos[index],
                        memoIndex: index,
                        onUpdate: updateMemo
                    )) {
                        Text(memos[index])
                            .lineLimit(1) // 1行に制限してプレビュー表示
                    }
                }
                .onDelete(perform: deleteMemo) // スワイプ削除機能
            }
            .navigationTitle("縦書きメモ")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    // メモ追加ボタン
                    Button(action: {
                        showingAddMemo = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddMemo) {
                // メモ追加画面をモーダル表示
                AddMemoView { newMemo in
                    memos.append(newMemo)
                    saveMemos(memos) // メモを保存
                    showingAddMemo = false
                }
            }
        }
    }

    // MARK: - メソッド
    /// 指定されたインデックスのメモを削除
    /// - Parameter offsets: 削除するメモのインデックスセット
    private func deleteMemo(at offsets: IndexSet) {
        memos.remove(atOffsets: offsets)
        saveMemos(memos) // メモを保存
    }
    
    /// 指定されたインデックスのメモを更新
    /// - Parameters:
    ///   - index: 更新するメモのインデックス
    ///   - newText: 新しいテキスト内容
    private func updateMemo(index: Int, newText: String) {
        memos[index] = newText
        saveMemos(memos) // メモを保存
    }
}

// MARK: - プレビュー
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: - メモ追加ビュー
/// 新しいメモを追加するためのモーダル画面
struct AddMemoView: View {
    // MARK: - プロパティ
    /// モーダルの表示制御
    @Environment(\.presentationMode) var presentationMode
    /// 新規メモのテキスト内容
    @State private var newMemoText = ""
    /// 保存時のコールバック関数
    var onSave: (String) -> Void

    var body: some View {
        NavigationView {
            VStack {
                // テキスト入力エリア
                TextEditor(text: $newMemoText)
                    .frame(height: 400)
                    .padding()
            }
            .navigationTitle("メモを追加")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    // 保存ボタン
                    Button("保存") {
                        // 空文字でない場合のみ保存
                        if !newMemoText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            onSave(newMemoText)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
        }
    }
}

// MARK: - メモ詳細ビュー
/// 選択されたメモの詳細を表示する画面
struct MemoDetailView: View {
    /// 表示するメモのテキスト
    @State private var text: String
    /// 編集モードの状態
    @State private var isEditing = false
    /// メモのインデックス（更新用）
    let memoIndex: Int
    /// メモ更新時のコールバック
    let onUpdate: (Int, String) -> Void

    init(text: String, memoIndex: Int, onUpdate: @escaping (Int, String) -> Void) {
        self._text = State(initialValue: text)
        self.memoIndex = memoIndex
        self.onUpdate = onUpdate
    }

    var body: some View {
        VStack {
            if isEditing {
                // 編集モード
                TategakiTextView(text: $text)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
            } else {
                // 表示モード
                VerticalTextDisplayView(text: text)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
            }
        }
        .navigationTitle("メモ詳細")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(isEditing ? "完了" : "編集") {
                    if isEditing {
                        // 編集完了時
                        onUpdate(memoIndex, text)
                    }
                    isEditing.toggle()
                }
            }
        }
    }
}


