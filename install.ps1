# ============================================================
# SE Panel インストーラー (Windows版)
# ============================================================

Write-Host ""
Write-Host "=============================="
Write-Host "  SE Panel インストーラー"
Write-Host "=============================="
Write-Host ""

$installDir = "$env:APPDATA\Adobe\CEP\extensions"
$tempDir = "$env:TEMP\SE-Panel-Install"

Write-Host "▶ Step 1: インストール先を準備..."
New-Item -ItemType Directory -Force -Path $installDir | Out-Null
New-Item -ItemType Directory -Force -Path "$tempDir\SE-Panel\CSXS" | Out-Null
New-Item -ItemType Directory -Force -Path "$tempDir\SE-Panel\jsx" | Out-Null

Write-Host "▶ Step 2: ファイルをダウンロード..."
$base = "https://raw.githubusercontent.com/misato-yaya/se-panel/main/SE-Panel"
Invoke-WebRequest "$base/index.html" -OutFile "$tempDir\SE-Panel\index.html" -UseBasicParsing
Invoke-WebRequest "$base/CSXS/manifest.xml" -OutFile "$tempDir\SE-Panel\CSXS\manifest.xml" -UseBasicParsing
Invoke-WebRequest "$base/jsx/host.jsx" -OutFile "$tempDir\SE-Panel\jsx\host.jsx" -UseBasicParsing
Invoke-WebRequest "https://raw.githubusercontent.com/Adobe-CEP/CEP-Resources/master/CEP_11.x/CSInterface.js" -OutFile "$tempDir\SE-Panel\CSInterface.js" -UseBasicParsing
Write-Host "  ✓ 完了"

Write-Host "▶ Step 3: デバッグモードを有効化..."
9..13 | ForEach-Object {
    $p = "HKCU:\Software\Adobe\CSXS.$_"
    if (-not (Test-Path $p)) { New-Item -Path $p -Force | Out-Null }
    Set-ItemProperty -Path $p -Name "PlayerDebugMode" -Value "1" -Type String -Force
}
Write-Host "  ✓ 完了"

Write-Host "▶ Step 4: インストール..."
if (Test-Path "$installDir\SE-Panel") { Remove-Item -Recurse -Force "$installDir\SE-Panel" }
Copy-Item -Recurse "$tempDir\SE-Panel" "$installDir\SE-Panel"
Remove-Item -Recurse -Force $tempDir
Write-Host "  ✓ 完了"

Write-Host ""
Write-Host "▶ Step 5: ffmpegの確認..."
if (Get-Command ffmpeg -ErrorAction SilentlyContinue) {
    Write-Host "  ✓ ffmpegはすでにインストールされています"
} else {
    Write-Host ""
    Write-Host "  ffmpegは音量の自動統一機能に必要です。"
    $yn = Read-Host "  ffmpegをインストールしますか？ (y/n)"
    if ($yn -eq "y" -or $yn -eq "Y") {
        Write-Host "  ffmpegをインストールしています..."
        winget install ffmpeg
        Write-Host "  ✓ ffmpegインストール完了"
    } else {
        Write-Host "  スキップしました（後で winget install ffmpeg で追加できます）"
    }
}

Write-Host ""
Write-Host "=============================="
Write-Host "  インストール完了！"
Write-Host "=============================="
Write-Host ""
Write-Host "次のステップ："
Write-Host "  1. Premiere Pro を再起動"
Write-Host "  2. ウィンドウ → エクステンション → SE Panel を開く"
Write-Host "  3. 「選択」でSEフォルダを指定"
Write-Host "  4. 「正規化」で音量を統一（初回のみ）"
Write-Host ""
Read-Host "Enterキーを押して終了"
