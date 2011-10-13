Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab1JMNp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 09:45:59 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60895 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755374Ab1JMNpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 09:45:55 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH v2 3/4] ata_piix: CodingStyle fixes
Date: Thu, 13 Oct 2011 15:43:29 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop-dirty; KDE/4.6.0; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110131543.30235.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ata_piix: CodingStyle fixes

CodingStyle fixes for piix_port_info[].

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/ata_piix.c |   68 ++++++++++++++-----------------------------------
 1 file changed, 20 insertions(+), 48 deletions(-)

Index: b/drivers/ata/ata_piix.c
===================================================================
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -473,131 +473,103 @@ static const struct piix_map_db *piix_ma
 };
 
 static struct ata_port_info piix_port_info[] = {
-	[piix_pata_mwdma] = 	/* PIIX3 MWDMA only */
-	{
+	[piix_pata_mwdma] = {	/* PIIX3 MWDMA only */
 		.flags		= PIIX_PATA_FLAGS,
 		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA12_ONLY, /* mwdma1-2 ?? CHECK 0 should be ok but slow */
+		.mwdma_mask	= ATA_MWDMA12_ONLY, /* check if MWDMA0 is OK */
 		.port_ops	= &piix_pata_ops,
 	},
-
-	[piix_pata_33] =	/* PIIX4 at 33MHz */
-	{
+	[piix_pata_33] = {	/* PIIX4 at 33MHz */
 		.flags		= PIIX_PATA_FLAGS,
 		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA12_ONLY, /* mwdma1-2 ?? CHECK 0 should be ok but slow */
+		.mwdma_mask	= ATA_MWDMA12_ONLY, /* check if MWDMA0 is OK */
 		.udma_mask	= ATA_UDMA2,
 		.port_ops	= &piix_pata_ops,
 	},
-
-	[ich_pata_33] = 	/* ICH0 - ICH at 33Mhz*/
-	{
+	[ich_pata_33] = {	/* ICH0 - ICH at 33Mhz*/
 		.flags		= PIIX_PATA_FLAGS,
-		.pio_mask 	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA12_ONLY, /* Check: maybe MWDMA0 is ok  */
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA12_ONLY, /* check if MWDMA0 is OK */
 		.udma_mask	= ATA_UDMA2,
 		.port_ops	= &ich_pata_ops,
 	},
-
-	[ich_pata_66] = 	/* ICH controllers up to 66MHz */
-	{
+	[ich_pata_66] = {	/* ICH controllers up to 66MHz */
 		.flags		= PIIX_PATA_FLAGS,
-		.pio_mask 	= ATA_PIO4,
+		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA12_ONLY, /* MWDMA0 is broken on chip */
 		.udma_mask	= ATA_UDMA4,
 		.port_ops	= &ich_pata_ops,
 	},
-
-	[ich_pata_100] =
-	{
+	[ich_pata_100] = {
 		.flags		= PIIX_PATA_FLAGS | PIIX_FLAG_CHECKINTR,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA12_ONLY,
 		.udma_mask	= ATA_UDMA5,
 		.port_ops	= &ich_pata_ops,
 	},
-
-	[ich_pata_100_nomwdma1] =
-	{
+	[ich_pata_100_nomwdma1] = {
 		.flags		= PIIX_PATA_FLAGS | PIIX_FLAG_CHECKINTR,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2_ONLY,
 		.udma_mask	= ATA_UDMA5,
 		.port_ops	= &ich_pata_ops,
 	},
-
-	[ich5_sata] =
-	{
+	[ich5_sata] = {
 		.flags		= PIIX_SATA_FLAGS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &piix_sata_ops,
 	},
-
-	[ich6_sata] =
-	{
+	[ich6_sata] = {
 		.flags		= PIIX_SATA_FLAGS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &piix_sata_ops,
 	},
-
-	[ich6m_sata] =
-	{
+	[ich6m_sata] = {
 		.flags		= PIIX_SATA_FLAGS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &piix_sata_ops,
 	},
-
-	[ich8_sata] =
-	{
+	[ich8_sata] = {
 		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SIDPR,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &piix_sata_ops,
 	},
-
-	[ich8_2port_sata] =
-	{
+	[ich8_2port_sata] = {
 		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SIDPR,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &piix_sata_ops,
 	},
-
-	[tolapai_sata] =
-	{
+	[tolapai_sata] = {
 		.flags		= PIIX_SATA_FLAGS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &piix_sata_ops,
 	},
-
-	[ich8m_apple_sata] =
-	{
+	[ich8m_apple_sata] = {
 		.flags		= PIIX_SATA_FLAGS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &piix_sata_ops,
 	},
-
-	[piix_pata_vmw] =
-	{
+	[piix_pata_vmw] = {
 		.flags		= PIIX_PATA_FLAGS,
 		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA12_ONLY, /* mwdma1-2 ?? CHECK 0 should be ok but slow */
+		.mwdma_mask	= ATA_MWDMA12_ONLY, /* check if MWDMA0 is OK */
 		.udma_mask	= ATA_UDMA2,
 		.port_ops	= &piix_vmw_ops,
 	},
-
 };
 
 static struct pci_bits piix_enable_bits[] = {
