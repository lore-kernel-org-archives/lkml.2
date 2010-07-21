Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762145Ab0GUEzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:55:52 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35617 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756368Ab0GUEyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:54:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=UTNaq5MEjeALNR0RyNoUREk152iwzXjVIi1CaJDxv4te//sdmm8iqdJVCDGKid+fb1
         hdaDu58gDz4qAGy2eryU6VWUI6iFG1C9YOirRgbofMMuU2sHKc4eJenT3nv+Qmjy7SmS
         3IPpqdKMhpwPlaAcUTcyvQxO2QGORBpfwmc6U=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 64/64]Documentation/ja_JP/HOWTO update web addresses.
Date: Tue, 20 Jul 2010 21:54:45 -0700
Message-Id: <1279688096-29519-4-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688096-29519-1-git-send-email-justinmattock@gmail.com>
References: <1279688096-29519-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates broken web addresses.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/ja_JP/HOWTO |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/ja_JP/HOWTO b/Documentation/ja_JP/HOWTO
index 5547698..347722f 100644
--- a/Documentation/ja_JP/HOWTO
+++ b/Documentation/ja_JP/HOWTO
@@ -223,7 +223,7 @@ web サイトには、コードの構成、サブシステム、現在存在す
 あなたがどこからスタートして良いかわからないが、Linux カーネル開発コミュ
 ニティに参加して何かすることをさがしている場合には、Linux kernel
 Janitor's プロジェクトにいけば良いでしょう -
-	http://janitor.kernelnewbies.org/
+	http://kernelnewbies.org/KernelJanitors	
 ここはそのようなスタートをするのにうってつけの場所です。ここには、
 Linux カーネルソースツリーの中に含まれる、きれいにし、修正しなければな
 らない、単純な問題のリストが記述されています。このプロジェクトに関わる
@@ -673,7 +673,7 @@ Linux カーネルコミュニティは、一度に大量のコードの塊を
 じところからスタートしたのですから。
 
 Paolo Ciarrocchi に感謝、彼は彼の書いた "Development Process"
-(http://linux.tar.bz/articles/2.6-development_process)セクショ
+(http://lwn.net/Articles/94386/)セクショ
 ンをこのテキストの原型にすることを許可してくれました。
 Rundy Dunlap と Gerrit Huizenga はメーリングリストでやるべきこととやっ
 てはいけないことのリストを提供してくれました。
-- 
1.7.1.rc1.21.gf3bd6

