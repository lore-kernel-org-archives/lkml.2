Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209Ab1KUKiA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 05:38:00 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64088 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835Ab1KUKh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 05:37:58 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 8/8] Staging: comedi: fix brace coding style issue in pcmuio.c
Date: Mon, 21 Nov 2011 16:07:06 +0530
Message-Id: <1321871826-13581-8-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1321871826-13581-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1321871826-13581-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the pcmuio.c file that fixes up a brace
warning found by the checkpatch.pl tool.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/pcmuio.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcmuio.c b/drivers/staging/comedi/drivers/pcmuio.c
index b2c2c89..0c5b06d 100644
--- a/drivers/staging/comedi/drivers/pcmuio.c
+++ b/drivers/staging/comedi/drivers/pcmuio.c
@@ -951,14 +951,13 @@ pcmuio_inttrig_start_intr(struct comedi_device *dev, struct comedi_subdevice *s,
 
 	spin_lock_irqsave(&subpriv->intr.spinlock, flags);
 	s->async->inttrig = 0;
-	if (subpriv->intr.active) {
+	if (subpriv->intr.active)
 		event = pcmuio_start_intr(dev, s);
-	}
+
 	spin_unlock_irqrestore(&subpriv->intr.spinlock, flags);
 
-	if (event) {
+	if (event)
 		comedi_event(dev, s);
-	}
 
 	return 1;
 }
@@ -1000,9 +999,8 @@ static int pcmuio_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	}
 	spin_unlock_irqrestore(&subpriv->intr.spinlock, flags);
 
-	if (event) {
+	if (event)
 		comedi_event(dev, s);
-	}
 
 	return 0;
 }
-- 
1.7.0.4

