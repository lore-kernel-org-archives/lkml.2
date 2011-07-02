Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab1GBMj2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 08:39:28 -0400
Received: from TYO200.gate.nec.co.jp ([202.32.8.215]:55591 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571Ab1GBMjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 08:39:24 -0400
Message-ID: <4E0F0ECF.4060704@bx.jp.nec.com>
Date: Sat, 02 Jul 2011 08:27:59 -0400
From: Keiichi KII <k-keiichi@bx.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] updated Documentation/ja_JP/SubmittingPatches
References: <4DFBF50D.2020705@bx.jp.nec.com> <20110701221432.GA31632@kroah.com>
In-Reply-To: <20110701221432.GA31632@kroah.com>
Content-Type: multipart/mixed;
 boundary="------------090706060104020306030002"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090706060104020306030002
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello,

Thank you for your reply.
I send the patch as an attachment again.
And I confirmed I can apply it to the 2.6.39 kernel.

Thanks,
Keiichi


(07/01/11 18:14), Greg KH wrote:
> On Fri, Jun 17, 2011 at 08:45:01PM -0400, Keiichi KII wrote:
>> From: Keiichi Kii <k-keiichi@bx.jp.nec.com>
>>
>> Updated Documentaion/ja_JP/SubmittingPatches due to changes from upstream
>> version(2.6.39) of the file.
>>
>> And also, this translated SubmittingPatches is already reviewed by JF
>> project. The JF project is the Japanese equivalent of LDP.
>>
>> Signed-off-by: Keiichi Kii <k-keiichi@bx.jp.nec.com>
>> ---
> 
> For some reason I can't seem to apply this, can you send the patch to me
> compressed or as an attachment so I can properly add it?
> 
> thanks,
> 
> greg k-h


--------------090706060104020306030002
Content-Type: text/plain;
 name="sync-for-ja_jp-submittingpatches.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="sync-for-ja_jp-submittingpatches.patch"

From: Keiichi Kii <k-keiichi@bx.jp.nec.com>

Updated Documentaion/ja_JP/SubmittingPatches due to changes from upstream
version(2.6.39) of the file.

And also, this translated SubmittingPatches is already reviewed by JF
project. The JF project is the Japanese equivalent of LDP.

Signed-off-by: Keiichi Kii <k-keiichi@bx.jp.nec.com>
---

 Documentation/ja_JP/SubmittingPatches |  258 +++++++++++++++++++++++++++------
 1 files changed, 213 insertions(+), 45 deletions(-)


diff --git a/Documentation/ja_JP/SubmittingPatches b/Documentation/ja_JP/SubmittingPatches
index f107c83..97f78dd 100644
--- a/Documentation/ja_JP/SubmittingPatches
+++ b/Documentation/ja_JP/SubmittingPatches
@@ -11,16 +11,18 @@ for non English (read: Japanese) speakers and is not intended as a
 fork. So if you have any comments or updates of this file, please try
 to update the original English file first.
 
-Last Updated: 2007/10/24
+Last Updated: 2011/06/09
+
 ==================================
 これは、
-linux-2.6.23/Documentation/SubmittingPatches の和訳
+linux-2.6.39/Documentation/SubmittingPatches の和訳
 です。
 翻訳団体： JF プロジェクト < http://www.linux.or.jp/JF/ >
-翻訳日： 2007/10/17
+翻訳日： 2011/06/09
 翻訳者： Keiichi Kii <k-keiichi at bx dot jp dot nec dot com>
 校正者： Masanari Kobayashi さん <zap03216 at nifty dot ne dot jp>
          Matsukura さん <nbh--mats at nifty dot com>
+         Takeshi Hamasaki さん <hmatrjp at users dot sourceforge dot jp>
 ==================================
 
         Linux カーネルに変更を加えるための Howto
@@ -97,7 +99,7 @@ Quilt:
 http://savannah.nongnu.org/projects/quilt
 
 Andrew Morton's patch scripts:
-http://userweb.kernel.org/~akpm/stuff/tpp.txt
+http://userweb.kernel.org/~akpm/stuff/patch-scripts.tar.gz
 このリンクの先のスクリプトの代わりとして、quilt がパッチマネジメント
 ツールとして推奨されています(上のリンクを見てください)。
 
