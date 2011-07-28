Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283Ab1G1Xy3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:54:29 -0400
Received: from mga14.intel.com ([143.182.124.37]:11646 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756136Ab1G1XoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:44:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,285,1309762800"; 
   d="scan'208";a="32808889"
From: Andi Kleen <andi@firstfloor.org>
References: <20110728444.299940435@firstfloor.org>
In-Reply-To: <20110728444.299940435@firstfloor.org>
To: manoj.iyer@canonical.com, cjb@laptop.org, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [8/50] mmc: Add PCI fixup quirks for Ricoh 1180:e823 reader
Message-Id: <20110728234412.714AF2403FF@tassilo.jf.intel.com>
Date: Thu, 28 Jul 2011 16:44:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Manoj Iyer <manoj.iyer@canonical.com>

[ upstream commit be98ca652faa6468916a9b7608befff215a8ca70 ]

Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>
Cc: <stable@kernel.org>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/drivers/pci/quirks.c
===================================================================
--- linux-2.6.35.y.orig/drivers/pci/quirks.c
+++ linux-2.6.35.y/drivers/pci/quirks.c
@@ -2701,6 +2701,8 @@ static void ricoh_mmc_fixup_r5c832(struc
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5C832, ricoh_mmc_fixup_r5c832);
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5C832, ricoh_mmc_fixup_r5c832);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5CE823, ricoh_mmc_fixup_r5c832);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5CE823, ricoh_mmc_fixup_r5c832);
 #endif /*CONFIG_MMC_RICOH_MMC*/
 
 #if defined(CONFIG_DMAR) || defined(CONFIG_INTR_REMAP)
Index: linux-2.6.35.y/include/linux/pci_ids.h
===================================================================
--- linux-2.6.35.y.orig/include/linux/pci_ids.h
+++ linux-2.6.35.y/include/linux/pci_ids.h
@@ -1524,6 +1524,7 @@
 #define PCI_DEVICE_ID_RICOH_RL5C476	0x0476
 #define PCI_DEVICE_ID_RICOH_RL5C478	0x0478
 #define PCI_DEVICE_ID_RICOH_R5C822	0x0822
+#define PCI_DEVICE_ID_RICOH_R5CE823	0xe823
 #define PCI_DEVICE_ID_RICOH_R5C832	0x0832
 #define PCI_DEVICE_ID_RICOH_R5C843	0x0843
 
