Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab1BFVMh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 16:12:37 -0500
Received: from www.tglx.de ([62.245.132.106]:54829 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754094Ab1BFVM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 16:12:27 -0500
Message-Id: <20110206211137.849317253@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 06 Feb 2011 21:12:24 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Chris Zankel <chris@zankel.net>
Subject: [patch 3/3] xtensa: Use generic IRQ Kconfig and set
	GENERIC_HARDIRQS_NO_DEPRECATED
References: <20110206211051.865188529@linutronix.de>
Content-Disposition: inline; filename=xtensa-set-nodepr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All chips converted.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/xtensa/Kconfig |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: linux-next/arch/xtensa/Kconfig
===================================================================
--- linux-next.orig/arch/xtensa/Kconfig
+++ linux-next/arch/xtensa/Kconfig
@@ -7,6 +7,8 @@ config ZONE_DMA
 config XTENSA
 	def_bool y
 	select HAVE_IDE
+	select HAVE_GENERIC_HARDIRQS
+	select GENERIC_HARDIRQS_NO_DEPRECATED
 	help
 	  Xtensa processors are 32-bit RISC machines designed by Tensilica
 	  primarily for embedded systems.  These processors are both
@@ -24,9 +26,6 @@ config GENERIC_FIND_NEXT_BIT
 config GENERIC_HWEIGHT
 	def_bool y
 
-config GENERIC_HARDIRQS
-	def_bool y
-
 config GENERIC_GPIO
 	def_bool y
 