@@ -109,9 +111,25 @@ http://userweb.kernel.org/~akpm/stuff/tpp.txt
 「ドライバー X に対するバグフィックス」あるいは「このパッチはサブシス
 テム X に対する更新を含んでいます。どうか取り入れてください。」などです。
 
+パッチの説明を Linux カーネルのソースコードマネジメントシステム「 git 」の
+コミットログとして簡単に引用できる形で書けば、メンテナから感謝されるでしょう。
+以下の #15 を見てください。
+
 説明が長くなりだしたのであれば、おそらくそれはパッチを分ける必要がある
 という兆候です。次の #3 を見てください。
 
+パッチ(シリーズ)を(再)投稿する時、十分なパッチの説明とそのパッチが必要な理由を
+パッチに含めてください。ただ「これはパッチ(シリーズ)のバージョン N」とだけ
+書かないでください。そして、パッチをマージする人にパッチの説明を探させそれを
+パッチに追記させるため、過去のバージョンのパッチやそのパッチの URL を参照する
+手間をかけさせないでください。
+つまり、パッチシリーズとその説明は一緒にあるべきです。これはパッチをマージする
+人、レビューする人、どちらのためにもなります。レビューする人の中には、おそらく
+過去のバージョンのパッチを受け取ってもいない人がいます。
+
+登録済みのバグエントリを修正するパッチであれば、そのバグエントリを示すバグ ID
+や URL を明記してください。
+
 3) パッチの分割
 
 意味のあるひとまとまりごとに変更を個々のパッチファイルに分けてください。
@@ -141,7 +159,7 @@ http://userweb.kernel.org/~akpm/stuff/tpp.txt
 拒否されるでしょう。
 
 あなたはパッチを投稿する前に最低限パッチスタイルチェッカー
-( scripts/patchcheck.pl )を利用してパッチをチェックすべきです。
+( scripts/checkpatch.pl )を利用してパッチをチェックすべきです。
 もしパッチに違反がのこっているならば、それらの全てについてあなたは正当な
 理由を示せるようにしておく必要があります。
 
@@ -192,13 +210,13 @@ VGER.KERNEL.ORG でホスティングされているメーリングリストの
 情報がマニュアルページの中に入ってくるように、変更が起きたという
 通知を送ってください。
 
-たとえ、メンテナが #4 で反応がなかったとしても、メンテナのコードに変更を
+たとえ、メンテナが #5 で反応がなかったとしても、メンテナのコードに変更を
 加えたときには、いつもメンテナに CC するのを忘れないようにしてください。
 
-小さなパッチであれば、Adrian Bunk が管理している Trivial Patch Monkey
-(ちょっとしたパッチを集めている)<trivial@kernel.org>に CC してもいい
-です。ちょっとしたパッチとは以下のルールのどれか1つを満たしていなけ
-ればなりません。
+小さなパッチであれば、Trivial Patch Monkey(ちょっとしたパッチを集めている)
+<trivial@kernel.org>に CC してもいいです。その現管理者については MAINTAINERS
+ファイルを見てください。ちょっとしたパッチとは以下のルールのどれか1つを満たして
+いなければなりません。
  ・ドキュメントのスペルミスの修正
  ・grep(1) コマンドによる検索を困難にしているスペルの修正
  ・コンパイル時の警告の修正(無駄な警告が散乱することは好ましくないた
@@ -210,7 +228,6 @@ VGER.KERNEL.ORG でホスティングされているメーリングリストの
  ・移植性のないコードから移植性のあるコードへの置き換え(小さい範囲で
    あればアーキテクチャ特有のことでも他の人がコピーできます)
  ・作者やメンテナによる修正(すなわち patch monkey の再転送モード)
-EMAIL: <trivial@kernel.org>
 
 7) MIME やリンクや圧縮ファイルや添付ファイルではなくプレインテキストのみ
 
@@ -233,26 +250,15 @@ MIME 形式の添付ファイルは Linus に手間を取らせることにな
 例外：お使いの電子メールクライアントがパッチをめちゃくちゃにするので
 あれば、誰かが MIME 形式のパッチを再送するよう求めるかもしれません。
 
