Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab1JKSZv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 14:25:51 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46351 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755442Ab1JKSZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 14:25:48 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH 1/3] pata_sil680: documentation fixes
Date: Tue, 11 Oct 2011 20:17:05 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop-dirty; KDE/4.6.0; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110112017.06133.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH v2] pata_sil680: documentation fixes

Fix documentation for sil680_sel[reg,dev]() and sil680_set_[pio,dma]mode().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_sil680.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

Index: b/drivers/ata/pata_sil680.c
===================================================================
--- a/drivers/ata/pata_sil680.c
+++ b/drivers/ata/pata_sil680.c
@@ -38,11 +38,12 @@
 
 /**
  *	sil680_selreg		-	return register base
- *	@hwif: interface
+ *	@ap: ATA interface
  *	@r: config offset
  *
- *	Turn a config register offset into the right address in either
- *	PCI space or MMIO space to access the control register in question
+ *	Turn a config register offset into the right address in PCI space
+ *	to access the control register in question.
+ *
  *	Thankfully this is a configuration operation so isn't performance
  *	criticial.
  */
@@ -56,12 +57,12 @@ static unsigned long sil680_selreg(struc
 
 /**
  *	sil680_seldev		-	return register base
- *	@hwif: interface
+ *	@ap: ATA interface
  *	@r: config offset
  *
- *	Turn a config register offset into the right address in either
- *	PCI space or MMIO space to access the control register in question
- *	including accounting for the unit shift.
+ *	Turn a config register offset into the right address in PCI space
+ *	to access the control register in question including accounting for
+ *	the unit shift.
  */
 
 static unsigned long sil680_seldev(struct ata_port *ap, struct ata_device *adev, int r)
@@ -93,7 +94,7 @@ static int sil680_cable_detect(struct at
 }
 
 /**
- *	sil680_set_piomode	-	set initial PIO mode data
+ *	sil680_set_piomode	-	set PIO mode data
  *	@ap: ATA interface
  *	@adev: ATA device
  *
@@ -140,12 +141,13 @@ static void sil680_set_piomode(struct at
 }
 
 /**
- *	sil680_set_dmamode	-	set initial DMA mode data
+ *	sil680_set_dmamode	-	set DMA mode data
  *	@ap: ATA interface
  *	@adev: ATA device
  *
- *	Program the MWDMA/UDMA modes for the sil680 k
- *	chipset. The MWDMA mode values are pulled from a lookup table
+ *	Program the MWDMA/UDMA modes for the sil680 chipset.
+ *
+ *	The MWDMA mode values are pulled from a lookup table
  *	while the chipset uses mode number for UDMA.
  */
 
