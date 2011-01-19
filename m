Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab1ASVuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 16:50:22 -0500
Received: from www.tglx.de ([62.245.132.106]:40769 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754858Ab1ASVuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 16:50:15 -0500
Message-Id: <20110119210840.424269590@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 19 Jan 2011 21:49:58 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Kyle McMartin <kyle@mcmartin.ca>
Subject: [patch 32/37] parisc: Use generic irq Kconfig
References: <20110119205258.462759212@linutronix.de>
Content-Disposition: inline; filename=parisc-use-generic-irq-Kconfig.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Kyle McMartin <kyle@mcmartin.ca>
---
 arch/parisc/Kconfig |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

Index: linux-2.6/arch/parisc/Kconfig
===================================================================
--- linux-2.6.orig/arch/parisc/Kconfig
+++ linux-2.6/arch/parisc/Kconfig
@@ -12,6 +12,10 @@ config PARISC
 	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
 	select GENERIC_ATOMIC64 if !64BIT
+	select HAVE_GENERIC_HARDIRQS
+	select GENERIC_IRQ_PROBE
+	select IRQ_PER_CPU
+
 	help
 	  The PA-RISC microprocessor is designed by Hewlett-Packard and used
 	  in many of their workstations & servers (HP9000 700 and 800 series,
@@ -65,19 +69,9 @@ config TIME_LOW_RES
 	depends on SMP
 	default y
 
-config GENERIC_HARDIRQS
-	def_bool y
-
-config GENERIC_IRQ_PROBE
-	def_bool y
-
 config HAVE_LATENCYTOP_SUPPORT
         def_bool y
 
-config IRQ_PER_CPU
-	bool
-	default y
-
 # unless you want to implement ACPI on PA-RISC ... ;-)
 config PM
 	bool


