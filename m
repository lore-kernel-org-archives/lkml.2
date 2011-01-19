Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab1ASVu1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 16:50:27 -0500
Received: from www.tglx.de ([62.245.132.106]:40794 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754858Ab1ASVuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 16:50:23 -0500
Message-Id: <20110119210840.524713980@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 19 Jan 2011 21:50:05 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Chen Liqin <liqin.chen@sunplusct.com>
Subject: [patch 34/37] score: Use generic irq Kconfig
References: <20110119205258.462759212@linutronix.de>
Content-Disposition: inline; filename=score-use-generic-irq-Kconfig.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional change

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/Kconfig |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/score/Kconfig
===================================================================
--- linux-2.6.orig/arch/score/Kconfig
+++ linux-2.6/arch/score/Kconfig
@@ -1,5 +1,9 @@
 menu "Machine selection"
 
+config SCORE
+       def_bool y
+       select HAVE_GENERIC_HARDIRQS
+
 choice
 	prompt "System type"
 	default MACH_SPCT6600
@@ -65,9 +69,6 @@ menu "Kernel type"
 config 32BIT
 	def_bool y
 
-config GENERIC_HARDIRQS
-	def_bool y
-
 config ARCH_FLATMEM_ENABLE
 	def_bool y
 


