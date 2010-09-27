Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932612Ab0I0Cfl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 22:35:41 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36853 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544Ab0I0Cfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 22:35:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=rAM3T37yLc8FumANpSG7wG0uiDp3YzFXUma8cGVf/cgaoeZfIbUbYEGKRU31D+dtx8
         vHs2h/hxGKrrJHdhZd/3PzqprlnJ68hxBeVdFoGMSvhSa5vbPzC86Gm3AKI5fbnGuX1T
         DOvWNBTPizNMDezK4tD6j3Yl1xvCcx+fpbpHQ=
From: Otavio Salvador <otavio@ossystems.com.br>
To: linux-kernel@vger.kernel.org
Cc: Otavio Salvador <otavio@ossystems.com.br>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: [PATCH 1/4] pata-it821x: use UDMA_OFF for Vortex86SX for clearness
Date: Sun, 26 Sep 2010 23:35:04 -0300
Message-Id: <1285554907-4495-1-git-send-email-otavio@ossystems.com.br>
X-Mailer: git-send-email 1.7.2.3.313.gcd15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Otavio Salvador <otavio@ossystems.com.br>
---
 drivers/ata/pata_it821x.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/pata_it821x.c b/drivers/ata/pata_it821x.c
index bf88f71..412cdd2 100644
--- a/drivers/ata/pata_it821x.c
+++ b/drivers/ata/pata_it821x.c
@@ -899,7 +899,7 @@ static int it821x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = ATA_PIO4,
 		.mwdma_mask = ATA_MWDMA2,
-		/* No UDMA */
+		.udma_mask = UDMA_OFF,
 		.port_ops = &it821x_rdc_port_ops
 	};
 
-- 
1.7.2.3.313.gcd15

