Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab1ASVuA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 16:50:00 -0500
Received: from www.tglx.de ([62.245.132.106]:33526 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754734Ab1ASVtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 16:49:55 -0500
Message-Id: <20110119210840.085330728@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 19 Jan 2011 21:49:34 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Richard Henderson <rth@twiddle.net>
Subject: [patch 25/37] alpha: Use generic irq Kconfig
References: <20110119205258.462759212@linutronix.de>
Content-Disposition: inline; filename=alpha-use-generic-irq-Kconfig.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Richard Henderson <rth@twiddle.net>
---
 arch/alpha/Kconfig |   16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

Index: linux-2.6/arch/alpha/Kconfig
===================================================================
--- linux-2.6.orig/arch/alpha/Kconfig
+++ linux-2.6/arch/alpha/Kconfig
@@ -8,6 +8,9 @@ config ALPHA
 	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
 	select HAVE_DMA_ATTRS
+	select HAVE_GENERIC_HARDIRQS
+	select GENERIC_IRQ_PROBE
+	select AUTO_IRQ_AFFINITY if SMP
 	help
 	  The Alpha is a 64-bit general-purpose processor designed and
 	  marketed by the Digital Equipment Corporation of blessed memory,
@@ -68,19 +71,6 @@ config GENERIC_IOMAP
 	bool
 	default n
 
-config GENERIC_HARDIRQS
-	bool
-	default y
-
-config GENERIC_IRQ_PROBE
-	bool
-	default y
-
-config AUTO_IRQ_AFFINITY
-	bool
-	depends on SMP
-	default y
-
 source "init/Kconfig"
 source "kernel/Kconfig.freezer"
 


