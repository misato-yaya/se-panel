#!/bin/bash

set -e

PANEL_NAME="SE-Panel"
INSTALL_DIR="/Library/Application Support/Adobe/CEP/extensions"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

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
echo "▶ Step 2: CSInterface.js をダウンロードしています..."
CSINTERFACE_URL="https://raw.githubusercontent.com/Adobe-CEP/CEP-Resources/master/CEP_11.x/CSInterface.js"
if curl -sf -o "$SCRIPT_DIR/$PANEL_NAME/CSInterface.js" "$CSINTERFACE_URL"; then
  echo "  ✓ 完了"
else
  echo "  ✗ ダウンロード失敗。インターネット接続を確認してください。"
  exit 1
fi

echo ""
echo "▶ Step 3: SE Panel をインストールしています..."
sudo mkdir -p "$INSTALL_DIR"
sudo cp -r "$SCRIPT_DIR/$PANEL_NAME" "$INSTALL_DIR/"
echo "  ✓ 完了"

echo ""
echo "=============================="
echo "  インストール完了！"
echo "=============================="
echo ""
echo "次のステップ："
echo "  1. Premiere Pro を再起動"
echo "  2. ウィンドウ → エクステンション → SE Panel を開く"
echo "  3. 「選択」でSEフォルダを指定"
echo "  4. 「正規化」で音量を統一（初回のみ）"
echo ""
