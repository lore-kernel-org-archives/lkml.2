Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934516Ab1ETALX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:11:23 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:40419 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934039Ab1ETALR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:11:17 -0400
X-Sasl-enc: i5L+ixi2d4jrrHfN0/GLYO8HDVpvrX0zzTf4B2uHOAuE 1305850276
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tsugikazu Shibata <tshibata@ab.jp.nec.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: =?UTF-8?q?=5BPATCH=2007/44=5D=20HOWTO=3A=20sync=20up=20Documentaion/ja=5FJP/HOWTO?=
Date: Thu, 19 May 2011 17:10:25 -0700
Message-Id: <1305850262-9575-7-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1305850262-9575-1-git-send-email-gregkh@suse.de>
References: <20110520000821.GA9367@kroah.com>
 <1305850262-9575-1-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tsugikazu Shibata <tshibata@ab.jp.nec.com>

Signed-off-by: Tsugikazu Shibata <tshibata@ab.jp.nec.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/ja_JP/HOWTO |  129 +++++++++++++++------------------------------
 1 files changed, 43 insertions(+), 86 deletions(-)

diff --git a/Documentation/ja_JP/HOWTO b/Documentation/ja_JP/HOWTO
index b63301a..050d37f 100644
--- a/Documentation/ja_JP/HOWTO
+++ b/Documentation/ja_JP/HOWTO
@@ -11,14 +11,14 @@ for non English (read: Japanese) speakers and is not intended as a
 fork. So if you have any comments or updates for this file, please try
 to update the original English file first.
 
-Last Updated: 2008/10/24
+Last Updated: 2011/03/31
 ==================================
 これは、
-linux-2.6.28/Documentation/HOWTO
+linux-2.6.38/Documentation/HOWTO
 の和訳です。
 
 翻訳団体： JF プロジェクト < http://www.linux.or.jp/JF/ >
-翻訳日： 2008/10/24
+翻訳日： 2011/3/28
 翻訳者： Tsugikazu Shibata <tshibata at ab dot jp dot nec dot com>
 校正者： 松倉さん <nbh--mats at nifty dot com>
          小林 雅典さん (Masanori Kobayasi) <zap03216 at nifty dot ne dot jp>
@@ -256,8 +256,8 @@ Linux カーネルの開発プロセスは現在幾つかの異なるメイン
   - メインの 2.6.x カーネルツリー
   - 2.6.x.y -stable カーネルツリー
   - 2.6.x -git カーネルパッチ
-  - 2.6.x -mm カーネルパッチ
   - サブシステム毎のカーネルツリーとパッチ
+  - 統合テストのための 2.6.x -next カーネルツリー
 
 2.6.x カーネルツリー
 -----------------
@@ -268,9 +268,9 @@ Linux カーネルの開発プロセスは現在幾つかの異なるメイン
 
   - 新しいカーネルがリリースされた直後に、2週間の特別期間が設けられ、
     この期間中に、メンテナ達は Linus に大きな差分を送ることができます。
