Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965687Ab2ERRNM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 13:13:12 -0400
Received: from www.tglx.de ([62.245.132.106]:59994 "EHLO Tesla.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965650Ab2ERRNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 13:13:06 -0400
Message-Id: <20120518163105.547603093@glx-um.de>
User-Agent: quilt/0.48-1
Date: Fri, 18 May 2012 16:45:48 -0000
From: Anna-Maria Gleixner <anna-maria@glx-um.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>
Subject: [patch 09/24] ia64: Use generic time config
References: <20120518163020.548627576@glx-um.de>
Content-Disposition: inline; filename=ia64-use-generic-time-config-.patch
X-TGLX-Spam-Score: -1.0
X-TGLX-Spam-Level: -
X-TGLX-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
Cc: Tony Luck <tony.luck@intel.com>
---
 arch/ia64/Kconfig |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

Index: linux/arch/ia64/Kconfig
===================================================================
--- linux.orig/arch/ia64/Kconfig
+++ linux/arch/ia64/Kconfig
@@ -33,6 +33,8 @@ config IA64
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_IOMAP
+	select ARCH_CLOCKSOURCE_DATA
+	select GENERIC_TIME_VSYSCALL
 	default y
 	help
 	  The Itanium Processor Family is Intel's 64-bit successor to
@@ -88,10 +90,6 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
-config GENERIC_TIME_VSYSCALL
-	bool
-	default y
-
 config HAVE_SETUP_PER_CPU_AREA
 	def_bool y
 
@@ -106,9 +104,6 @@ config EFI
 	bool
 	default y
 
-config ARCH_CLOCKSOURCE_DATA
-	def_bool y
-
 config SCHED_OMIT_FRAME_POINTER
 	bool
 	default y


