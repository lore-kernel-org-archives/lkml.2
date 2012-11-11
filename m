Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab2KKThH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 14:37:07 -0500
Received: from arrakis.dune.hu ([78.24.191.176]:42184 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016Ab2KKThF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 14:37:05 -0500
X-Greylist: delayed 482 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Nov 2012 14:37:05 EST
From: Luka Perkov <luka@openwrt.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Luka Perkov <luka@openwrt.org>
Subject: [PATCH] MTD: use SQUASHFS_MAGIC from uapi/linux/magic.h
Date: Sun, 11 Nov 2012 20:32:15 +0100
Message-Id: <1352662335-12028-1-git-send-email-luka@openwrt.org>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Luka Perkov <luka@openwrt.org>
---
 drivers/mtd/ar7part.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/ar7part.c b/drivers/mtd/ar7part.c
index 9453931..7c057a0 100644
--- a/drivers/mtd/ar7part.c
+++ b/drivers/mtd/ar7part.c
@@ -26,19 +26,16 @@
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
 #include <linux/bootmem.h>
-#include <linux/magic.h>
 #include <linux/module.h>
 
+#include <uapi/linux/magic.h>
+
 #define AR7_PARTS	4
 #define ROOT_OFFSET	0xe0000
 
 #define LOADER_MAGIC1	le32_to_cpu(0xfeedfa42)
 #define LOADER_MAGIC2	le32_to_cpu(0xfeed1281)
 
-#ifndef SQUASHFS_MAGIC
-#define SQUASHFS_MAGIC	0x73717368
-#endif
-
 struct ar7_bin_rec {
 	unsigned int checksum;
 	unsigned int length;
-- 
1.8.0

