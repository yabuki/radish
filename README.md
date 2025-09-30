# radish
[NHKラジオ らじる★らじる](https://www.nhk.or.jp/radio/) / [radiko](http://radiko.jp/) / [ListenRadio](http://listenradio.jp/) / [渋谷のラジオ](https://shiburadi.com/) で現在配信中の番組を保存するシェルスクリプトです。なお配信形式と同じフォーマットで保存するため、別形式へのエンコードは行いません。

**2025-09-30** 2025-09-24あたりから、このスクリプトが動かなくて困っていました。

- [http://www.nhk.or.jp/radio/config/config_web.xml](https://gist.github.com/zixing8284/4ec2f633be7a4d89ae2ede0638e648c7)
    - を読むと、<http://www.nhk.or.jp/radio/config/config_web.xml>の中身が変わっているようです。

```
ffmpeg -loglevel error \
       -fflags +discardcorrupt \
       -http_persistent 0 \
       -http_multiple 1 \
       -i "https://simul.drdi.st.nhk/live/4/joined/master.m3u8" \
       -acodec copy -vn -bsf:a aac_adtstoasc \
       -t 7 -y /tmp/a.m4a
```
これでOsaka NHKR2が録音できました。　


# ※重要なお知らせ

**2025-05-16を最後に更新停止します。**

作者自身も長らく利用しておらずここで一旦区切りをつけることにしました。<br>
今までご愛顧いただき、誠にありがとうございました。

特にradikoライブ配信のタイムラグが大きくなっている(放送局の財布事情が厳しいためオーディオアドを導入するのはいいですがあまりにラグが酷い)割には不定期に発生する対処のモチベーションを保つことができなくなっていました。<br>
(余程の理由がない限りタイムフリー保存のほうが速いですし、タイムラグもライブ配信と比べて遙かに小さいです)

またここ最近は音声配信という括りで番組のPodcast等への公開や各種プラットフォーム側でのタイムシフト機能の実装により、わざわざ実放送時間にリアルタイム保存する意義は薄れていっていることも理由の一つです。

オープンソースですので修正・機能追加などはforkしてぜひ公開してください。


## 必要なもの
- curl
- libxml2 (xmllintのみ使用)
- jq
- FFmpeg (3.x以降 要AAC,HLSサポート)


## 使い方
```
$ ./radi.sh [options]
```

| 引数 | 必須 |説明 |備考 |
|:-|:-:|:-|:-|
|-t _SITE TYPE_|○|録音対象サイト|nhk: NHK らじる★らじる<br>radiko: radiko<br>lisradi: ListenRadio<br>shiburadi: 渋谷のラジオ
|-s _STATION ID_|△|放送局ID|`-l` オプションで表示されるID<br>渋谷のラジオは指定不要|
|-d _MINUTE_|○|録音時間(分)||
|-i _MAIL_||ラジコプレミアム ログインメールアドレス|環境変数 `RADIKO_MAIL` でも指定可能|
|-p _PASSWORD_||ラジコプレミアム ログインパスワード|環境変数 `RADIKO_PASSWORD` でも指定可能|
|-o _PATH_||出力パス|未指定の場合カレントディレクトリに `放送局ID_年月日時分秒.(m4a or mp3)` というファイルを作成<br>拡張子がない場合または配信側の形式と異なる場合には拡張子を自動補完します|
|-l||放送局ID/名称表示|結果は300行以上になります、また取得は(割と)重いです|


## 実行例
```
NHK らじる★らじる
$ ./radi.sh -t nhk -s tokyo-fm -d 31 -o "/hoge/foo.m4a"
```

```
radikoエリア内の局
$ ./radi.sh -t radiko -s LFR -d 21 -o "/hoge/$(date "+%Y-%m-%d") テレフォン人生相談.m4a"
```

```
radikoエリア外の局 (ラジコプレミアム)
$ ./radi.sh -t radiko -s HBC -d 31 -o "/hoge/foo.m4a" -i "foo@example.com" -p "password"
```

```
radikoエリア外の局 (ラジコプレミアム 環境変数からログイン情報設定)
$ export RADIKO_MAIL="foo@example.com"
$ export RADIKO_PASSWORD="password"
$ ./radi.sh -t radiko -s HBC -d 31 -o "/hoge/foo.m4a"
```

```
ListenRadio
$ ./radi.sh -t lisradi -s 30058 -d 30 -o "/hoge/foo.m4a"
```

```
渋谷のラジオ
$ ./radi.sh -t shiburadi -d 30 -o "/hoge/foo.mp3"
```


## 注意点

録音手法については2019/5/25時点での調査結果であり、対象サイトの仕様変更等で利用できなくなる可能性もありますのであらかじめご了承ください。<br>
また渋谷のラジオの録音時にではffmpegから "Application provided invalid, non monotonically increasing dts to muxer in stream" というメッセージが吐き出されるのですが、音声は聴けるようなのでとりあえずそのままにしています。


## 動作確認環境
- Ubuntu 18.04.2 LTS
    - curl 7.58.0
    - xmllint using libxml version 20904
    - jq 1.5-1-a5b5cbe
    - ffmpeg 4.1.3-0york1~18.04
- FreeBSD 12.0-RELEASE
    - curl 7.65.0
    - xmllint using libxml version 20908
    - jq 1.6
    - ffmpeg 4.1.3


##  作った人
うる。 ([@uru_2](https://twitter.com/uru_2))


## ライセンス
[MIT License](LICENSE)
