Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab0DVDq0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 23:46:26 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:38080 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab0DVDqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 23:46:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=H+AJRUHt7iaydNVbqaCE2kJIJGrQe75DhASlCb4c2ap03nSPYZ0z4DZ5Gc2ASKY7Bd
         CJz0DhzdoXzH/NfzoIuPxxz1mK/9AqvOi2QbcJnxQawmOPM8CGfxkL/iKs38HqFxQL2D
         NEakaHHXP+lXLuZUwhbDoJCesSQcVeXgDtXTY=
From: Gustavo Silva <silvagustavosilva@gmail.com>
To: gregkh@suse.de, abbotti@mev.co.uk
Cc: fmhess@users.sourceforge.net, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, silvagustavo@users.sourceforge.net
Subject: [PATCH] Staging: Comedi: Drivers: Fix coding style issues in dt2801.c
Date: Wed, 21 Apr 2010 22:46:11 -0500
Message-Id: <1271907971-8793-1-git-send-email-silvagustavo@users.sourceforge.net>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the dt2801.c file that fixes up all coding style
issues found by the checkpatch.pl tool.

Signed-off-by: Gustavo Silva <silvagustavo@users.sourceforge.net>
---
 drivers/staging/comedi/drivers/dt2801.c |  100 ++++++++++++++-----------------
 1 files changed, 44 insertions(+), 56 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dt2801.c b/drivers/staging/comedi/drivers/dt2801.c
index 3f365ae..c4408d8 100644
--- a/drivers/staging/comedi/drivers/dt2801.c
+++ b/drivers/staging/comedi/drivers/dt2801.c
@@ -102,58 +102,46 @@ COMEDI_INITCLEANUP(driver_dt2801);
 
 #if 0
 /* ignore 'defined but not used' warning */
-static const struct comedi_lrange range_dt2801_ai_pgh_bipolar = { 4, {
-								      RANGE(-10,
-									    10),
-								      RANGE(-5,
-									    5),
-								      RANGE
-								      (-2.5,
-								       2.5),
-								      RANGE
-								      (-1.25,
-								       1.25),
-								      }
+static const struct comedi_lrange range_dt2801_ai_pgh_bipolar = {
+	4,
+	{
+		RANGE(-10, 10),
+		RANGE(-5, 5),
+		RANGE(-2.5, 2.5),
+		RANGE(-1.25, 1.25),
+	}
 };
 #endif
-static const struct comedi_lrange range_dt2801_ai_pgl_bipolar = { 4, {
-								      RANGE(-10,
-									    10),
-								      RANGE(-1,
-									    1),
-								      RANGE
-								      (-0.1,
-								       0.1),
-								      RANGE
-								      (-0.02,
-								       0.02),
-								      }
+static const struct comedi_lrange range_dt2801_ai_pgl_bipolar = {
+	4,
+	{
+		RANGE(-10, 10),
+		RANGE(-1, 1),
+		RANGE(-0.1, 0.1),
+		RANGE(-0.02, 0.02),
+	}
 };
 
 #if 0
 /* ignore 'defined but not used' warning */
-static const struct comedi_lrange range_dt2801_ai_pgh_unipolar = { 4, {
-								       RANGE(0,
-									     10),
-								       RANGE(0,
-									     5),
-								       RANGE(0,
-									     2.5),
-								       RANGE(0,
-									     1.25),
-								       }
+static const struct comedi_lrange range_dt2801_ai_pgh_unipolar = {
+	4,
+	{
+		RANGE(0, 10),
+		RANGE(0, 5),
+		RANGE(0, 2.5),
+		RANGE(0, 1.25),
+	}
 };
 #endif
-static const struct comedi_lrange range_dt2801_ai_pgl_unipolar = { 4, {
-								       RANGE(0,
-									     10),
-								       RANGE(0,
-									     1),
-								       RANGE(0,
-									     0.1),
-								       RANGE(0,
-									     0.02),
-								       }
+static const struct comedi_lrange range_dt2801_ai_pgl_unipolar = {
+	4,
+	{
+		RANGE(0, 10),
+		RANGE(0, 1),
+		RANGE(0, 0.1),
+		RANGE(0, 0.02),
+	}
 };
 
 struct dt2801_board {
@@ -322,8 +310,8 @@ static int dt2801_writedata(struct comedi_device *dev, unsigned int data)
 		}
 #if 0
 		if (stat & DT_S_READY) {
-			printk
-			    ("dt2801: ready flag set (bad!) in dt2801_writedata()\n");
+			printk(KERN_ERR "dt2801: ready flag set (bad!) in "
+							"dt2801_writedata()\n");
 			return -EIO;
 		}
 #endif
@@ -374,8 +362,8 @@ static int dt2801_writecmd(struct comedi_device *dev, int command)
 
 	stat = inb_p(dev->iobase + DT2801_STATUS);
 	if (stat & DT_S_COMPOSITE_ERROR) {
-		printk
-		    ("dt2801: composite-error in dt2801_writecmd(), ignoring\n");
+		printk(KERN_INFO "dt2801: composite-error in dt2801_writecmd()"
+								", ignoring\n");
 	}
 	if (!(stat & DT_S_READY))
 		printk("dt2801: !ready in dt2801_writecmd(), ignoring\n");
@@ -413,7 +401,7 @@ static int dt2801_reset(struct comedi_device *dev)
 			break;
 	} while (timeout--);
 	if (!timeout)
-		printk("dt2801: timeout 1 status=0x%02x\n", stat);
+		printk(KERN_INFO "dt2801: timeout 1 status=0x%02x\n", stat);
 
 	/* printk("dt2801: reading dummy\n"); */
 	/* dt2801_readdata(dev,&board_code); */
@@ -430,7 +418,7 @@ static int dt2801_reset(struct comedi_device *dev)
 			break;
 	} while (timeout--);
 	if (!timeout)
-		printk("dt2801: timeout 2 status=0x%02x\n", stat);
+		printk(KERN_INFO "dt2801: timeout 2 status=0x%02x\n", stat);
 
 	DPRINTK("dt2801: reading code\n");
 	dt2801_readdata(dev, &board_code);
@@ -528,13 +516,13 @@ static int dt2801_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		if (boardtypes[type].boardcode == board_code)
 			goto havetype;
 	}
-	printk("dt2801: unrecognized board code=0x%02x, contact author\n",
-	       board_code);
+	printk(KERN_WARNING "dt2801: unrecognized board code=0x%02x, "
+					"contact author\n", board_code);
 	type = 0;
 
 havetype:
 	dev->board_ptr = boardtypes + type;
-	printk("dt2801: %s at port 0x%lx", boardtype.name, iobase);
+	printk(KERN_INFO "dt2801: %s at port 0x%lx", boardtype.name, iobase);
 
 	n_ai_chans = probe_number_of_ai_chans(dev);
 	printk(" (ai channels = %d)", n_ai_chans);
@@ -616,12 +604,12 @@ static int dt2801_error(struct comedi_device *dev, int stat)
 {
 	if (stat < 0) {
 		if (stat == -ETIME)
-			printk("dt2801: timeout\n");
+			printk(KERN_ERR "dt2801: timeout\n");
 		else
-			printk("dt2801: error %d\n", stat);
+			printk(KERN_ERR "dt2801: error %d\n", stat);
 		return stat;
 	}
-	printk("dt2801: error status 0x%02x, resetting...\n", stat);
+	printk(KERN_ERR "dt2801: error status 0x%02x, resetting...\n", stat);
 
 	dt2801_reset(dev);
 	dt2801_reset(dev);
-- 
1.5.4.3

