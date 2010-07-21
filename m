Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab0GUFNr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:13:47 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41254 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762164Ab0GUEyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:54:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=dLshq4C+94JDCkYCgvgX8P6n+2OcmCsfAI+7foq+OVDCslY4oST2BPWCU5EbP2TUtK
         qbKnWlHeugosQdDeyY3KxC/3h8hWe1hHTHfISPbKdlHdbAoe9RxwEnZrxZ5q7PpqnNgR
         KDvJBQcttfn8x36LOK35tbIKdtKU3QjU6rH8o=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 65/65]Documentation/ja_JP/SubmittingPatches update web address.
Date: Tue, 20 Jul 2010 21:54:46 -0700
Message-Id: <1279688096-29519-5-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688096-29519-1-git-send-email-justinmattock@gmail.com>
References: <1279688096-29519-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below changes a url to an email, and updates 
a broken web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/ja_JP/SubmittingPatches |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/ja_JP/SubmittingPatches b/Documentation/ja_JP/SubmittingPatches
index a9dc124..f107c83 100644
--- a/Documentation/ja_JP/SubmittingPatches
+++ b/Documentation/ja_JP/SubmittingPatches
@@ -97,7 +97,7 @@ Quilt:
 http://savannah.nongnu.org/projects/quilt
 
 Andrew Morton's patch scripts:
-http://www.zip.com.au/~akpm/linux/patches/
+http://userweb.kernel.org/~akpm/stuff/tpp.txt
 このリンクの先のスクリプトの代わりとして、quilt がパッチマネジメント
 ツールとして推奨されています(上のリンクを見てください)。
 
@@ -210,7 +210,7 @@ VGER.KERNEL.ORG でホスティングされているメーリングリストの
  ・移植性のないコードから移植性のあるコードへの置き換え(小さい範囲で
    あればアーキテクチャ特有のことでも他の人がコピーできます)
  ・作者やメンテナによる修正(すなわち patch monkey の再転送モード)
-URL: <http://www.kernel.org/pub/linux/kernel/people/bunk/trivial/>
+EMAIL: <trivial@kernel.org>
 
 7) MIME やリンクや圧縮ファイルや添付ファイルではなくプレインテキストのみ
 
@@ -534,7 +534,7 @@ gcc においては、マクロと同じくらい軽いです。
 ----------------------
 
 Andrew Morton, "The perfect patch" (tpp).
-  <http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt>
+  <http://userweb.kernel.org/~akpm/stuff/tpp.txt>
 
 Jeff Garzik, "Linux kernel patch submission format".
   <http://linux.yyz.us/patch-format.html>
-- 
1.7.1.rc1.21.gf3bd6

