Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932762Ab1KHLRE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 06:17:04 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:45038 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932217Ab1KHLQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 06:16:59 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 16/20] Staging: comedi: fix printk issue in das800.c
Date: Tue,  8 Nov 2011 16:45:26 +0530
Message-Id: <1320750930-9764-16-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1320750930-9764-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1320750930-9764-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the das800.c file that fixes up a printk
warning found by the checkpatch.pl tool.

converted printks to dev_dbg.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/das800.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das800.c b/drivers/staging/comedi/drivers/das800.c
index ade55f1..6e347b4 100644
--- a/drivers/staging/comedi/drivers/das800.c
+++ b/drivers/staging/comedi/drivers/das800.c
@@ -296,47 +296,47 @@ static int das800_probe(struct comedi_device *dev)
 	switch (id_bits) {
 	case 0x0:
 		if (board == das800) {
-			printk(" Board model: DAS-800\n");
+			dev_dbg(dev->hw_dev, "Board model: DAS-800\n");
 			return board;
 		}
 		if (board == ciodas800) {
-			printk(" Board model: CIO-DAS800\n");
+			dev_dbg(dev->hw_dev, "Board model: CIO-DAS800\n");
 			return board;
 		}
-		printk(" Board model (probed): DAS-800\n");
+		dev_dbg(dev->hw_dev, "Board model (probed): DAS-800\n");
 		return das800;
 		break;
 	case 0x2:
 		if (board == das801) {
-			printk(" Board model: DAS-801\n");
+			dev_dbg(dev->hw_dev, "Board model: DAS-801\n");
 			return board;
 		}
 		if (board == ciodas801) {
-			printk(" Board model: CIO-DAS801\n");
+			dev_dbg(dev->hw_dev, "Board model: CIO-DAS801\n");
 			return board;
 		}
-		printk(" Board model (probed): DAS-801\n");
+		dev_dbg(dev->hw_dev, "Board model (probed): DAS-801\n");
 		return das801;
 		break;
 	case 0x3:
 		if (board == das802) {
-			printk(" Board model: DAS-802\n");
+			dev_dbg(dev->hw_dev, "Board model: DAS-802\n");
 			return board;
 		}
 		if (board == ciodas802) {
-			printk(" Board model: CIO-DAS802\n");
+			dev_dbg(dev->hw_dev, "Board model: CIO-DAS802\n");
 			return board;
 		}
 		if (board == ciodas80216) {
-			printk(" Board model: CIO-DAS802/16\n");
+			dev_dbg(dev->hw_dev, "Board model: CIO-DAS802/16\n");
 			return board;
 		}
-		printk(" Board model (probed): DAS-802\n");
+		dev_dbg(dev->hw_dev, "Board model (probed): DAS-802\n");
 		return das802;
 		break;
 	default:
-		printk(" Board model: probe returned 0x%x (unknown)\n",
-		       id_bits);
+		dev_dbg(dev->hw_dev, "Board model: probe returned 0x%x (unknown)\n",
+			id_bits);
 		return board;
 		break;
 	}
-- 
1.7.0.4

