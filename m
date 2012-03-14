Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759464Ab2CNUBJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 16:01:09 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19586 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757033Ab2CNUBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 16:01:01 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6648"; a="172493912"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] ARM: Kconfig: Remove duplicate IRQ Kconfig entries
Date: Wed, 14 Mar 2012 13:00:56 -0700
Message-Id: <1331755256-31163-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.9.3.327.g2980b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These kconfig entries are already defined in kernel/irq/Kconfig
so select them instead of redefining them.

Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/Kconfig |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 7a08e37..a3ae6e9 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -30,6 +30,8 @@ config ARM
 	select HAVE_HW_BREAKPOINT if (PERF_EVENTS && (CPU_V6 || CPU_V6K || CPU_V7))
 	select HAVE_C_RECORDMCOUNT
 	select HAVE_GENERIC_HARDIRQS
+	select HARDIRQS_SW_RESEND
+	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
 	select CPU_PM if (SUSPEND || CPU_IDLE)
 	select GENERIC_PCI_IOMAP
@@ -125,14 +127,6 @@ config TRACE_IRQFLAGS_SUPPORT
 	bool
 	default y
 
-config HARDIRQS_SW_RESEND
-	bool
-	default y
-
-config GENERIC_IRQ_PROBE
-	bool
-	default y
-
 config GENERIC_LOCKBREAK
 	bool
 	default y
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

