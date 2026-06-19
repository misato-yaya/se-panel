# SE Panel - インストール・使い方ガイド

## インストール方法

### 1. デバッグモードを有効にする（初回のみ）

ターミナルを開いて以下を実行：

```bash
defaults write com.adobe.CSXS.11 PlayerDebugMode 1
```

※ Premiere Pro のバージョンによって数字が変わります
- Premiere 2024 (v24) → CSXS.11
- Premiere 2023 (v23) → CSXS.10
- Premiere 2022 (v22) → CSXS.9

バージョンが不明な場合は全部実行しても問題ありません。

### 2. プラグインフォルダに配置

`SE-Panel` フォルダをそのまま以下の場所にコピー：

```
/Library/Application Support/Adobe/CEP/extensions/SE-Panel
```

ターミナルで実行する場合：
```bash
sudo cp -r /path/to/SE-Panel "/Library/Application Support/Adobe/CEP/extensions/"
```

### 3. CSInterface.js をダウンロード

以下のURLからCSInterface.jsをダウンロードして `SE-Panel/` フォルダ内に置く：

```
https://github.com/Adobe-CEP/CEP-Resources/raw/master/CEP_11.x/CSInterface.js
```

ターミナルで：
```bash
curl -o "/Library/Application Support/Adobe/CEP/extensions/SE-Panel/CSInterface.js" \
  "https://raw.githubusercontent.com/Adobe-CEP/CEP-Resources/master/CEP_11.x/CSInterface.js"
```

### 4. Premiere Pro を再起動

起動後、メニューの **ウィンドウ → 拡張機能 → SE Panel** から開く。

---

## 使い方

1. **SEフォルダを選択** → 「選択」ボタンを押してSEルートフォルダのパスを入力
   - 例: `/Users/misatoyamazaki/書類/動画編集用フォルダ/★よく使う効果音`
   - フォルダ構造がそのままカテゴリになります

2. **カテゴリを選択** → タブをクリック

3. **SEをクリック** → 再生ヘッドの位置に自動配置 + 音量調整

4. **音量・トラック変更** → パネル上部で設定（設定は保存されます）

---

## フォルダ構造の例

```
★よく使う効果音/
├── 01_ポジティブ・盛り上げ系/
│   ├── ジャーン.wav
│   └── ファンファーレ.wav
├── 02_ネガティブ系/
│   ├── チーン.wav
│   └── ズコー.wav
├── 03_短音/
│   └── ...
├── 04_特定シーン/
│   └── ...
└── 05_トランジション/
    └── ...
```

フォルダ名の先頭に `01_` `02_` などをつけると順番通りに並びます。

---

## トラブルシューティング

| 症状 | 対処 |
|------|------|
| メニューに「SE Panel」が出ない | デバッグモード有効化を確認 / Premiere再起動 |
| 「挿入に失敗」と出る | アクティブなシーケンスが開いているか確認 |
| SEが見つからない | フォルダパスが正しいか確認（日本語パスはOK） |

---

## アップデート方法

`/Library/Application Support/Adobe/CEP/extensions/SE-Panel/` の中身を上書きするだけ。
Premiere を再起動すれば反映されます。
