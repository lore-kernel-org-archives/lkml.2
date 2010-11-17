Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759558Ab0KQAfM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 19:35:12 -0500
Received: from mail-iw0-f194.google.com ([209.85.214.194]:39934 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759259Ab0KQAfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 19:35:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=jdLD8utn+wm9u/FzICxLEA1cSZkbD6vCgTl62BAlFfTJfpBYy6EiF1qnzowEjwo32N
         xqcgtbi5nLOf0QhAoI3OiVJ9p22PBDRHMEXeV4KWBIV3y/kHh7DRxPQr1rRKyBI4XKWL
         BGjVY2rSH6+PXUiYlVdIvVN8rhLlb8QnreviY=
From: Vamsi Krishna B <vamsikrishna.brahmajosyula@gmail.com>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vamsi Krishna B <vamsikrishna.brahmajosyula@gmail.com>
Subject: [PATCH] fs : ext4 : super.c 	fixed coding style violations fs/ext4/super.c:41: WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h> fs/ext4/super.c:546: ERROR: "foo * bar" should be "foo *bar" fs/ext4/super.c:546: WARNING: space prohibited between function name and open parenthesis '(' fs/ext4/super.c:1141: ERROR: spaces required around that '?' (ctx:VxV) fs/ext4/super.c:1141: ERROR: spaces required around that ':' (ctx:VxV)
Date: Wed, 17 Nov 2010 06:11:26 +0530
Message-Id: <1289954486-13580-1-git-send-email-vamsikrishna.brahmajosyula@gmail.com>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vamsi Krishna B <vamsikrishna.brahmajosyula@gmail.com>
---
 fs/ext4/super.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 61182fe..11a46dc 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -38,7 +38,7 @@
 #include <linux/ctype.h>
 #include <linux/log2.h>
 #include <linux/crc16.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #include <linux/kthread.h>
 #include <linux/freezer.h>
@@ -543,7 +543,7 @@ void __ext4_abort(struct super_block *sb, const char *function,
 		panic("EXT4-fs panic from previous error\n");
 }
 
-void ext4_msg (struct super_block * sb, const char *prefix,
+void ext4_msg(struct super_block *sb, const char *prefix,
 		   const char *fmt, ...)
 {
 	va_list args;
@@ -1138,7 +1138,7 @@ static int bdev_try_to_free_page(struct super_block *sb, struct page *page,
 
 #ifdef CONFIG_QUOTA
 #define QTYPE2NAME(t) ((t) == USRQUOTA ? "user" : "group")
-#define QTYPE2MOPT(on, t) ((t) == USRQUOTA?((on)##USRJQUOTA):((on)##GRPJQUOTA))
+#define QTYPE2MOPT(on, t) ((t) == USRQUOTA ? ((on)##USRJQUOTA) : ((on)##GRPJQUOTA))
 
 static int ext4_write_dquot(struct dquot *dquot);
 static int ext4_acquire_dquot(struct dquot *dquot);
-- 
1.7.3.2

