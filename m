Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab0EaJde (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 05:33:34 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34212 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071Ab0EaJdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 05:33:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=LVdWkQmJUh9EAqo3g7aZ0bmLc8enMwMlhZKQqv5yjYXhoAhTId7cwDZkumP9BuWtJm
         ES6gcMVc7ju6JwiJIeBotNBb9ap3GnOiOECb1iC8try/wd0bMWuV6SqJzFqkekUccg2O
         O73ZYaSmSqhR10sTrf4NHRcm/u0WImJ6VB0Gw=
From: Mark <reodge@gmail.com>
To: gregkh@suse.de
Cc: Mark <reodge@gmail.com>, Bill Pemberton <wfp5p@virginia.edu>,
       Maurice Dawson <mauricedawson2699@googlemail.com>,
       Jason Wong <tsanghan@gmail.com>,
       Mithlesh Thukral <mithlesh@linsyssoft.com>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Comedi: staging: Fixed whitespace and braces in adl_pci9118.c
Date: Mon, 31 May 2010 17:33:21 +0800
Message-Id: <1275298401-11736-1-git-send-email-reodge@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a few coding style issues discovered in adl_9118.c by
checkpatch

Signed-off-by: Mark Rankilor <reodge@gmail.com>
---
 drivers/staging/comedi/drivers/adl_pci9118.c |   39 +++++++++++--------------
 1 files changed, 17 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
index ccef549..a1c7f1f 100644
--- a/drivers/staging/comedi/drivers/adl_pci9118.c
+++ b/drivers/staging/comedi/drivers/adl_pci9118.c
@@ -93,7 +93,7 @@ Configuration options:
 #define DPRINTK(fmt, args...)
 #endif
 
-#define IORANGE_9118 	64	/* I hope */
+#define IORANGE_9118	64	/* I hope */
 #define PCI9118_CHANLEN	255	/*
 				 * len of chanlist, some source say 256,
 				 * but reality looks like 255 :-(
@@ -1199,7 +1199,7 @@ static int Compute_and_setup_dma(struct comedi_device *dev)
 							 * align to 32bit down
 							 */
 	}
-	DPRINTK("2 dmalen0=%d dmalen1=%d \n", dmalen0, dmalen1);
+	DPRINTK("2 dmalen0=%d dmalen1=%d\n", dmalen0, dmalen1);
 
 	/* we want wake up every scan? */
 	if (devpriv->ai_flags & TRIG_WAKE_EOS) {
@@ -1259,7 +1259,7 @@ static int Compute_and_setup_dma(struct comedi_device *dev)
 		}
 	}
 
-	DPRINTK("3 dmalen0=%d dmalen1=%d \n", dmalen0, dmalen1);
+	DPRINTK("3 dmalen0=%d dmalen1=%d\n", dmalen0, dmalen1);
 	/* transfer without TRIG_WAKE_EOS */
 	if (!(devpriv->ai_flags & TRIG_WAKE_EOS)) {
 		/* if it's possible then allign DMA buffers to length of scan */
@@ -1287,13 +1287,13 @@ static int Compute_and_setup_dma(struct comedi_device *dev)
 			    ((devpriv->ai_n_realscanlen << 1) *
 			     devpriv->ai_scans)) {
 				DPRINTK
-				    ("3.0 ai_n_realscanlen=%d ai_scans=%d \n",
+				    ("3.0 ai_n_realscanlen=%d ai_scans=%d\n",
 				     devpriv->ai_n_realscanlen,
 				     devpriv->ai_scans);
 				dmalen0 =
 				    (devpriv->ai_n_realscanlen << 1) *
 				    devpriv->ai_scans;
-				DPRINTK("3.1 dmalen0=%d dmalen1=%d \n", dmalen0,
+				DPRINTK("3.1 dmalen0=%d dmalen1=%d\n", dmalen0,
 					dmalen1);
 				dmalen0 &= ~3L;
 			} else {	/*
@@ -1306,21 +1306,21 @@ static int Compute_and_setup_dma(struct comedi_device *dev)
 					dmalen1 =
 					    (devpriv->ai_n_realscanlen << 1) *
 					    devpriv->ai_scans - dmalen0;
-				DPRINTK("3.2 dmalen0=%d dmalen1=%d \n", dmalen0,
+				DPRINTK("3.2 dmalen0=%d dmalen1=%d\n", dmalen0,
 					dmalen1);
 				dmalen1 &= ~3L;
 			}
 		}
 	}
 
-	DPRINTK("4 dmalen0=%d dmalen1=%d \n", dmalen0, dmalen1);
+	DPRINTK("4 dmalen0=%d dmalen1=%d\n", dmalen0, dmalen1);
 
 	/* these DMA buffer size will be used */
 	devpriv->dma_actbuf = 0;
 	devpriv->dmabuf_use_size[0] = dmalen0;
 	devpriv->dmabuf_use_size[1] = dmalen1;
 
-	DPRINTK("5 dmalen0=%d dmalen1=%d \n", dmalen0, dmalen1);
+	DPRINTK("5 dmalen0=%d dmalen1=%d\n", dmalen0, dmalen1);
 #if 0
 	if (devpriv->ai_n_scanlen < this_board->half_fifo_size) {
 		devpriv->dmabuf_panic_size[0] =
@@ -1540,12 +1540,10 @@ static int pci9118_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	}
 
 	/* use sample&hold signal? */
-	if (cmd->convert_src == TRIG_NOW) {
-		devpriv->usessh = 1;
-	} /* yes */
-	else {
-		devpriv->usessh = 0;
-	}			/*  no */
+	if (cmd->convert_src == TRIG_NOW)
+		devpriv->usessh = 1; /* yes */
+	else
+		devpriv->usessh = 0; /* no */
 
 	DPRINTK("1 neverending=%d scans=%u usessh=%d ai_startstop=0x%2x\n",
 		devpriv->ai_neverending, devpriv->ai_scans, devpriv->usessh,
@@ -1562,9 +1560,8 @@ static int pci9118_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		devpriv->usedma = 1;
 		if ((cmd->flags & TRIG_WAKE_EOS) &&
 		    (devpriv->ai_n_scanlen == 1)) {
-			if (cmd->convert_src == TRIG_NOW) {
+			if (cmd->convert_src == TRIG_NOW)
 				devpriv->ai_add_back = 1;
-			}
 			if (cmd->convert_src == TRIG_TIMER) {
 				devpriv->usedma = 0;
 					/*
@@ -1659,11 +1656,10 @@ static int pci9118_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		(cmd->scan_begin_src == TRIG_INT)) &&
 		(cmd->convert_src == TRIG_TIMER)) {
 					/* both timer is used for one time */
-		if (cmd->scan_begin_src == TRIG_EXT) {
+		if (cmd->scan_begin_src == TRIG_EXT)
 			devpriv->ai_do = 4;
-		} else {
+		else
 			devpriv->ai_do = 1;
-		}
 		pci9118_calc_divisors(devpriv->ai_do, dev, s,
 				      &cmd->scan_begin_arg, &cmd->convert_arg,
 				      devpriv->ai_flags,
@@ -2177,11 +2173,10 @@ static int pci9118_attach(struct comedi_device *dev,
 
 	opt_bus = it->options[0];
 	opt_slot = it->options[1];
-	if (it->options[3] & 1) {
+	if (it->options[3] & 1)
 		master = 0;	/* user don't want use bus master */
-	} else {
+	else
 		master = 1;
-	}
 
 	ret = alloc_private(dev, sizeof(struct pci9118_private));
 	if (ret < 0) {
-- 
1.7.1

