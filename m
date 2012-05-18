Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965832Ab2ERRSM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 13:18:12 -0400
Received: from www.tglx.de ([62.245.132.106]:59990 "EHLO Tesla.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965585Ab2ERRM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 13:12:57 -0400
Message-Id: <20120518163104.889514832@glx-um.de>
User-Agent: quilt/0.48-1
Date: Fri, 18 May 2012 16:45:45 -0000
From: Anna-Maria Gleixner <anna-maria@glx-um.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>
Subject: [patch 04/24] avr32: Use generic time config
References: <20120518163020.548627576@glx-um.de>
Content-Disposition: inline; filename=avr32-use-generic-time-config.patch
X-TGLX-Spam-Score: -1.0
X-TGLX-Spam-Level: -
X-TGLX-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
Cc:  Haavard Skinnemoen <hskinnemoen@gmail.com>
---
 arch/avr32/Kconfig |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: linux/arch/avr32/Kconfig
===================================================================
--- linux.orig/arch/avr32/Kconfig
+++ linux/arch/avr32/Kconfig
@@ -12,6 +12,7 @@ config AVR32
 	select HARDIRQS_SW_RESEND
 	select GENERIC_IRQ_SHOW
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
+	select GENERIC_CLOCKEVENTS
 	help
 	  AVR32 is a high-performance 32-bit RISC microprocessor core,
 	  designed for cost-sensitive embedded applications, with particular
@@ -35,9 +36,6 @@ config TRACE_IRQFLAGS_SUPPORT
 config RWSEM_GENERIC_SPINLOCK
 	def_bool y
 
-config GENERIC_CLOCKEVENTS
-	def_bool y
-
 config RWSEM_XCHGADD_ALGORITHM
 	def_bool n
 


