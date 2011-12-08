Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab1LHMzB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 07:55:01 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36787 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab1LHMyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 07:54:54 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 24/30] Staging: comedi: fix brace coding style issue in cb_pcidda.c
Date: Thu,  8 Dec 2011 18:22:19 +0530
Message-Id: <1323348745-31477-24-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323348745-31477-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1323348745-31477-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the cb_pcidda.c file that fixes up a brace
warning found by the checkpatch.pl tool.

Added KERN_facitity levels for printks.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/cb_pcidda.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidda.c b/drivers/staging/comedi/drivers/cb_pcidda.c
index abba220..853d461 100644
--- a/drivers/staging/comedi/drivers/cb_pcidda.c
+++ b/drivers/staging/comedi/drivers/cb_pcidda.c
@@ -423,19 +423,19 @@ static int cb_pcidda_detach(struct comedi_device *dev)
 static int cb_pcidda_ai_cmd(struct comedi_device *dev,
 			    struct comedi_subdevice *s)
 {
-	printk("cb_pcidda_ai_cmd\n");
-	printk("subdev: %d\n", cmd->subdev);
-	printk("flags: %d\n", cmd->flags);
-	printk("start_src: %d\n", cmd->start_src);
-	printk("start_arg: %d\n", cmd->start_arg);
-	printk("scan_begin_src: %d\n", cmd->scan_begin_src);
-	printk("convert_src: %d\n", cmd->convert_src);
-	printk("convert_arg: %d\n", cmd->convert_arg);
-	printk("scan_end_src: %d\n", cmd->scan_end_src);
-	printk("scan_end_arg: %d\n", cmd->scan_end_arg);
-	printk("stop_src: %d\n", cmd->stop_src);
-	printk("stop_arg: %d\n", cmd->stop_arg);
-	printk("chanlist_len: %d\n", cmd->chanlist_len);
+	printk(KERN_DEBUG "cb_pcidda_ai_cmd\n");
+	printk(KERN_DEBUG "subdev: %d\n", cmd->subdev);
+	printk(KERN_DEBUG "flags: %d\n", cmd->flags);
+	printk(KERN_DEBUG "start_src: %d\n", cmd->start_src);
+	printk(KERN_DEBUG "start_arg: %d\n", cmd->start_arg);
+	printk(KERN_DEBUG "scan_begin_src: %d\n", cmd->scan_begin_src);
+	printk(KERN_DEBUG "convert_src: %d\n", cmd->convert_src);
+	printk(KERN_DEBUG "convert_arg: %d\n", cmd->convert_arg);
+	printk(KERN_DEBUG "scan_end_src: %d\n", cmd->scan_end_src);
+	printk(KERN_DEBUG "scan_end_arg: %d\n", cmd->scan_end_arg);
+	printk(KERN_DEBUG "stop_src: %d\n", cmd->stop_src);
+	printk(KERN_DEBUG "stop_arg: %d\n", cmd->stop_arg);
+	printk(KERN_DEBUG "chanlist_len: %d\n", cmd->chanlist_len);
 }
 #endif
 
-- 
1.7.0.4

