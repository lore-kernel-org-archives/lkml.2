Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab2KIOVH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 09:21:07 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:64414 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050Ab2KIOVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 09:21:04 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: dwmw2@infradead.org, linux-mtd@lists.infradead.org, trivial@kernel.org,
        linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] mtd: Fix typo mtd/tests
Date: Fri,  9 Nov 2012 23:20:58 +0900
Message-Id: <1352470858-12121-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in printk within drivers/mtd/tests.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/mtd/nand/nand_base.c        | 2 +-
 drivers/mtd/tests/mtd_oobtest.c     | 4 ++--
 drivers/mtd/tests/mtd_pagetest.c    | 2 +-
 drivers/mtd/tests/mtd_readtest.c    | 2 +-
 drivers/mtd/tests/mtd_speedtest.c   | 2 +-
 drivers/mtd/tests/mtd_stresstest.c  | 2 +-
 drivers/mtd/tests/mtd_subpagetest.c | 2 +-
 drivers/mtd/tests/mtd_torturetest.c | 2 +-
 8 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index d5ece6e..5732e2d 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -160,7 +160,7 @@ static uint8_t nand_read_byte(struct mtd_info *mtd)
 }
 
 /**
- * nand_read_byte16 - [DEFAULT] read one byte endianess aware from the chip
+ * nand_read_byte16 - [DEFAULT] read one byte endianness aware from the chip
  * nand_read_byte16 - [DEFAULT] read one byte endianness aware from the chip
  * @mtd: MTD device structure
  *
diff --git a/drivers/mtd/tests/mtd_oobtest.c b/drivers/mtd/tests/mtd_oobtest.c
index e86bb29..e827fa8 100644
--- a/drivers/mtd/tests/mtd_oobtest.c
+++ b/drivers/mtd/tests/mtd_oobtest.c
@@ -366,8 +366,8 @@ static int __init mtd_oobtest_init(void)
 	printk(KERN_INFO "=================================================\n");
 
 	if (dev < 0) {
-		pr_info("Please specify a valid mtd-device via module paramter\n");
-		pr_crit(KERN_CRIT "CAREFUL: This test wipes all data on the specified MTD device!\n");
+		pr_info("Please specify a valid mtd-device via module parameter\n");
+		pr_crit("CAREFUL: This test wipes all data on the specified MTD device!\n");
 		return -EINVAL;
 	}
 
diff --git a/drivers/mtd/tests/mtd_pagetest.c b/drivers/mtd/tests/mtd_pagetest.c
index 3ba2a77..f93a76f 100644
--- a/drivers/mtd/tests/mtd_pagetest.c
+++ b/drivers/mtd/tests/mtd_pagetest.c
@@ -499,7 +499,7 @@ static int __init mtd_pagetest_init(void)
 	printk(KERN_INFO "=================================================\n");
 
 	if (dev < 0) {
-		pr_info("Please specify a valid mtd-device via module paramter\n");
+		pr_info("Please specify a valid mtd-device via module parameter\n");
 		pr_crit("CAREFUL: This test wipes all data on the specified MTD device!\n");
 		return -EINVAL;
 	}
diff --git a/drivers/mtd/tests/mtd_readtest.c b/drivers/mtd/tests/mtd_readtest.c
index ec3efb5..31f505c 100644
--- a/drivers/mtd/tests/mtd_readtest.c
+++ b/drivers/mtd/tests/mtd_readtest.c
@@ -171,7 +171,7 @@ static int __init mtd_readtest_init(void)
 	printk(KERN_INFO "=================================================\n");
 
 	if (dev < 0) {
-		pr_info("Please specify a valid mtd-device via module paramter\n");
+		pr_info("Please specify a valid mtd-device via module parameter\n");
 		return -EINVAL;
 	}
 
diff --git a/drivers/mtd/tests/mtd_speedtest.c b/drivers/mtd/tests/mtd_speedtest.c
index 8a5803b..596cbea 100644
--- a/drivers/mtd/tests/mtd_speedtest.c
+++ b/drivers/mtd/tests/mtd_speedtest.c
@@ -351,7 +351,7 @@ static int __init mtd_speedtest_init(void)
 	printk(KERN_INFO "=================================================\n");
 
 	if (dev < 0) {
-		pr_info("Please specify a valid mtd-device via module paramter\n");
+		pr_info("Please specify a valid mtd-device via module parameter\n");
 		pr_crit("CAREFUL: This test wipes all data on the specified MTD device!\n");
 		return -EINVAL;
 	}
diff --git a/drivers/mtd/tests/mtd_stresstest.c b/drivers/mtd/tests/mtd_stresstest.c
index fea1dd7..3729f67 100644
--- a/drivers/mtd/tests/mtd_stresstest.c
+++ b/drivers/mtd/tests/mtd_stresstest.c
@@ -231,7 +231,7 @@ static int __init mtd_stresstest_init(void)
 	printk(KERN_INFO "=================================================\n");
 
 	if (dev < 0) {
-		pr_info("Please specify a valid mtd-device via module paramter\n");
+		pr_info("Please specify a valid mtd-device via module parameter\n");
 		pr_crit("CAREFUL: This test wipes all data on the specified MTD device!\n");
 		return -EINVAL;
 	}
diff --git a/drivers/mtd/tests/mtd_subpagetest.c b/drivers/mtd/tests/mtd_subpagetest.c
index 8813b0e..c880c22 100644
--- a/drivers/mtd/tests/mtd_subpagetest.c
+++ b/drivers/mtd/tests/mtd_subpagetest.c
@@ -377,7 +377,7 @@ static int __init mtd_subpagetest_init(void)
 	printk(KERN_INFO "=================================================\n");
 
 	if (dev < 0) {
-		pr_info("Please specify a valid mtd-device via module paramter\n");
+		pr_info("Please specify a valid mtd-device via module parameter\n");
 		pr_crit("CAREFUL: This test wipes all data on the specified MTD device!\n");
 		return -EINVAL;
 	}
diff --git a/drivers/mtd/tests/mtd_torturetest.c b/drivers/mtd/tests/mtd_torturetest.c
index 98d2a82..c4cde1e 100644
--- a/drivers/mtd/tests/mtd_torturetest.c
+++ b/drivers/mtd/tests/mtd_torturetest.c
@@ -216,7 +216,7 @@ static int __init tort_init(void)
 	       "flash, stop it if this is not wanted.\n");
 
 	if (dev < 0) {
-		pr_info("Please specify a valid mtd-device via module paramter\n");
+		pr_info("Please specify a valid mtd-device via module parameter\n");
 		pr_crit("CAREFUL: This test wipes all data on the specified MTD device!\n");
 		return -EINVAL;
 	}
-- 
1.8.0.rc3.16.g8ead1bf

