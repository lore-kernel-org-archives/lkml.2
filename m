Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798Ab2FLKEf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 06:04:35 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:4343 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751092Ab2FLKEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 06:04:34 -0400
Message-ID: <1339495469.30984.115.camel@x61.thuisdomein>
Subject: [PATCH] ARM: remove linkup-l1110.h
From: Paul Bolle <pebolle@tiscali.nl>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 12 Jun 2012 12:04:29 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 12 Jun 2012 10:04:29.0171 (UTC) FILETIME=[C16D0C30:01CD4882]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No file includes this header. Nothing seems interested in the things
this header provides. It appears that it has never been included since
at least v2.6.12-rc2. It can safely be removed.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested by "git grepping" the (history of) the tree for a few things.

 arch/arm/include/asm/hardware/linkup-l1110.h |   48 --------------------------
 1 files changed, 0 insertions(+), 48 deletions(-)
 delete mode 100644 arch/arm/include/asm/hardware/linkup-l1110.h

diff --git a/arch/arm/include/asm/hardware/linkup-l1110.h b/arch/arm/include/asm/hardware/linkup-l1110.h
deleted file mode 100644
index 7ec9116..0000000
--- a/arch/arm/include/asm/hardware/linkup-l1110.h
+++ /dev/null
@@ -1,48 +0,0 @@
-/*
-*
-* Definitions for H3600 Handheld Computer
-*
-* Copyright 2001 Compaq Computer Corporation.
-*
-* Use consistent with the GNU GPL is permitted,
-* provided that this copyright notice is
-* preserved in its entirety in all copies and derived works.
-*
-* COMPAQ COMPUTER CORPORATION MAKES NO WARRANTIES, EXPRESSED OR IMPLIED,
-* AS TO THE USEFULNESS OR CORRECTNESS OF THIS CODE OR ITS
-* FITNESS FOR ANY PARTICULAR PURPOSE.
-*
-* Author: Jamey Hicks.
-*
-*/
-
-/* LinkUp Systems PCCard/CompactFlash Interface for SA-1100 */
-
-/* PC Card Status Register */
-#define LINKUP_PRS_S1	(1 << 0) /* voltage control bits S1-S4 */
-#define LINKUP_PRS_S2	(1 << 1)
-#define LINKUP_PRS_S3	(1 << 2)
-#define LINKUP_PRS_S4	(1 << 3)
-#define LINKUP_PRS_BVD1	(1 << 4)
-#define LINKUP_PRS_BVD2	(1 << 5)
-#define LINKUP_PRS_VS1	(1 << 6)
-#define LINKUP_PRS_VS2	(1 << 7)
-#define LINKUP_PRS_RDY	(1 << 8)
-#define LINKUP_PRS_CD1	(1 << 9)
-#define LINKUP_PRS_CD2	(1 << 10)
-
-/* PC Card Command Register */
-#define LINKUP_PRC_S1	(1 << 0)
-#define LINKUP_PRC_S2	(1 << 1)
-#define LINKUP_PRC_S3	(1 << 2)
-#define LINKUP_PRC_S4	(1 << 3)
-#define LINKUP_PRC_RESET (1 << 4)
-#define LINKUP_PRC_APOE	(1 << 5) /* Auto Power Off Enable: clears S1-S4 when either nCD goes high */
-#define LINKUP_PRC_CFE	(1 << 6) /* CompactFlash mode Enable: addresses A[10:0] only, A[25:11] high */
-#define LINKUP_PRC_SOE	(1 << 7) /* signal output driver enable */
-#define LINKUP_PRC_SSP	(1 << 8) /* sock select polarity: 0 for socket 0, 1 for socket 1 */
-#define LINKUP_PRC_MBZ	(1 << 15) /* must be zero */
-
-struct linkup_l1110 {
-	volatile short prc;
-};
-- 
1.7.7.6

