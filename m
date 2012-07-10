Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab2GJWbS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 18:31:18 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53222 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561Ab2GJWbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 18:31:15 -0400
From: Jon Mason <jdmason@kudzu.us>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, Achim Leubner <achim_leubner@adaptec.com>
Subject: [trivial PATCH 4/7] gdt: remove unnecessary #defines
Date: Tue, 10 Jul 2012 15:31:29 -0700
Message-Id: <1341959492-31389-4-git-send-email-jdmason@kudzu.us>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341959492-31389-1-git-send-email-jdmason@kudzu.us>
References: <1341959492-31389-1-git-send-email-jdmason@kudzu.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove PCI vendor IDs, as they are already defined in pci_ids.h.

Signed-off-by: Jon Mason <jdmason@kudzu.us>
Cc: Achim Leubner <achim_leubner@adaptec.com>
---
 drivers/scsi/gdth.h |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/scsi/gdth.h b/drivers/scsi/gdth.h
index d3e4d7c..fbf6f0f 100644
--- a/drivers/scsi/gdth.h
+++ b/drivers/scsi/gdth.h
@@ -49,15 +49,6 @@
 /* GDT_ISA */
 #define GDT2_ID         0x0120941c              /* GDT2000/2020 */
 
-/* vendor ID, device IDs (PCI) */
-/* these defines should already exist in <linux/pci.h> */
-#ifndef PCI_VENDOR_ID_VORTEX
-#define PCI_VENDOR_ID_VORTEX            0x1119  /* PCI controller vendor ID */
-#endif
-#ifndef PCI_VENDOR_ID_INTEL
-#define PCI_VENDOR_ID_INTEL             0x8086  
-#endif
-
 #ifndef PCI_DEVICE_ID_VORTEX_GDT60x0
 /* GDT_PCI */
 #define PCI_DEVICE_ID_VORTEX_GDT60x0    0       /* GDT6000/6020/6050 */
-- 
1.7.9.5

