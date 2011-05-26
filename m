Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932477Ab1EZOLk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 10:11:40 -0400
Received: from adelie.canonical.com ([91.189.90.139]:36410 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932360Ab1EZOLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 10:11:38 -0400
From: Manoj Iyer <manoj.iyer@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: chris@cnpbagwell.com
Subject: [PATCH] mmc: Enable MMC card reader for RICOH [1180:e823]
Date: Thu, 26 May 2011 09:11:18 -0500
Message-Id: <1306419078-2669-2-git-send-email-manoj.iyer@canonical.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1306419078-2669-1-git-send-email-manoj.iyer@canonical.com>
References: <1306419078-2669-1-git-send-email-manoj.iyer@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>
---
 drivers/pci/quirks.c    |    2 ++
 include/linux/pci_ids.h |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index e8a1406..02145e9 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2761,6 +2761,8 @@ static void ricoh_mmc_fixup_r5c832(struct pci_dev *dev)
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5C832, ricoh_mmc_fixup_r5c832);
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5C832, ricoh_mmc_fixup_r5c832);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5CE823, ricoh_mmc_fixup_r5c832);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5CE823, ricoh_mmc_fixup_r5c832);
 #endif /*CONFIG_MMC_RICOH_MMC*/
 
 #if defined(CONFIG_DMAR) || defined(CONFIG_INTR_REMAP)
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 24787b7..2269dac 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1537,6 +1537,7 @@
 #define PCI_DEVICE_ID_RICOH_RL5C476	0x0476
 #define PCI_DEVICE_ID_RICOH_RL5C478	0x0478
 #define PCI_DEVICE_ID_RICOH_R5C822	0x0822
+#define PCI_DEVICE_ID_RICOH_R5CE823	0xe823
 #define PCI_DEVICE_ID_RICOH_R5C832	0x0832
 #define PCI_DEVICE_ID_RICOH_R5C843	0x0843
 
-- 
1.7.4.1

