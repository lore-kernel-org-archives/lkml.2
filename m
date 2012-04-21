Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab2DUJKd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 05:10:33 -0400
Received: from smtp4.mail.ru ([94.100.176.44]:48327 "EHLO smtp4.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754038Ab2DUJKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 05:10:30 -0400
From: Alexander Shiyan <shc_work@mail.ru>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH 15/17] ARM clps711x: Removed unused definitions from mach/irqs.h
Date: Sat, 21 Apr 2012 13:11:28 +0400
Message-Id: <1334999490-27177-16-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1334999490-27177-1-git-send-email-shc_work@mail.ru>
References: <1334999490-27177-1-git-send-email-shc_work@mail.ru>
X-Spam: Not detected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 arch/arm/mach-clps711x/include/mach/irqs.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-clps711x/include/mach/irqs.h b/arch/arm/mach-clps711x/include/mach/irqs.h
index 30b7e97..3e0c341 100644
--- a/arch/arm/mach-clps711x/include/mach/irqs.h
+++ b/arch/arm/mach-clps711x/include/mach/irqs.h
@@ -35,7 +35,6 @@
 #define IRQ_SSEOTI			15
 
 #define INT1_IRQS			(0x0000fff0)
-#define INT1_ACK_IRQS			(0x00004f10)
 
 /*
  * Interrupts from INTSR2
@@ -47,7 +46,6 @@
 #define IRQ_URXINT2			(16+13)	/* bit 13 */
 
 #define INT2_IRQS			(0x30070000)
-#define INT2_ACK_IRQS			(0x00010000)
 
 #define NR_IRQS                         30
 
-- 
1.7.3.4