-    このような差分は通常 -mm カーネルに数週間含まれてきたパッチです。
+    このような差分は通常 -next カーネルに数週間含まれてきたパッチです。
     大きな変更は git(カーネルのソース管理ツール、詳細は
-    http://git.or.cz/  参照) を使って送るのが好ましいやり方ですが、パッ
+    http://git-scm.com/  参照) を使って送るのが好ましいやり方ですが、パッ
     チファイルの形式のまま送るのでも十分です。
 
   - 2週間後、-rc1 カーネルがリリースされ、この後にはカーネル全体の安定
@@ -333,86 +333,44 @@ git リポジトリで管理されているLinus のカーネルツリーの毎
 れは -rc カーネルと比べて、パッチが大丈夫かどうかも確認しないで自動的
 に生成されるので、より実験的です。
 
-2.6.x -mm カーネルパッチ
-------------------------
-
-Andrew Morton によってリリースされる実験的なカーネルパッチ群です。
-Andrew は個別のサブシステムカーネルツリーとパッチを全て集めてきて
-linux-kernel メーリングリストで収集された多数のパッチと同時に一つにま
-とめます。
-このツリーは新機能とパッチが検証される場となります。ある期間の間パッチ
-が -mm に入って価値を証明されたら、Andrew やサブシステムメンテナが、
-メインラインへ入れるように Linus にプッシュします。
-
-メインカーネルツリーに含めるために Linus に送る前に、すべての新しいパッ
-チが -mm ツリーでテストされることが強く推奨されています。マージウィン
-ドウが開く前に -mm ツリーに現れなかったパッチはメインラインにマージさ
-れることは困難になります。
-
-これらのカーネルは安定して動作すべきシステムとして使うのには適切ではあ
-りませんし、カーネルブランチの中でももっとも動作にリスクが高いものです。
-
-もしあなたが、カーネル開発プロセスの支援をしたいと思っているのであれば、
-どうぞこれらのカーネルリリースをテストに使ってみて、そしてもし問題があ
-れば、またもし全てが正しく動作したとしても、linux-kernel メーリングリ
-ストにフィードバックを提供してください。
-
-すべての他の実験的パッチに加えて、これらのカーネルは通常リリース時点で
-メインラインの -git カーネルに含まれる全ての変更も含んでいます。
-
--mm カーネルは決まったスケジュールではリリースされません、しかし通常幾
-つかの -mm カーネル (1 から 3 が普通）が各-rc カーネルの間にリリースさ
-れます。
-
 サブシステム毎のカーネルツリーとパッチ
 -------------------------------------------
 
-カーネルの様々な領域で何が起きているかを見られるようにするため、多くの
-カーネルサブシステム開発者は彼らの開発ツリーを公開しています。これらの
-ツリーは説明したように -mm カーネルリリースに入れ込まれます。
-
-以下はさまざまなカーネルツリーの中のいくつかのリスト-
-
-  git ツリー-
-    - Kbuild の開発ツリー、Sam Ravnborg <sam@ravnborg.org>
-	git.kernel.org:/pub/scm/linux/kernel/git/sam/kbuild.git
-
-    - ACPI の開発ツリー、 Len Brown <len.brown@intel.com>
-	git.kernel.org:/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git
-
-    - Block の開発ツリー、Jens Axboe <axboe@suse.de>
-	git.kernel.org:/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git
-
-    - DRM の開発ツリー、Dave Airlie <airlied@linux.ie>
-	git.kernel.org:/pub/scm/linux/kernel/git/airlied/drm-2.6.git
-
-    - ia64 の開発ツリー、Tony Luck <tony.luck@intel.com>
-	git.kernel.org:/pub/scm/linux/kernel/git/aegl/linux-2.6.git
-
-    - infiniband, Roland Dreier <rolandd@cisco.com>
-	git.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git
-
-    - libata, Jeff Garzik <jgarzik@pobox.com>
-	git.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
-
-    - ネットワークドライバ, Jeff Garzik <jgarzik@pobox.com>
-	git.kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git
-
-    - pcmcia, Dominik Brodowski <linux@dominikbrodowski.net>
-	git.kernel.org:/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git
-
-    - SCSI, James Bottomley <James.Bottomley@hansenpartnership.com>
-	git.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
-
-    - x86, Ingo Molnar <mingo@elte.hu>
-	git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
-
-  quilt ツリー-
-    - USB, ドライバコアと I2C, Greg Kroah-Hartman <gregkh@suse.de>
-	kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
+それぞれのカーネルサブシステムのメンテナ達は --- そして多くのカーネル
+サブシステムの開発者達も --- 各自の最新の開発状況をソースリポジトリに
+公開しています。そのため、自分とは異なる領域のカーネルで何が起きている
+かを他の人が見られるようになっています。開発が早く進んでいる領域では、
+開発者は自身の投稿がどのサブシステムカーネルツリーを元にしているか質問
+されるので、その投稿とすでに進行中の他の作業との衝突が避けられます。
+
+大部分のこれらのリポジトリは git ツリーです。しかしその他の SCM や
+quilt シリーズとして公開されているパッチキューも使われています。これら
+のサブシステムリポジトリのアドレスは MAINTAINERS ファイルにリストされ
+ています。これらの多くは http://git.kernel.org/ で参照することができま
+す。
 
-  その他のカーネルツリーは http://git.kernel.org/ と MAINTAINERS ファ
-  イルに一覧表があります。
+提案されたパッチがこのようなサブシステムツリーにコミットされる前に、メー
+リングリストで事前にレビューにかけられます（以下の対応するセクションを
+参照）。いくつかのカーネルサブシステムでは、このレビューは patchwork
+というツールによって追跡されます。Patchwork は web インターフェイスに
+よってパッチ投稿の表示、パッチへのコメント付けや改訂などができ、そして
+メンテナはパッチに対して、レビュー中、受付済み、拒否というようなマーク
+をつけることができます。大部分のこれらの patchwork のサイトは
+http://patchwork.kernel.org/ でリストされています。
+
+統合テストのための 2.6.x -next カーネルツリー
+---------------------------------------------
+
+サブシステムツリーの更新内容がメインラインの 2.6.x ツリーにマージされ
+る前に、それらは統合テストされる必要があります。この目的のため、実質的
+に全サブシステムツリーからほぼ毎日プルされてできる特別なテスト用のリ
+ポジトリが存在します-
+       http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git
+       http://linux.f-seidel.de/linux-next/pmwiki/
+
+このやり方によって、-next カーネルは次のマージ機会でどんなものがメイン
+ラインカーネルにマージされるか、おおまかなの展望を提供します。-next 
+カーネルの実行テストを行う冒険好きなテスターは大いに歓迎されます
 
 バグレポート
 -------------
@@ -673,10 +631,9 @@ Linux カーネルコミュニティは、一度に大量のコードの塊を
 じところからスタートしたのですから。
 
 Paolo Ciarrocchi に感謝、彼は彼の書いた "Development Process"
-(http://linux.tar.bz/articles/2.6-development_process)セクショ
-ンをこのテキストの原型にすることを許可してくれました。
-Rundy Dunlap と Gerrit Huizenga はメーリングリストでやるべきこととやっ
-てはいけないことのリストを提供してくれました。
+(http://lwn.net/Articles/94386/) セクションをこのテキストの原型にする
+ことを許可してくれました。Rundy Dunlap と Gerrit Huizenga はメーリング
+リストでやるべきこととやってはいけないことのリストを提供してくれました。
 以下の人々のレビュー、コメント、貢献に感謝。
 Pat Mochel, Hanna Linder, Randy Dunlap, Kay Sievers,
 Vojtech Pavlik, Jan Kara, Josh Boyer, Kees Cook, Andrew Morton, Andi
-- 
1.7.4.2

