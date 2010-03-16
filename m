Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966481Ab0CPPZe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 11:25:34 -0400
Received: from h-31-136.A159.priv.bahnhof.se ([79.136.31.136]:45089 "EHLO
	gannon" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966352Ab0CPPZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 11:25:32 -0400
X-Greylist: delayed 2606 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Mar 2010 11:25:32 EDT
From: Jonas Lundqvist <jonas@gannon.se>
To: gregkh@suse.de, peterhuewe@gmx.de, jgarzik@redhat.com,
       alan@linux.intel.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Jonas Lundqvist <jonas@gannon.se>
Subject: [PATCH] Staging: phison: fix incorrect tabs in phison.c This patch fixes two incorrect tab warnings found by the checkpatch.pl tool Signed-off-by: Jonas Lundqvist <jonas@gannon.se>
Date: Tue, 16 Mar 2010 15:41:09 +0100
Message-Id: <1268750469-6572-1-git-send-email-jonas@gannon.se>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
1.7.0

