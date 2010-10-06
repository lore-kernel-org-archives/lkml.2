Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758532Ab0JFBDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 21:03:14 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47044 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758317Ab0JFBB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 21:01:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=EAny1C3EB8+d6xFDAOy7dLITxYFhOMbljNPjARiUCDmRI1bhvqHIh+nIvTSXEjdlpF
         igbcrR1GHUUGwi3l1wNWfR6DZJahrvhCQQGWfmJbi4jlZNdYWftarJfVrmyBZAuRSyWh
         KUMJUW+plsmuUiin9zXmgyaa7TJ13Cs26qrXY=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com, abbotti@mev.co.uk, fmhess@users.sourceforge.net
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 22/28] Staging: comedi: drivers: adv_pci1710.c: Edit file so that checkpatch.pl complains a little less
Date: Tue,  5 Oct 2010 21:00:37 -0400
Message-Id: <1286326843-6170-22-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286326843-6170-1-git-send-email-tdent48227@gmail.com>
References: <1286326843-6170-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed a few lines that made checkpatch.pl complain. All warnings that I correcct were
WARNING: please, no space for starting a line and a few WARNING: line over 80 characters.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/comedi/drivers/adv_pci1710.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index bdd6954..2afa36b 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -22,8 +22,8 @@ Description: Advantech PCI-1710, PCI-1710HG, PCI-1711, PCI-1713,
 	     Advantech PCI-1720, PCI-1731
 Author: Michal Dobes <dobes@tesnet.cz>
 Devices: [Advantech] PCI-1710 (adv_pci1710), PCI-1710HG (pci1710hg),
-  PCI-1711 (adv_pci1710), PCI-1713, PCI-1720,
-  PCI-1731
+	PCI-1711 (adv_pci1710), PCI-1713, PCI-1720,
+	PCI-1731
 Status: works
 
 This driver supports AI, AO, DI and DO subdevices.
@@ -35,10 +35,10 @@ driver cannot distinguish between them, as would be normal for a
 PCI driver.
 
 Configuration options:
-  [0] - PCI bus of device (optional)
-  [1] - PCI slot of device (optional)
-	If bus/slot is not specified, the first available PCI
-	device will be used.
+	[0] - PCI bus of device (optional)
+	[1] - PCI slot of device (optional)
+		If bus/slot is not specified, the first available PCI
+		device will be used.
 */
 
 #include <linux/interrupt.h>
@@ -645,7 +645,8 @@ static void interrupt_pci1710_every_sample(void *d)
 			if ((sampl & 0xf000) !=
 			    devpriv->act_chanlist[s->async->cur_chan]) {
 				printk
-				    ("comedi: A/D data dropout: received data from channel %d, expected %d!\n",
+				    ("comedi: A/D data dropout: received data \
+					from channel %d, expected %d!\n",
 				     (sampl & 0xf000) >> 12,
 				     (devpriv->
 				      act_chanlist[s->
@@ -1143,9 +1144,9 @@ static int pci171x_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 
 /*
 ==============================================================================
- Check if channel list from user is builded correctly
- If it's ok, then program scan/gain logic.
- This works for all cards.
+	Check if channel list from user is builded correctly
+	If it's ok, then program scan/gain logic.
+	This works for all cards.
 */
 static int check_channel_list(struct comedi_device *dev,
 			      struct comedi_subdevice *s,
-- 
1.7.3.1.50.g1e633

