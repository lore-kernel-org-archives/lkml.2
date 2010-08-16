Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab0HPIWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 04:22:51 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62211 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893Ab0HPIWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 04:22:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=Cbgpz/8EjqvCHTo5RVKytU9fiyWagTvSI3sDCiffJZCSyi36WZ3+COEQE/bklajx4/
         t9+at+++TZEYtj4KLE2CFvFGUBeUKHDY2S9SGPO3puh6hZyYpZwiuCNVu6SVumm/r2bD
         rCsr0Lgz7jhQUKBByxVct+Gtx3GDzM6mO/tDQ=
Subject: [PATCH] Kconfig: deleted a word which apeared twice
From: Stephan Sperber <sperberstephan@googlemail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Aug 2010 10:22:45 +0200
Message-ID: <1281946965.1799.11.camel@monkey>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

please be not too hard on me with this patch. it is my first one.
at least give me input what needs to be better.
thanks in advance

Stephan
ps: i am not subscribed to the list

>From e81719fabd94594b342114c6060c21da72dc9257 Mon Sep 17 00:00:00 2001
From: Stephan Sperber <sperberstephan@googlemail.com>
Date: Wed, 14 Jul 2010 11:23:08 +0200
Subject: [PATCH] Kconfig: deleted a word which apeared twice

Deleted a word which apeared twice.

Signed-off-by: Stephan Sperber <sperberstephan@googlemail.com>
---
 init/Kconfig |    2 +-
 usr/Kconfig  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 5cff9a9..5d78655 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -179,7 +179,7 @@ config KERNEL_LZO
 	depends on HAVE_KERNEL_LZO
 	help
 	  Its compression ratio is the poorest among the 4. The kernel
-	  size is about about 10% bigger than gzip; however its speed
+	  size is about 10% bigger than gzip; however its speed
 	  (both compression and decompression) is the fastest.
 
 endchoice
diff --git a/usr/Kconfig b/usr/Kconfig
index e2721f5..c2c7fe2 100644
--- a/usr/Kconfig
+++ b/usr/Kconfig
@@ -144,7 +144,7 @@ config INITRAMFS_COMPRESSION_LZO
 	depends on RD_LZO
 	help
 	  Its compression ratio is the poorest among the four. The kernel
-	  size is about about 10% bigger than gzip; however its speed
+	  size is about 10% bigger than gzip; however its speed
 	  (both compression and decompression) is the fastest.
 
 endchoice
-- 
1.7.0.4



