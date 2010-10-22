Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803Ab0JVFSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 01:18:34 -0400
Received: from mail.perches.com ([173.55.12.10]:3475 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752963Ab0JVFR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 01:17:27 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 5/9] drivers/video: typo fix of faild to failed
Date: Thu, 21 Oct 2010 22:17:16 -0700
Message-Id: <813d875e68d113a284b67048e05406186edb141e.1287724261.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1287724261.git.joe@perches.com>
References: <cover.1287724261.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/video/bf54x-lq043fb.c    |    6 +++---
 drivers/video/bfin-t350mcqb-fb.c |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/video/bf54x-lq043fb.c b/drivers/video/bf54x-lq043fb.c
index b020ba7..e7d0f52 100644
--- a/drivers/video/bf54x-lq043fb.c
+++ b/drivers/video/bf54x-lq043fb.c
@@ -241,12 +241,12 @@ static int request_ports(struct bfin_bf54xfb_info *fbi)
 	u16 disp = fbi->mach_info->disp;
 
 	if (gpio_request(disp, DRIVER_NAME)) {
-		printk(KERN_ERR "Requesting GPIO %d faild\n", disp);
+		printk(KERN_ERR "Requesting GPIO %d failed\n", disp);
 		return -EFAULT;
 	}
 
 	if (peripheral_request_list(eppi_req_18, DRIVER_NAME)) {
-		printk(KERN_ERR "Requesting Peripherals faild\n");
+		printk(KERN_ERR "Requesting Peripherals failed\n");
 		gpio_free(disp);
 		return -EFAULT;
 	}
@@ -256,7 +256,7 @@ static int request_ports(struct bfin_bf54xfb_info *fbi)
 		u16 eppi_req_24[] = EPPI0_24;
 
 		if (peripheral_request_list(eppi_req_24, DRIVER_NAME)) {
-			printk(KERN_ERR "Requesting Peripherals faild\n");
+			printk(KERN_ERR "Requesting Peripherals failed\n");
 			peripheral_free_list(eppi_req_18);
 			gpio_free(disp);
 			return -EFAULT;
diff --git a/drivers/video/bfin-t350mcqb-fb.c b/drivers/video/bfin-t350mcqb-fb.c
index 7a50272..3cf7767 100644
--- a/drivers/video/bfin-t350mcqb-fb.c
+++ b/drivers/video/bfin-t350mcqb-fb.c
@@ -192,7 +192,7 @@ static int bfin_t350mcqb_request_ports(int action)
 {
 	if (action) {
 		if (peripheral_request_list(ppi0_req_8, DRIVER_NAME)) {
-			printk(KERN_ERR "Requesting Peripherals faild\n");
+			printk(KERN_ERR "Requesting Peripherals failed\n");
 			return -EFAULT;
 		}
 	} else
-- 
1.7.3.1.g432b3.dirty

