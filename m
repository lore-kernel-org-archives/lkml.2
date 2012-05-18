Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932985Ab2ERRMv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 13:12:51 -0400
Received: from www.tglx.de ([62.245.132.106]:59986 "EHLO Tesla.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932482Ab2ERRMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 13:12:50 -0400
X-Greylist: delayed 1624 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 May 2012 13:12:50 EDT
Message-Id: <20120518163106.857566635@glx-um.de>
User-Agent: quilt/0.48-1
Date: Fri, 18 May 2012 16:45:53 -0000
From: Anna-Maria Gleixner <anna-maria@glx-um.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Paul Mundt <lethal@linux-sh.org>
Subject: [patch 19/24] sh: Use generic time config
References: <20120518163020.548627576@glx-um.de>
Content-Disposition: inline; filename=sh-use-generic-time-config.patch
X-TGLX-Spam-Score: -1.0
X-TGLX-Spam-Level: -
X-TGLX-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/sh/Kconfig |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

Index: linux/arch/sh/Kconfig
===================================================================
--- linux.orig/arch/sh/Kconfig
+++ linux/arch/sh/Kconfig
@@ -28,6 +28,8 @@ config SUPERH
 	select RTC_LIB
 	select GENERIC_ATOMIC64
 	select GENERIC_IRQ_SHOW
+	select GENERIC_CLOCKEVENTS
+	select GENERIC_CMOS_UPDATE if SH_SH03 || SH_DREAMCAST
 	help
 	  The SuperH is a RISC processor targeted for use in embedded systems
 	  and consumer electronics; it was also used in the Sega Dreamcast
@@ -86,16 +88,6 @@ config GENERIC_GPIO
 config GENERIC_CALIBRATE_DELAY
 	bool
 
-config GENERIC_CLOCKEVENTS
-	def_bool y
-
-config GENERIC_CLOCKEVENTS_BROADCAST
-	bool
-
-config GENERIC_CMOS_UPDATE
-	def_bool y
-	depends on SH_SH03 || SH_DREAMCAST
-
 config GENERIC_LOCKBREAK
 	def_bool y
 	depends on SMP && PREEMPT