-警告： Mozilla のような特定の電子メールクライアントは電子メールの
-ヘッダに以下のものを付加して送ります。
----- message header ----
-Content-Type: text/plain; charset=us-ascii; format=flowed
----- message header ----
-問題は、「 format=flowed 」が付いた電子メールを特定の受信側の電子メール
-クライアントがタブをスペースに置き換えるというような変更をすることです。
-したがって送られてきたパッチは壊れているように見えるでしょう。
-
-これを修正するには、mozilla の defaults/pref/mailnews.js ファイルを
-以下のように修正します。
-pref("mailnews.send_plaintext_flowed", false); // RFC 2646=======
-pref("mailnews.display.disable_format_flowed_support", true);
+余計な変更を加えずにあなたのパッチを送信するための電子メールクライアントの設定
+のヒントについては Documentation/email-clients.txt を参照してください。
 
 8) 電子メールのサイズ
 
 パッチを Linus へ送るときは常に #7 の手順に従ってください。
 
 大きなパッチはメーリングリストやメンテナにとって不親切です。パッチが
-未圧縮で 40KB を超えるようであるなら、インターネット上のアクセス可能な
+未圧縮で 300KB を超えるようであるなら、インターネット上のアクセス可能な
 サーバに保存し、保存場所を示す URL を伝えるほうが適切です。
 
 9) カーネルバージョンの明記
@@ -324,7 +330,7 @@ Linus や LKML への大量の電子メールのために、サブジェクト
         (c) 本寄与は(a)、(b)、(c)を証明する第3者から私へ直接提供された
             ものであり、私はそれに変更を加えていない。
 
-	(d) 私はこのプロジェクトと本寄与が公のものであることに理解及び同意す
+        (d) 私はこのプロジェクトと本寄与が公のものであることに理解及び同意す
             る。同時に、関与した記録(投稿の際の全ての個人情報と sign-off を
             含む)が無期限に保全されることと、当該プロジェクト又は関連する
             オープンソースライセンスに沿った形で再配布されることに理解及び
@@ -340,7 +346,51 @@ Linus や LKML への大量の電子メールのために、サブジェクト
 無視されますが、あなたはそのタグを社内の手続きに利用したり、sign-off に特別
 な情報を示したりすることができます。
 
-13) いつ Acked-by: を使うのか
+あなたがサブシステムまたはブランチのメンテナであれば、受け取ったパッチを自身の
+ツリーにマージするために、わずかに変更が必要となる場合があります。なぜなら
+あなたのツリーの中のコードと投稿者のツリーの中のコードは同一ではないためです。
+もし、あなたが厳密に上記ルール(c)にこだわるのであれば、投稿者に再度差分を
+とるよう依頼すべきです。しかし、これは時間とエネルギーを非生産的に浪費する
+ことになります。ルール(b)はあなたにコードを修正する権利を与えてくれます。
+しかし、投稿者のコードを修正し、その修正によるバグを投稿者に押し付けてしまう
+ことはとても失礼なことです。この問題を解決するために、末尾の投稿者の
+Signed-off-by とあなたがその末尾に追加する Signed-off-by の間に、修正を
+加えたことを示す1行を追加することが推奨されています。
+(その1行の書き方に)決まりはありませんが、大括弧の中に電子メールアドレスや氏名
+と修正内容を記載するやり方は目につきやすく、最終段階での変更の責任があなたに
+あることを明確にするのに十分な方法のようです。例えば、
+
+	Signed-off-by: Random J Developer <random@developer.example.org>
+	[lucky@maintainer.example.org: struct foo moved from foo.c to foo.h]
+	Signed-off-by: Lucky K Maintainer <lucky@maintainer.example.org>
+
+あなたが安定版のブランチを管理しており、作成者のクレジット、変更の追跡、
+修正のマージ、と同時に苦情からの投稿者の保護を行いたい場合、この慣習は特に
+有用となります。いかなる事情があってもチェンジログに出てくる作成者の
+アイデンティティ情報(From ヘッダ)は変更できないことに注意してください。
+
+バックポートする人のための特別な注意事項。追跡を容易に行うために、コミット
+メッセージのトップ(サブジェクト行のすぐ後)にパッチの起源を示す情報を記述する
+ことは一般的で有用な慣習です。例えば、これは 2.6-stable ツリーでの一例です。    
+
+    Date:   Tue May 13 19:10:30 2008 +0000
+
+        SCSI: libiscsi regression in 2.6.25: fix nop timer handling
+
+        commit 4cf1043593db6a337f10e006c23c69e5fc93e722 upstream
+
+そして、これは 2.4 ツリーでの一例です。
+
+    Date:   Tue May 13 22:12:27 2008 +0200
+
+        wireless, airo: waitbusy() won't delay
+
+        [backport of 2.6 commit b7acbdfbd1f277c1eb23f344f899cfa4cd0bf36a]
+
+どんな形式であれ、この情報はあなたのツリーを追跡する人やあなたのツリーのバグを
+解決しようとしている人にとって価値のある支援となります。
+
+13) いつ Acked-by: と Cc: を使うのか
 
 「 Signed-off-by: 」タグはその署名者がパッチの開発に関わっていたことやパッチ
 の伝播パスにいたことを示しています。
