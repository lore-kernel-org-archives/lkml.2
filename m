Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934817Ab1IOUMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 16:12:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:48932 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934750Ab1IOUKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 16:10:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="48873445"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 17/27] Initconst section fixes for mmc
Date: Thu, 15 Sep 2011 13:09:44 -0700
Message-Id: <1316117394-21666-18-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
References: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/mmc/host/sdhci-pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index 26c5286..292d261 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -542,7 +542,7 @@ static const struct sdhci_pci_fixes sdhci_via = {
 	.probe		= via_probe,
 };
 
-static const struct pci_device_id pci_ids[] __devinitdata = {
+static const struct pci_device_id pci_ids[] __devinitconst = {
 	{
 		.vendor		= PCI_VENDOR_ID_RICOH,
 		.device		= PCI_DEVICE_ID_RICOH_R5C822,
-- 
1.7.4.4

