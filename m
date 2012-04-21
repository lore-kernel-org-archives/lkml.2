Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427Ab2DUJMu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 05:12:50 -0400
Received: from smtp4.mail.ru ([94.100.176.44]:47662 "EHLO smtp4.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753388Ab2DUJKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 05:10:22 -0400
From: Alexander Shiyan <shc_work@mail.ru>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH 08/17] ARM clps711x: Cleanup: remove unused definitions for ep_readl/ep_writel
Date: Sat, 21 Apr 2012 13:11:21 +0400
Message-Id: <1334999490-27177-9-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1334999490-27177-1-git-send-email-shc_work@mail.ru>
References: <1334999490-27177-1-git-send-email-shc_work@mail.ru>
X-Spam: Not detected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 arch/arm/include/asm/hardware/ep7212.h |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/arm/include/asm/hardware/ep7212.h b/arch/arm/include/asm/hardware/ep7212.h
index 0b1f508..2672291 100644
--- a/arch/arm/include/asm/hardware/ep7212.h
+++ b/arch/arm/include/asm/hardware/ep7212.h
@@ -25,11 +25,6 @@
 
 #define EP7212_PHYS_BASE	(0x80000000)
 
-#ifndef __ASSEMBLY__
-#define ep_readl(off)		__raw_readl(CLPS7111_BASE + (off))
-#define ep_writel(val,off)	__raw_writel(val, CLPS7111_BASE + (off))
-#endif
-
 /*
  * These registers are specific to the EP7212 only
  */
-- 
1.7.3.4