@@ -354,7 +404,7 @@ Linus や LKML への大量の電子メールのために、サブジェクト
 
 Acked-by: は Signed-off-by: のように公式なタグではありません。それはメンテナが
 少なくともパッチをレビューし、同意を示しているという記録です。そのような
-ことからパッチの統合者がメンテナの「うん、良いと思うよ」という発言を
+ことからパッチをマージする人がメンテナの「うん、良いと思うよ」という発言を
 Acked-by: へ置き換えることがあります。
 
 Acked-by: が必ずしもパッチ全体の承認を示しているわけではありません。例えば、
@@ -364,7 +414,62 @@ Acked-by: が必ずしもパッチ全体の承認を示しているわけでは
 この点は、ご自分で判断してください。(その Acked-by: が)疑わしい場合は、
 メーリングリストアーカイブの中の大元の議論を参照すべきです。
 
-14) 標準的なパッチのフォーマット
+パッチにコメントする機会を持っていたが、その時にコメントしなかった人がいれば、
+その人を指す「Cc:」タグを任意で追加してもかまいません。これは指定された人からの
+明確なアクションなしに付与できる唯一のタグです。
+このタグはパッチに関心があると思われる人達がそのパッチの議論に含まれていたこと
+を明文化します。
+
+14) Reported-by と Tested-by: と Reviewed-by: の利用
+
+他の誰かによって報告された問題を修正するパッチであれば、問題報告者という寄与を
+クレジットするために、Reported-by: タグを追加することを検討してください。
+こまめにバグ報告者をクレジットしていくことで、うまくいけばその人たちが将来再び
+コミュニティの力となってくれるでしょう。
+ただし、報告者の許可無くこのタグを追加しないように注意してください。特に、
+問題が公の場で報告されていなかったのであれば。
+
+Tested-by: タグはタグで指定された人によって(ある環境下で)パッチのテストに成功
+していることを示します。このタグはメンテナにテストが実施済みであることを
+知らせ、将来の関連パッチのテスト協力者を見つける方法を提供し、テスト実施者に
+対するクレジットを保証します。
+
+Reviewed-by: タグは、それとは異なり、下記のレビューア宣言の下にレビューされ、
+受け入れ可能とみなされたパッチであることを示します。
+
+        レビューアによる監督宣言
+
+        私は Reviewed-by: タグを提示することによって、以下のことを明言する。
+
+        (a) 私はメインラインカーネルへの統合に向け、その妥当性及び「即応性
+            (訳注)」を検証し、技術的側面からパッチをレビュー済みである。
+
+        訳注:
+        「即応性」の原文は "readiness"。
+        パッチが十分な品質を持っており、メインラインカーネルへの統合を即座に
+        行うことができる状態であるかどうかを "readiness" という単語で表現
+        している。
+
+        (b) パッチに関するあらゆる問題、懸念、あるいは、疑問は投稿者へ伝達済み
+            である。私はそれらのコメントに対する投稿者の返答に満足している。
+
+        (c) 投稿に伴い改良されるコードがある一方で、現時点で、私は(1)それが
+            カーネルにとって価値のある変更であること、そして、(2)統合に際して
+            議論になり得るような問題はないものと確信している。
+
+        (d) 私はパッチをレビューし適切であると確信している一方で、あらゆる
+            状況においてその宣言した目的や機能が正しく実現することに関して、
+            いかなる保証もしない(特にどこかで明示しない限り)。
+
+Reviewd-by タグはそのパッチがカーネルに対して適切な修正であって、深刻な技術的
+問題を残していないという意見の宣言です。興味のあるレビューアは誰でも(レビュー
+作業を終えたら)パッチに対して Reviewed-by タグを提示できます。このタグは
+レビューアの寄与をクレジットする働き、レビューの進捗の度合いをメンテナに
+知らせる働きを持ちます。そのパッチの領域に詳しく、そして、しっかりとした
+レビューを実施したレビューアによって提供される時、Reviewed-by: タグがあなたの
+パッチをカーネルにマージする可能性を高めるでしょう。
+
+15) 標準的なパッチのフォーマット
 
 標準的なパッチのサブジェクトは以下のとおりです。
 
