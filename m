Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757165Ab1GKGVH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 02:21:07 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38927 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756588Ab1GKGVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 02:21:05 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 5/5] Staging: comedi: fix brace coding style issue in pcl818.c
Date: Mon, 11 Jul 2011 12:03:42 +0530
Message-Id: <1310366022-20797-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH 5/5]Staging: comedi: fix brace coding style issue in pcl818.c>
References: <[PATCH 5/5]Staging: comedi: fix brace coding style issue in pcl818.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the pcl818.c file that fixes up a brace warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/pcl818.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index 046340e..241b16b 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -1785,12 +1785,10 @@ static int pcl818_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	}
 
 	dev->irq = irq;
-	if (irq) {
-		devpriv->irq_free = 1;
-	} /* 1=we have allocated irq */
-	else {
+	if (irq)
+		devpriv->irq_free = 1;		/* 1=we have allocated irq */
+	else
 		devpriv->irq_free = 0;
-	}
 	devpriv->irq_blocked = 0;	/* number of subdevice which use IRQ */
 	devpriv->ai_mode = 0;	/* mode of irq */
 
@@ -2002,11 +2000,10 @@ no_dma:
 	}
 
 	/* select 1/10MHz oscilator */
-	if ((it->options[3] == 0) || (it->options[3] == 10)) {
+	if ((it->options[3] == 0) || (it->options[3] == 10))
 		devpriv->i8253_osc_base = 100;
-	} else {
+	else
 		devpriv->i8253_osc_base = 1000;
-	}
 
 	/* max sampling speed */
 	devpriv->ns_min = this_board->ns_min;
-- 
1.6.5.2

