Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100Ab1HKKEc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 06:04:32 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50313 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943Ab1HKKE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 06:04:29 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 2/2] Staging: comedi: fix printk() issue in das800.c
Date: Thu, 11 Aug 2011 15:49:03 +0530
Message-Id: <1313057943-5799-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH]Staging: comedi: fix printk warning issue in das800.c>
References: <[PATCH]Staging: comedi: fix printk warning issue in das800.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the das800.c file that fixes up a printk() warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/das800.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das800.c b/drivers/staging/comedi/drivers/das800.c
index feda1be..cafb15b 100644
--- a/drivers/staging/comedi/drivers/das800.c
+++ b/drivers/staging/comedi/drivers/das800.c
@@ -296,47 +296,47 @@ static int das800_probe(struct comedi_device *dev)
 	switch (id_bits) {
 	case 0x0:
 		if (board == das800) {
-			printk(" Board model: DAS-800\n");
+			printk(KERN_DEBUG " Board model: DAS-800\n");
 			return board;
 		}
 		if (board == ciodas800) {
-			printk(" Board model: CIO-DAS800\n");
+			printk(KERN_DEBUG " Board model: CIO-DAS800\n");
 			return board;
 		}
-		printk(" Board model (probed): DAS-800\n");
+		printk(KERN_DEBUG " Board model (probed): DAS-800\n");
 		return das800;
 		break;
 	case 0x2:
 		if (board == das801) {
-			printk(" Board model: DAS-801\n");
+			printk(KERN_DEBUG " Board model: DAS-801\n");
 			return board;
 		}
 		if (board == ciodas801) {
-			printk(" Board model: CIO-DAS801\n");
+			printk(KERN_DEBUG " Board model: CIO-DAS801\n");
 			return board;
 		}
-		printk(" Board model (probed): DAS-801\n");
+		printk(KERN_DEBUG " Board model (probed): DAS-801\n");
 		return das801;
 		break;
 	case 0x3:
 		if (board == das802) {
-			printk(" Board model: DAS-802\n");
+			printk(KERN_DEBUG " Board model: DAS-802\n");
 			return board;
 		}
 		if (board == ciodas802) {
-			printk(" Board model: CIO-DAS802\n");
+			printk(KERN_DEBUG " Board model: CIO-DAS802\n");
 			return board;
 		}
 		if (board == ciodas80216) {
-			printk(" Board model: CIO-DAS802/16\n");
+			printk(KERN_DEBUG " Board model: CIO-DAS802/16\n");
 			return board;
 		}
-		printk(" Board model (probed): DAS-802\n");
+		printk(KERN_DEBUG " Board model (probed): DAS-802\n");
 		return das802;
 		break;
 	default:
-		printk(" Board model: probe returned 0x%x (unknown)\n",
-		       id_bits);
+		printk(KERN_DEBUG " Board model: probe returned 0x%x (unknown)\n",
+				id_bits);
 		return board;
 		break;
 	}
-- 
1.6.5.2