@@ -396,18 +501,37 @@ Acked-by: が必ずしもパッチ全体の承認を示しているわけでは
 電子メールのサブジェクト内のサブシステム表記は、パッチが適用される
 分野またはサブシステムを識別できるようにすべきです。
 
-電子メールのサブジェクトの「概要の言い回し」はそのパッチの概要を正確
-に表現しなければなりません。「概要の言い回し」をファイル名にしてはい
-けません。一連のパッチ中でそれぞれのパッチは同じ「概要の言い回し」を
-使ってはいけません(「一連のパッチ」とは順序付けられた関連のある複数の
+電子メールのサブジェクトの「summary phrase」はそのパッチの概要を正確
+に表現しなければなりません。「summary phrase」をファイル名にしてはい
+けません。パッチシリーズ中でそれぞれのパッチは同じ「summary phrase」を
+使ってはいけません(「パッチシリーズ」とは順序付けられた関連のある複数の
 パッチ群です)。
 
-あなたの電子メールの「概要の言い回し」がそのパッチにとって世界で唯
-一の識別子になるように心がけてください。「概要の言い回し」は git の
-チェンジログの中へずっと伝播していきます。「概要の言い回し」は、開
-発者が後でパッチを参照するために議論の中で利用するかもしれません。
-人々はそのパッチに関連した議論を読むために「概要の言い回し」を使って
-google で検索したがるでしょう。
+あなたの電子メールの「summary phrase」がそのパッチにとって世界で唯一の識別子に
+なるように心がけてください。「summary phrase」は git のチェンジログの中へ
+ずっと伝播していきます。「summary phrase」は、開発者が後でパッチを参照する
+ために議論の中で利用するかもしれません。
+人々はそのパッチに関連した議論を読むために「summary phrase」を使って google で
+検索したがるでしょう。それはまた2、3ヶ月あとで、人々が「gitk」や
+「git log --oneline」のようなツールを使用して何千ものパッチに目を通す時、
+唯一目にとまる情報となるでしょう。
+
+これらの理由のため、「summary phrase」はなぜパッチが必要であるか、パッチが何を
+変更するかの2つの情報をせいぜい70〜75文字で表現していなければなりません。
+「summary phrase」は簡潔であり説明的である表現を目指しつつ、うまく
+まとめられている概要となるべきです。
+
+「summary phrase」は「Subject: [PATCH tag] <summary phrase>」のように、
+大括弧で閉じられたタグを接頭辞として付加してもかまいません。このタグは
+「summary phrase」の一部とは考えませんが、パッチをどのように取り扱うべきかを
+表現します。
+一般的には「v1, v2, v3」のようなバージョン情報を表すタグ(過去のパッチに対する
+コメントを反映するために複数のバージョンのパッチが投稿されているのであれば)、
+「RFC」のようなコメントを要求するタグが挙げられます。パッチシリーズとして4つの
+パッチがあれば、個々のパッチに「1/4, 2/4, 3/4, 4/4」のように番号を付けても
+かまいません。これは開発者がパッチを適用する順番を確実に把握するためです。
+そして、開発者がパッチシリーズの中のすべてのパッチをもらさずレビュー或いは
+適用するのを保証するためです。
 
 サブジェクトの例を二つ
 
@@ -426,7 +550,12 @@ google で検索したがるでしょう。
 
 説明本体は無期限のソースのチェンジログにコミットされます。なので、説明
 本体はそのパッチに至った議論の詳細を忘れているある程度の技量を持っている人
-がその詳細を思い出すことができるものでなければなりません。
+がその詳細を思い出すことができるものでなければなりません。パッチが対処する
+障害の症状(カーネルログメッセージや oops メッセージ等)を記載することは問題に
+対処可能なパッチを求めてコミットログを検索する人々にとって特に有用です。
+パッチがコンパイル問題を解決するのであれば、そのパッチを探している人が見つける
+ことができる情報だけで十分であり、コンパイル時の全てのエラーを含める必要は
+ありません。「summary phrase」と同様に、簡潔であり説明的であることが重要です。
 
 「 --- 」マーカー行はパッチ処理ツールに対して、チェンジログメッセージの終端
 部分を認識させるという重要な役目を果たします。
@@ -436,14 +565,46 @@ google で検索したがるでしょう。
 追加され何行消されたかを示すものです。diffstat コマンドは特に大きなパッチに
 おいて役立ちます。その時点でだけ又はメンテナにとってのみ関係のあるコメント
 は無期限に保存されるチェンジログにとって適切ではありません。そのため、この
-ようなコメントもマーカー行の後に書かれるべきです。ファイル名はカーネルソー
-スツリーのトップディレクトリからの表記でリストされるため、横方向のスペース
-をとり過ぎないように、diffstat コマンドにオプション「  -p 1 -w 70 」を指定し
-てください(インデントを含めてちょうど80列に合うでしょう)。
+ようなコメントもマーカー行の後に書かれるべきです。
+このようなコメントの良い例として、v1 と v2 のバージョン間で何が変更されたかを
+表す「パッチの変更履歴」が挙げられます。
+
+「 --- 」マーカー行の後に diffstat コマンドの結果を含めるのであれば、ファイル
+名はカーネルソースツリーのトップディレクトリからの表記で列記されるため、横方向
+のスペースをとり過ぎないように、diffstat コマンドにオプション「 -p 1 -w 70 」
+を指定してください(インデントを含めてちょうど80列に合うでしょう)。
 
 適切なパッチのフォーマットの詳細についてはセクション3の参考文献を参照して
 ください。
 
+16) 「git pull」要求の送り方(Linus の電子メールから)
+
+間違ったブランチから引っ張るのを防ぐために、git リポジトリのアドレスと
+ブランチ名を同じ行に1行で記載してください。そうすることで、3回の連続クリック
+で全て選択できます。
+
+正しい形式は下記の通りです。
+
+	"Please pull from
+
+		git://jdelvare.pck.nerim.net/jdelvare-2.6 i2c-for-linus
+
+	 to get these changes:"
+
+その結果、アドレスを自分自身でタイピングして間違えることはなくなります(実際に、
+何度か間違ったブランチから引っ張ってきてしまい、その時に diffstat の結果を
+検証して間違っていることに気づいたことがあります。どこから何を引っ張るべきかを
+「探したり」、正しいブランチ名かどうかを重ねてチェックしたりする必要が
+なくなればより快適になるでしょう)。
+
+diffstat の結果を生成するために「 git diff -M --stat --summary 」を使って
+ください。-M オプションはファイル名の変更を検知でき、--summary オプションは
+新規ファイル、削除されたファイル、名前が変更されたファイルの概要を生成します。
+
+-M オプション(ファイル名の変更検知)を指定すると、diffstat の結果はかなり
+異なってきます。git は大規模な変更(追加と削除のペア)をファイル名の変更と
+判断するためです。
+
 ------------------------------------
 セクション2 - ヒントとTIPSと小技
 ------------------------------------
@@ -459,7 +620,7 @@ google で検索したがるでしょう。
 も逸脱していると、レビューやコメントなしに受け取ってもらえないかもし
 れません。
 
-唯一の特筆すべき例外は、コードをあるファイルから別のファイルに移動
+特筆すべき例外は、コードをあるファイルから別のファイルに移動
 するときです。この場合、コードを移動するパッチでは、移動されるコード
 に関して移動以外の変更を一切加えるべきではありません。これにより、
 コードの移動とあなたが行ったコードの修正を明確に区別できるようにな
@@ -553,4 +714,11 @@ Kernel Documentation/CodingStyle:
 
 Linus Torvalds's mail on the canonical patch format:
   <http://lkml.org/lkml/2005/4/7/183>
+
+Andi Kleen, "On submitting kernel patches"
+  Some strategies to get difficult or controversial changes in.
+  http://halobates.de/on-submitting-patches.pdf
+
 --
+
+

--------------090706060104020306030002--
