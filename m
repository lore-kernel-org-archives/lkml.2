Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab2HRRbi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 13:31:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:8308 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754652Ab2HRRa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 13:30:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,791,1336374000"; 
   d="scan'208";a="182354048"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 16/31] sections: Fix section conflicts in drivers/macintosh
Date: Sat, 18 Aug 2012 10:30:07 -0700
Message-Id: <1345311022-26328-17-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
References: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/macintosh/macio_asic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/macintosh/macio_asic.c b/drivers/macintosh/macio_asic.c
index 20e5c2c..9e849a9 100644
--- a/drivers/macintosh/macio_asic.c
+++ b/drivers/macintosh/macio_asic.c
@@ -748,7 +748,7 @@ static void __devexit macio_pci_remove(struct pci_dev* pdev)
  * MacIO is matched against any Apple ID, it's probe() function
  * will then decide wether it applies or not
  */
-static const struct pci_device_id __devinitdata pci_ids [] = { {
+static const struct pci_device_id __devinitconst pci_ids [] = { {
 	.vendor		= PCI_VENDOR_ID_APPLE,
 	.device		= PCI_ANY_ID,
 	.subvendor	= PCI_ANY_ID,
-- 
1.7.7.6

