Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab0CXIp1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 04:45:27 -0400
Received: from mail-yw0-f172.google.com ([209.85.211.172]:40003 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab0CXIp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 04:45:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=EzaGEY1JThkSqmRrUDsqspAQ9YX7ZlXlq7lrTmsHaaVRgXRHDE61+X1TJHa/PQrA14
         niOuMwxUSlndcd7ZqHYcmcoxhZA+etzR5TTTLUSprzC3yx6qyn9WvuypapL2Cmce78vY
         kP1winA1mcyiGmhCo0pR9OcGdV/shHNivzvTo=
From: Soeren Moeller <soerenmoeller2001@gmail.com>
To: gregkh@suse.de, soerenmoeller2001@gmail.com, peterhuewe@gmx.de,
       jgarzik@redhat.com, alan@linux.intel.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] Staging: phison: fix space before tabular coding style issues
Date: Wed, 24 Mar 2010 08:44:49 +0000
Message-Id: <1269420289-15219-1-git-send-email-soerenmoeller2001@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes two space before tabular warning in phison.c, found by checkpatch.pl

Signed-off-by: Soeren Moeller <soerenmoeller2001@gmail.com>
---
 drivers/staging/phison/phison.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/phison/phison.c b/drivers/staging/phison/phison.c
index 0c495ea..42783d7 100644
--- a/drivers/staging/phison/phison.c
+++ b/drivers/staging/phison/phison.c
@@ -23,7 +23,7 @@
 #define PHISON_DEBUG
 
 #define DRV_NAME		"phison_e-box"	/* #0003 */
-#define DRV_VERSION 		"0.91"		/* #0003 */
+#define DRV_VERSION		"0.91"		/* #0003 */
 
 #define PCI_VENDOR_ID_PHISON	0x1987
 #define PCI_DEVICE_ID_PS5000	0x5000
@@ -56,7 +56,7 @@ static int phison_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 		.pio_mask	= 0x1f,
 		.mwdma_mask	= 0x07,
-		.udma_mask 	= ATA_UDMA5,
+		.udma_mask	= ATA_UDMA5,
 
 		.port_ops	= &phison_ops,
 	};
-- 
1.6.3.3

