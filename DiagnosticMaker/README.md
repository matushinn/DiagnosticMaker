#  このアプリで学べること
名言APIを用いたシンプルなXML解析
Twitterログインを実装する方法
SNSへのシェア
可変せる(高さが自動で変化する)セルの作り方
タイムラインへの投稿
タイムラインへの表示


##このアプリの仕組み

①各名言APIから名言をランダムに一つ取得
②Twitter画像URL
　ユーザー名
　名言
　現在時刻
　をFireStoreへ送信

③FireStoreには②の集合体が存在する
これをFireStoreから受信して終了

