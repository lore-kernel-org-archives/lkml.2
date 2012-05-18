Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965542Ab2ERRMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 13:12:55 -0400
Received: from www.tglx.de ([62.245.132.106]:59988 "EHLO Tesla.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758034Ab2ERRMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 13:12:52 -0400
Message-Id: <20120518163105.808606368@glx-um.de>
User-Agent: quilt/0.48-1
Date: Fri, 18 May 2012 16:45:49 -0000
From: Anna-Maria Gleixner <anna-maria@glx-um.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [patch 11/24] m68k: Use generic time config
References: <20120518163020.548627576@glx-um.de>
Content-Disposition: inline; filename=m68k-use-generic-time-config.patch
X-TGLX-Spam-Score: -1.0
X-TGLX-Spam-Level: -
X-TGLX-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/Kconfig |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

Index: linux/arch/m68k/Kconfig
===================================================================
--- linux.orig/arch/m68k/Kconfig
+++ linux/arch/m68k/Kconfig
@@ -8,6 +8,7 @@ config M68K
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG if RMW_INSNS
 	select GENERIC_CPU_DEVICES
 	select FPU if MMU
+	select ARCH_USES_GETTIMEOFFSET if MMU && !COLDFIRE
 
 config RWSEM_GENERIC_SPINLOCK
 	bool
@@ -22,9 +23,6 @@ config ARCH_HAS_ILOG2_U32
 config ARCH_HAS_ILOG2_U64
 	bool
 
-config GENERIC_CLOCKEVENTS
-	bool
-
 config GENERIC_GPIO
 	bool
 
@@ -43,9 +41,6 @@ config TIME_LOW_RES
 	bool
 	default y
 
-config ARCH_USES_GETTIMEOFFSET
-	def_bool MMU && !COLDFIRE
-
 config NO_IOPORT
 	def_bool y
 


