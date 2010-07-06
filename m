Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab0GFSTM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 14:19:12 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33946 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab0GFSTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 14:19:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:date:message-id
         :mime-version:x-mailer:content-transfer-encoding;
        b=NfjE9js6Wk8lUEdtuNdRYXfi5a+ctWrhIy5sbUSiEmtyD9TPyecrtFpMm9mT14Ye+S
         Uc243o0L6O2fCr6TlxOl7AeaVyj5W79lBg4wmmdXbaY1szMc3d9d1LDMqaGx3djIu2aA
         QYN19EBhTKGSVSg5wMYWdcEV4cwu96tkEEAEg=
Subject: [PATCH] Staging: et131x: fix coding style issues in
 et131x_initpci.c
From: Joe Eloff <kagen101@gmail.com>
Reply-To: kagen101@gmail.com
To: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>
Cc: devel <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Jul 2010 19:17:08 +0200
Message-ID: <1278436628.5396.75.camel@dermezel>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From e23e19537c4d62bc76ae982859d3c3225a45d9c2 Mon Sep 17 00:00:00 2001
From: Joe Eloff <kagen101@gmail.com>
Date: Tue, 6 Jul 2010 19:13:28 +0200
Subject: [PATCH] Staging: et131x: fix coding style issues in et131x_initpci.c

This is a patch to the et131x_initpci.c file that fixes up all the
line lengths over 80 by the checkpatch.pl tool.
Signed-off-by: Joe Eloff <kagen101@gmail.com>
---
 drivers/staging/et131x/et131x_initpci.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/et131x/et131x_initpci.c b/drivers/staging/et131x/et131x_initpci.c
index 47baab3..ea93f83 100644
--- a/drivers/staging/et131x/et131x_initpci.c
+++ b/drivers/staging/et131x/et131x_initpci.c
@@ -205,7 +205,8 @@ static int et131x_pci_init(struct et131x_adapter *adapter,
 		if (pci_write_config_word(pdev, ET1310_PCI_REPLAY,
 					       Replay[max_payload])) {
 			dev_err(&pdev->dev,
-			  "Could not write PCI config space for Replay Timer\n");
+			  "Could not write PCI config space for Replay \
+			   Timer\n");
 			return -EIO;
 		}
 	}
@@ -246,7 +247,8 @@ static int et131x_pci_init(struct et131x_adapter *adapter,
 	for (i = 0; i < ETH_ALEN; i++) {
 		if (pci_read_config_byte(pdev, ET1310_PCI_MAC_ADDRESS + i,
 					adapter->PermanentAddress + i)) {
-			dev_err(&pdev->dev, "Could not read PCI config space for MAC address\n");
+			dev_err(&pdev->dev, "Could not read PCI config space \
+					     for MAC address\n");
 			return -EIO;
 		}
 	}
@@ -539,10 +541,12 @@ static struct et131x_adapter *et131x_adapter_init(struct net_device *netdev,
 
 	struct et131x_adapter *etdev;
 
-	/* Setup the fundamental net_device and private adapter structure elements  */
+	/* Setup the fundamental net_device and private
+	   adapter structure elements  */
 	SET_NETDEV_DEV(netdev, &pdev->dev);
 
-	/* Allocate private adapter struct and copy in relevant information */
+	/* Allocate private adapter struct and copy
+	   in relevant information */
 	etdev = netdev_priv(netdev);
 	etdev->pdev = pci_dev_get(pdev);
 	etdev->netdev = netdev;
@@ -655,7 +659,8 @@ static int __devinit et131x_pci_setup(struct pci_dev *pdev,
 		result = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
 		if (result != 0) {
 			dev_err(&pdev->dev,
-				  "Unable to obtain 64 bit DMA for consistent allocations\n");
+				  "Unable to obtain 64 bit DMA for \
+				   consistent allocations\n");
 			goto err_release_res;
 		}
 	} else if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
-- 
1.6.3.3



