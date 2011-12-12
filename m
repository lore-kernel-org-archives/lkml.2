Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab1LLFWF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 00:22:05 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59165 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab1LLFV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 00:21:59 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 25/29] Staging: comedi: fix brace coding style issue in cb_pcidda.c
Date: Mon, 12 Dec 2011 10:49:37 +0530
Message-Id: <1323667181-17252-25-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the cb_pcidda.c file that fixes up a brace
warning found by the checkpatch.pl tool.

Converted printks to dev_dbg().

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/cb_pcidda.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidda.c b/drivers/staging/comedi/drivers/cb_pcidda.c
index abba220..1bc52a8 100644
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
+	dev_dbg(dev->hw_dev, "cb_pcidda_ai_cmd\n");
+	dev_dbg(dev->hw_dev, "subdev: %d\n", cmd->subdev);
+	dev_dbg(dev->hw_dev, "flags: %d\n", cmd->flags);
+	dev_dbg(dev->hw_dev, "start_src: %d\n", cmd->start_src);
+	dev_dbg(dev->hw_dev, "start_arg: %d\n", cmd->start_arg);
+	dev_dbg(dev->hw_dev, "scan_begin_src: %d\n", cmd->scan_begin_src);
+	dev_dbg(dev->hw_dev, "convert_src: %d\n", cmd->convert_src);
+	dev_dbg(dev->hw_dev, "convert_arg: %d\n", cmd->convert_arg);
+	dev_dbg(dev->hw_dev, "scan_end_src: %d\n", cmd->scan_end_src);
+	dev_dbg(dev->hw_dev, "scan_end_arg: %d\n", cmd->scan_end_arg);
+	dev_dbg(dev->hw_dev, "stop_src: %d\n", cmd->stop_src);
+	dev_dbg(dev->hw_dev, "stop_arg: %d\n", cmd->stop_arg);
+	dev_dbg(dev->hw_dev, "chanlist_len: %d\n", cmd->chanlist_len);
 }
 #endif
 
-- 
1.7.0.4

