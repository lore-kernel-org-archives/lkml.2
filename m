Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637Ab1GKFH0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 01:07:26 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40919 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078Ab1GKFHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 01:07:25 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH] Staging: comedi: fix brace coding style issue in pcl818.c
Date: Mon, 11 Jul 2011 10:49:43 +0530
Message-Id: <1310361583-12980-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH 1/1]Staging: comedi: fix brace coding style issue in pcl818.c>
References: <[PATCH 1/1]Staging: comedi: fix brace coding style issue in pcl818.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the pcl818.c file that fixes up a brace warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/pcl818.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index b45a9bd..6a7fa42 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -571,9 +571,8 @@ conv_finish:
 		return IRQ_HANDLED;
 	}
 	devpriv->act_chanlist_pos++;
-	if (devpriv->act_chanlist_pos >= devpriv->act_chanlist_len) {
+	if (devpriv->act_chanlist_pos >= devpriv->act_chanlist_len)
 		devpriv->act_chanlist_pos = 0;
-	}
 	s->async->cur_chan++;
 	if (s->async->cur_chan >= devpriv->ai_n_chan) {
 		/*  printk("E"); */
@@ -645,9 +644,8 @@ static irqreturn_t interrupt_pcl818_ai_mode13_dma(int irq, void *d)
 		comedi_buf_put(s->async, ptr[bufptr++] >> 4);	/*  get one sample */
 
 		devpriv->act_chanlist_pos++;
-		if (devpriv->act_chanlist_pos >= devpriv->act_chanlist_len) {
+		if (devpriv->act_chanlist_pos >= devpriv->act_chanlist_len)
 			devpriv->act_chanlist_pos = 0;
-		}
 		s->async->cur_chan++;
 		if (s->async->cur_chan >= devpriv->ai_n_chan) {
 			s->async->cur_chan = 0;
@@ -805,11 +803,10 @@ static irqreturn_t interrupt_pcl818_ai_mode13_fifo(int irq, void *d)
 		return IRQ_HANDLED;
 	}
 
-	if (lo & 2) {
+	if (lo & 2)
 		len = 512;
-	} else {
+	else
 		len = 0;
-	}
 
 	for (i = 0; i < len; i++) {
 		lo = inb(dev->iobase + PCL818_FI_DATALO);
-- 
1.6.5.2

