Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab1HSTl0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 15:41:26 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:60197 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756127Ab1HSTkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 15:40:32 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: apatard@mandriva.com, gregkh@suse.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/12] staging: xgifb: delete driver version information
Date: Fri, 19 Aug 2011 22:40:29 +0300
Message-Id: <1313782830-31461-12-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313782830-31461-1-git-send-email-aaro.koskinen@iki.fi>
References: <1313782830-31461-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete version information, it's just noise and serves no purpose.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/XGI_main.h    |    4 ----
 drivers/staging/xgifb/XGI_main_26.c |    3 ---
 2 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main.h b/drivers/staging/xgifb/XGI_main.h
index 168f25c..8ba470b 100644
--- a/drivers/staging/xgifb/XGI_main.h
+++ b/drivers/staging/xgifb/XGI_main.h
@@ -11,10 +11,6 @@
 
 #define XGIFAIL(x) do { printk(x "\n"); return -EINVAL; } while (0)
 
-#define VER_MAJOR                 0
-#define VER_MINOR                 8
-#define VER_LEVEL                 1
-
 #ifndef PCI_VENDOR_ID_XG
 #define PCI_VENDOR_ID_XG          0x18CA
 #endif
diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index ebd63ad..ae01a6e 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -2468,9 +2468,6 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 		goto error_1;
 	}
 
-	printk(KERN_INFO "fb%d: %s frame buffer device, Version %d.%d.%02d\n",
-	       fb_info->node, myid, VER_MAJOR, VER_MINOR, VER_LEVEL);
-
 	dumpVGAReg();
 
 	return 0;
-- 
1.7.2.5

