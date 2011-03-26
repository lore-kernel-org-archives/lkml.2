Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934309Ab1CZBoq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 21:44:46 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:47148 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934286Ab1CZBon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 21:44:43 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/9G1BiPJP9b4TdFkC149H4IjL0JbIKvKQmnK4+wn
	Fd8/EJ0otbqGWz
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: Greg KH <gregkh@suse.de>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, Harry Wei <jiaweiwei.xiyou@gmail.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 22/27] staging/vme: Fix common spelling mistakes
Date: Sat, 26 Mar 2011 02:44:06 +0100
Message-Id: <1301103851-16352-22-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1301103851-16352-15-git-send-email-peterhuewe@gmx.de>
References: <1301103851-16352-15-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes some a very common spelling mistake in
drivers/staging/vme.

WRONG -> RIGHT
interupt	-> interrupt

Kernel Version: staging/staging-next 20110325 (4bbba111)

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/vme/bridges/vme_tsi148.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vme/bridges/vme_tsi148.h b/drivers/staging/vme/bridges/vme_tsi148.h
index 9f97fa8..a3ac2fe 100644
--- a/drivers/staging/vme/bridges/vme_tsi148.h
+++ b/drivers/staging/vme/bridges/vme_tsi148.h
@@ -212,7 +212,7 @@ static const int TSI148_LCSR_OT[8] = { TSI148_LCSR_OT0, TSI148_LCSR_OT1,
 #define TSI148_LCSR_OFFSET_OTAT		0x1C
 
 /*
- * VMEbus interupt ack
+ * VMEbus interrupt ack
  * offset  200
  */
 #define TSI148_LCSR_VIACK1	0x204
@@ -613,7 +613,7 @@ static const int TSI148_GCSR_MBOX[4] = { TSI148_GCSR_MBOX0,
 /*
  *  PCI-X Status Register (CRG +$054)
  */
-#define TSI148_PCFS_PCIXSTAT_RSCEM     (1<<29)	/* Recieved Split Comp Error */
+#define TSI148_PCFS_PCIXSTAT_RSCEM     (1<<29)	/* Received Split Comp Error */
 #define TSI148_PCFS_PCIXSTAT_DMCRS_M   (7<<26)	/* max Cumulative Read Size */
 #define TSI148_PCFS_PCIXSTAT_DMOST_M   (7<<23)	/* max outstanding Split Trans
 						 */
@@ -982,8 +982,8 @@ static const int TSI148_GCSR_MBOX[4] = { TSI148_GCSR_MBOX0,
 #define TSI148_LCSR_VICR_CNTS_IRQ1     (2<<22)	/* IRQ1 to Cntr */
 #define TSI148_LCSR_VICR_CNTS_IRQ2     (3<<22)	/* IRQ2 to Cntr */
 
-#define TSI148_LCSR_VICR_EDGIS_M       (3<<20)	/* Edge interupt MASK */
-#define TSI148_LCSR_VICR_EDGIS_DIS     (1<<20)	/* Edge interupt Disable */
+#define TSI148_LCSR_VICR_EDGIS_M       (3<<20)	/* Edge interrupt MASK */
+#define TSI148_LCSR_VICR_EDGIS_DIS     (1<<20)	/* Edge interrupt Disable */
 #define TSI148_LCSR_VICR_EDGIS_IRQ1    (2<<20)	/* IRQ1 to Edge */
 #define TSI148_LCSR_VICR_EDGIS_IRQ2    (3<<20)	/* IRQ2 to Edge */
 
-- 
1.7.3.4

