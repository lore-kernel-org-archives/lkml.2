Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690Ab2I1RXg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 13:23:36 -0400
Received: from smtp181.dfw.emailsrvr.com ([67.192.241.181]:38526 "EHLO
	smtp181.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758676Ab2I1RXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 13:23:34 -0400
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
To: linux-next@vger.kernel.org
Cc: sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, jgarzik@pobox.com,
        Mark Langsdorf <mark.langsdorf@calxeda.com>
Subject: [PATCH] ata: Fix build error in sata_highbank
Date: Fri, 28 Sep 2012 12:23:37 -0500
Message-Id: <1348853017-9205-1-git-send-email-mark.langsdorf@calxeda.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Langsdorf <Mark Langsdorf>

Allow sata_highbank to build even if no other users of libahci.o are built.

Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
---
 drivers/ata/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index 8b384f1..9329daf 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -9,7 +9,7 @@ obj-$(CONFIG_SATA_FSL)		+= sata_fsl.o
 obj-$(CONFIG_SATA_INIC162X)	+= sata_inic162x.o
 obj-$(CONFIG_SATA_SIL24)	+= sata_sil24.o
 obj-$(CONFIG_SATA_DWC)		+= sata_dwc_460ex.o
-obj-$(CONFIG_SATA_HIGHBANK)	+= sata_highbank.o
+obj-$(CONFIG_SATA_HIGHBANK)	+= sata_highbank.o libahci.o
 
 # SFF w/ custom DMA
 obj-$(CONFIG_PDC_ADMA)		+= pdc_adma.o
-- 
1.7.10.4

