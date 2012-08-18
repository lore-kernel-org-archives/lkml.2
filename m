Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab2HRRcG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 13:32:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:38273 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754682Ab2HRRa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 13:30:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,791,1336374000"; 
   d="scan'208";a="188137645"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 19/31] sections: Fix section conflicts in drivers/misc
Date: Sat, 18 Aug 2012 10:30:10 -0700
Message-Id: <1345311022-26328-20-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
References: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/misc/pti.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/pti.c b/drivers/misc/pti.c
index b7eb545..5cb61f7 100644
--- a/drivers/misc/pti.c
+++ b/drivers/misc/pti.c
@@ -76,7 +76,7 @@ struct pti_dev {
  */
 static DEFINE_MUTEX(alloclock);
 
-static struct pci_device_id pci_ids[] __devinitconst = {
+static const struct pci_device_id pci_ids[] __devinitconst = {
 		{PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x82B)},
 		{0}
 };
-- 
1.7.7.6

