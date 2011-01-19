Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab1ASVt4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 16:49:56 -0500
Received: from www.tglx.de ([62.245.132.106]:33515 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754697Ab1ASVtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 16:49:53 -0500
Message-Id: <20110119210840.141667585@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 19 Jan 2011 21:49:38 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Mike Frysinger <vapier@gentoo.org>
Subject: [patch 26/37] blackfin: Use generic irq Kconfig
References: <20110119205258.462759212@linutronix.de>
Content-Disposition: inline; filename=blackfin-use-generic-irq-Kconfig.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/Kconfig |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

Index: linux-2.6/arch/blackfin/Kconfig
===================================================================
--- linux-2.6.orig/arch/blackfin/Kconfig
+++ linux-2.6/arch/blackfin/Kconfig
@@ -30,6 +30,9 @@ config BLACKFIN
 	select HAVE_KERNEL_LZO if RAMKERNEL
 	select HAVE_OPROFILE
 	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select HAVE_GENERIC_HARDIRQS
+	select GENERIC_IRQ_PROBE
+	select IRQ_PER_CPU if SMP
 
 config GENERIC_CSUM
 	def_bool y
@@ -44,12 +47,6 @@ config ZONE_DMA
 config GENERIC_FIND_NEXT_BIT
 	def_bool y
 
-config GENERIC_HARDIRQS
-	def_bool y
-
-config GENERIC_IRQ_PROBE
-	def_bool y
-
 config GENERIC_GPIO
 	def_bool y
 
@@ -251,11 +248,6 @@ config HOTPLUG_CPU
 	depends on SMP && HOTPLUG
 	default y
 
-config IRQ_PER_CPU
-	bool
-	depends on SMP
-	default y
-
 config HAVE_LEGACY_PER_CPU_AREA
 	def_bool y
 	depends on SMP


