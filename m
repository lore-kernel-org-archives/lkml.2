Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab1KUKhq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 05:37:46 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64088 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835Ab1KUKhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 05:37:43 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 5/8] Staging: comedi: fix brace coding style issue in ni_pcimio.c
Date: Mon, 21 Nov 2011 16:07:03 +0530
Message-Id: <1321871826-13581-5-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1321871826-13581-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1321871826-13581-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the ni_pcimio.c file that fixes up a brace
warning found by the checkpatch.pl tool.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/ni_pcimio.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_pcimio.c b/drivers/staging/comedi/drivers/ni_pcimio.c
index 9148abd..99f762d 100644
--- a/drivers/staging/comedi/drivers/ni_pcimio.c
+++ b/drivers/staging/comedi/drivers/ni_pcimio.c
@@ -1632,9 +1632,8 @@ static void m_series_init_eeprom_buffer(struct comedi_device *dev)
 	}
 	devpriv->serial_number = be32_to_cpu(devpriv->serial_number);
 
-	for (i = 0; i < M_SERIES_EEPROM_SIZE; ++i) {
+	for (i = 0; i < M_SERIES_EEPROM_SIZE; ++i)
 		devpriv->eeprom_buffer[i] = ni_readb(Start_Cal_EEPROM + i);
-	}
 
 	writel(old_iodwbsr1_bits, devpriv->mite->mite_io_addr + MITE_IODWBSR_1);
 	writel(old_iodwbsr_bits, devpriv->mite->mite_io_addr + MITE_IODWBSR);
@@ -1665,9 +1664,9 @@ static void init_6143(struct comedi_device *dev)
 static int pcimio_detach(struct comedi_device *dev)
 {
 	mio_common_detach(dev);
-	if (dev->irq) {
+	if (dev->irq)
 		free_irq(dev->irq, dev);
-	}
+
 	if (dev->private) {
 		mite_free_ring(devpriv->ai_mite_ring);
 		mite_free_ring(devpriv->ao_mite_ring);
-- 
1.7.0.4

