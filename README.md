# Dotfilesわよ
## 手順

# 作成方針
設定ファイルをリポジトリにコピー，もとのファイルは.backupとかにして退避．リポジトリからシンボリックリンクを貼るが基本になるらしい．

インストーラーの作成
make?

## Arch Linuxのパッケージ管理
```bash
yay -S --needed - < pkglist.lst
```
## config
`$HOME`から各configファイルまでの相対パスを，`config`を起点に一致させてる．

### リポジトリへのコピー
configファイルをリポジトリにコピーする際に--parentsオプションを使うと相対パスを維持したままファイルコピーできる
```bash
cd ~/
cp --parents .config/hoge/fuga.json /to_dotfile_repository/dotfiles_pub/config/
```

### リンク


# 設定方法が特殊な人たちの備忘録
## GNOMEの設定
dconfというデータベースですべての設定が管理されている．
設定のエクスポートには，
```bash
dconf dump /path/to/dconf/settings/ > dumpfile.ini
```
ルートを指定すると全部出力される．変更したいものだけを残す．
[設定のインポート](https://bgstack15.wordpress.com/2017/10/04/dconf-save-and-load-from-file/)には
```bash
dconf load / < dumpfile.ini
```
## mozcの設定
インプットメソッドに関わらず，変換時のキーと挙動を制御できる．
現状，MS-IMEのキーマップを元に変換キーでIMEをON, 無変換キーでIMEをOFF, tabキーで変換中の最初の文節を確定あたりの設定をしている
