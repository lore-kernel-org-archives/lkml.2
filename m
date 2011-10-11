Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab1JKSZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 14:25:44 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46351 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755442Ab1JKSZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 14:25:38 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH] pata_sc1200: do not use c99 style comments
Date: Tue, 11 Oct 2011 20:05:49 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop-dirty; KDE/4.6.0; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110112005.49645.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_sc1200: do not use c99 style comments

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_sc1200.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

Index: b/drivers/ata/pata_sc1200.c
===================================================================
--- a/drivers/ata/pata_sc1200.c
+++ b/drivers/ata/pata_sc1200.c
@@ -86,10 +86,14 @@ static int sc1200_clock(void)
 static void sc1200_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
 	static const u32 pio_timings[4][5] = {
-		{0x00009172, 0x00012171, 0x00020080, 0x00032010, 0x00040010},	// format0  33Mhz
-		{0xd1329172, 0x71212171, 0x30200080, 0x20102010, 0x00100010},	// format1, 33Mhz
-		{0xfaa3f4f3, 0xc23232b2, 0x513101c1, 0x31213121, 0x10211021},	// format1, 48Mhz
-		{0xfff4fff4, 0xf35353d3, 0x814102f1, 0x42314231, 0x11311131}	// format1, 66Mhz
+		/* format0, 33Mhz */
+		{ 0x00009172, 0x00012171, 0x00020080, 0x00032010, 0x00040010 },
+		/* format1, 33Mhz */
+		{ 0xd1329172, 0x71212171, 0x30200080, 0x20102010, 0x00100010 },
+		/* format1, 48Mhz */
+		{ 0xfaa3f4f3, 0xc23232b2, 0x513101c1, 0x31213121, 0x10211021 },
+		/* format1, 66Mhz */
+		{ 0xfff4fff4, 0xf35353d3, 0x814102f1, 0x42314231, 0x11311131 }
 	};
 
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
