Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471Ab1GFGeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 02:34:18 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:58721 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab1GFGeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 02:34:17 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 2/2] Staging: comedi: fix WARNING issue in icp_multi.c
Date: Wed,  6 Jul 2011 12:03:46 +0530
Message-Id: <1309934026-2677-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <[PATCH]Staging: comedi: fix tab space warning issues in icp_multi.c>
References: <[PATCH]Staging: comedi: fix tab space warning issues in icp_multi.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the icp_multi.c file that fixes up a WARNING found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/icp_multi.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/icp_multi.c b/drivers/staging/comedi/drivers/icp_multi.c
index 126550f..78f33e7 100644
--- a/drivers/staging/comedi/drivers/icp_multi.c
+++ b/drivers/staging/comedi/drivers/icp_multi.c
@@ -59,13 +59,12 @@ Options:
 #include "icp_multi.h"
 
 #define DEVICE_ID	0x8000	/* Device ID */
+#define ICP_MULTI_EXTDEBUG	/*       */
 
-#define ICP_MULTI_EXTDEBUG
+/* Hardware types of the cards */
+#define TYPE_ICP_MULTI 0
 
-/*  Hardware types of the cards */
-#define TYPE_ICP_MULTI	0
-
-#define IORANGE_ICP_MULTI 	32
+#define IORANGE_ICP_MULTI 32
 
 #define ICP_MULTI_ADC_CSR	0	/* R/W: ADC command/status register */
 #define ICP_MULTI_AI		2	/* R:   Analogue input data */
@@ -572,7 +571,7 @@ static int icp_multi_insn_bits_do(struct comedi_device *dev,
 		s->state &= ~data[0];
 		s->state |= (data[0] & data[1]);
 
-		printk(KERN_DEBUG "Digital outputs = %4x \n", s->state);
+		printk(KERN_DEBUG "Digital outputs = %4x\n", s->state);
 
 		writew(s->state, devpriv->io_addr + ICP_MULTI_DO);
 	}
@@ -966,7 +965,7 @@ static int icp_multi_attach(struct comedi_device *dev,
 	devpriv->phys_iobase = iobase;
 
 	printk(KERN_WARNING
-	       ", b:s:f=%d:%d:%d, io=0x%8llx \n", pci_bus, pci_slot, pci_func,
+	       ", b:s:f=%d:%d:%d, io=0x%8llx\n", pci_bus, pci_slot, pci_func,
 	       (unsigned long long)iobase);
 
 	devpriv->io_addr = ioremap(iobase, ICP_MULTI_SIZE);
-- 
1.7.1.1

