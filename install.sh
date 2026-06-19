#!/bin/bash

set -e

INSTALL_DIR="/Library/Application Support/Adobe/CEP/extensions"
PANEL_DIR="$INSTALL_DIR/SE-Panel"
BASE_URL="https://raw.githubusercontent.com/misato-yaya/se-panel/main/SE-Panel"
TEMP_DIR=$(mktemp -d)

echo ""
echo "=============================="
echo "  SE Panel インストーラー"
echo "=============================="
echo ""

echo "▶ Step 1: デバッグモードを有効化しています..."
for version in 9 10 11 12 13; do
  defaults write com.adobe.CSXS.$version PlayerDebugMode 1 2>/dev/null || true
done
echo "  ✓ 完了"

echo ""
echo "▶ Step 2: ファイルをダウンロードしています..."
mkdir -p "$TEMP_DIR/SE-Panel/CSXS"
mkdir -p "$TEMP_DIR/SE-Panel/jsx"

curl -sf -o "$TEMP_DIR/SE-Panel/index.html" "$BASE_URL/index.html" || { echo "  ✗ 失敗"; exit 1; }
curl -sf -o "$TEMP_DIR/SE-Panel/CSXS/manifest.xml" "$BASE_URL/CSXS/manifest.xml" || { echo "  ✗ 失敗"; exit 1; }
curl -sf -o "$TEMP_DIR/SE-Panel/jsx/host.jsx" "$BASE_URL/jsx/host.jsx" || { echo "  ✗ 失敗"; exit 1; }
curl -sf -o "$TEMP_DIR/SE-Panel/CSInterface.js" "https://raw.githubusercontent.com/Adobe-CEP/CEP-Resources/master/CEP_11.x/CSInterface.js" || { echo "  ✗ 失敗"; exit 1; }
echo "  ✓ 完了"

echo ""
echo "▶ Step 3: SE Panel をインストールしています..."
sudo mkdir -p "$INSTALL_DIR"
sudo rm -rf "$PANEL_DIR"
sudo cp -r "$TEMP_DIR/SE-Panel" "$PANEL_DIR"
rm -rf "$TEMP_DIR"
echo "  ✓ 完了"

echo ""
echo "▶ Step 4: ffmpegの確認..."
if command -v ffmpeg &>/dev/null; then
  echo "  ✓ ffmpegはすでにインストールされています"
else
  echo ""
  echo "  ffmpegは音量の自動統一機能に必要です。"
  read -p "  ffmpegをインストールしますか？ (y/n): " yn
  if [ "$yn" = "y" ] || [ "$yn" = "Y" ]; then
    if ! command -v brew &>/dev/null; then
      echo "  Homebrewをインストールしています..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew install ffmpeg
    echo "  ✓ ffmpegインストール完了"
  else
    echo "  スキップしました"
  fi
fi

echo ""
echo "=============================="
echo "  インストール完了！"
echo "=============================="
echo ""
echo "次のステップ："
echo "  1. Premiere Pro を再起動"
echo "  2. ウィンドウ → エクステンション → SE Panel を開く"
echo "  3. 「選択」でSEフォルダのパスを入力"
echo "  4. 「正規化」で音量を統一（初回のみ）"
echo ""
