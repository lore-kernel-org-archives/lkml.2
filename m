Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab0CTSQK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 14:16:10 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:35114 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334Ab0CTSQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 14:16:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=w/pqCRwwJX/nei9bdUwDIZskSiqtntvAYp3kwTrrRlZy5APG6hsatP32F9CEc7pJGY
         kOztFLQCT3tZ9N2DNmc7z7oJUQzp5UYHoRLUb5gLzxbRonclsFCiApNNNlpPZYRJuONz
         SkDX8OyrjHcQ/pIivGYzmeEKVLZiG0dp/Md48=
From: Jason Wong <tsanghan@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Jason Wong <tsanghan@gmail.com>
Subject: [PATCH 5/9] Staging: comedi: adv_pci1710: fixed multiple brace coding style issue
Date: Sun, 21 Mar 2010 02:14:06 +0800
Message-Id: <1269108850-1414-6-git-send-email-tsanghan@gmail.com>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <Jason Wong <tsanghan@gmail.com>
References: <Jason Wong <tsanghan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed multiple coding style issue.

Signed-off-by: Jason Wong <tsanghan@gmail.com>
---
 drivers/staging/comedi/drivers/adv_pci1710.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index 394d2ea..f5bb286 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -657,9 +657,9 @@ static void interrupt_pci1710_every_sample(void *d)
 #endif
 		++s->async->cur_chan;
 
-		if (s->async->cur_chan >= devpriv->ai_n_chan) {
+		if (s->async->cur_chan >= devpriv->ai_n_chan)
 			s->async->cur_chan = 0;
-		}
+
 
 		if (s->async->cur_chan == 0) {	/*  one scan done */
 			devpriv->ai_act_scan++;
@@ -863,12 +863,12 @@ static int pci171x_ai_docmd_and_mode(int mode, struct comedi_device *dev,
 		devpriv->ai_eos = 0;
 	}
 
-	if ((devpriv->ai_scans == 0) || (devpriv->ai_scans == -1)) {
+	if ((devpriv->ai_scans == 0) || (devpriv->ai_scans == -1))
 		devpriv->neverending_ai = 1;
-	} /* well, user want neverending */
-	else {
+	/* well, user want neverending */
+	else
 		devpriv->neverending_ai = 0;
-	}
+
 	switch (mode) {
 	case 1:
 	case 2:
@@ -1109,11 +1109,11 @@ static int pci171x_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	devpriv->ai_timer1 = 0;
 	devpriv->ai_timer2 = 0;
 
-	if (cmd->stop_src == TRIG_COUNT) {
+	if (cmd->stop_src == TRIG_COUNT)
 		devpriv->ai_scans = cmd->stop_arg;
-	} else {
+	else
 		devpriv->ai_scans = 0;
-	}
+
 
 	if (cmd->scan_begin_src == TRIG_FOLLOW) {	/*  mode 1, 2, 3 */
 		if (cmd->convert_src == TRIG_TIMER) {	/*  mode 1 and 2 */
@@ -1593,9 +1593,9 @@ static int pci1710_detach(struct comedi_device *dev)
 		if (dev->irq)
 			free_irq(dev->irq, dev);
 		if (devpriv->pcidev) {
-			if (dev->iobase) {
+			if (dev->iobase)
 				comedi_pci_disable(devpriv->pcidev);
-			}
+
 			pci_dev_put(devpriv->pcidev);
 		}
 	}
-- 
1.7.0.2

