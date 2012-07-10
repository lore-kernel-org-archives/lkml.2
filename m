Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab2GJWbd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 18:31:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46536 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580Ab2GJWba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 18:31:30 -0400
From: Jon Mason <jdmason@kudzu.us>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
Subject: [trivial PATCH 7/7] ioat: remove unused #defines
Date: Tue, 10 Jul 2012 15:31:32 -0700
Message-Id: <1341959492-31389-7-git-send-email-jdmason@kudzu.us>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341959492-31389-1-git-send-email-jdmason@kudzu.us>
References: <1341959492-31389-1-git-send-email-jdmason@kudzu.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IOAT has a redefine of PCI Vendor, PCI Subvendor, etc for
PCI_VENDOR_ID_INTEL but they are never used.  Remove them.

Signed-off-by: Jon Mason <jdmason@kudzu.us>
Cc: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/ioat/hw.h |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/dma/ioat/hw.h b/drivers/dma/ioat/hw.h
index 60e6754..d2ff3fd 100644
--- a/drivers/dma/ioat/hw.h
+++ b/drivers/dma/ioat/hw.h
@@ -22,7 +22,6 @@
 #define _IOAT_HW_H_
 
 /* PCI Configuration Space Values */
-#define IOAT_PCI_VID            0x8086
 #define IOAT_MMIO_BAR		0
 
 /* CB device ID's */
@@ -31,9 +30,6 @@
 #define IOAT_PCI_DID_SCNB       0x65FF
 #define IOAT_PCI_DID_SNB        0x402F
 
-#define IOAT_PCI_RID            0x00
-#define IOAT_PCI_SVID           0x8086
-#define IOAT_PCI_SID            0x8086
 #define IOAT_VER_1_2            0x12    /* Version 1.2 */
 #define IOAT_VER_2_0            0x20    /* Version 2.0 */
 #define IOAT_VER_3_0            0x30    /* Version 3.0 */
-- 
1.7.9.5

