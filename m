Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934848Ab1IOUMG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 16:12:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:46846 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934764Ab1IOUKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 16:10:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="48873448"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, grant.likely@secretlab.ca
Subject: [PATCH 21/27] Initconst section fixes for SPI
Date: Thu, 15 Sep 2011 13:09:48 -0700
Message-Id: <1316117394-21666-22-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
References: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Cc: grant.likely@secretlab.ca
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/spi/spi-dw-pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/spi-dw-pci.c b/drivers/spi/spi-dw-pci.c
index c5f37f0..898d202 100644
--- a/drivers/spi/spi-dw-pci.c
+++ b/drivers/spi/spi-dw-pci.c
@@ -148,7 +148,7 @@ static int spi_resume(struct pci_dev *pdev)
 #define spi_resume	NULL
 #endif
 
-static const struct pci_device_id pci_ids[] __devinitdata = {
+static const struct pci_device_id pci_ids[] __devinitconst = {
 	/* Intel MID platform SPI controller 0 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0800) },
 	{},
-- 
1.7.4.4

