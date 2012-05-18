Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965601Ab2ERRM6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 13:12:58 -0400
Received: from www.tglx.de ([62.245.132.106]:59987 "EHLO Tesla.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932879Ab2ERRMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 13:12:51 -0400
Message-Id: <20120518163106.073559820@glx-um.de>
User-Agent: quilt/0.48-1
Date: Fri, 18 May 2012 16:45:50 -0000
From: Anna-Maria Gleixner <anna-maria@glx-um.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ralf Baechle <ralf@linux-mips.org>
Subject: [patch 13/24] mips: Use generic time config
References: <20120518163020.548627576@glx-um.de>
Content-Disposition: inline; filename=mips-use-generic-time-config.patch
X-TGLX-Spam-Score: -1.0
X-TGLX-Spam-Level: -
X-TGLX-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
---
 arch/mips/Kconfig |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

Index: linux/arch/mips/Kconfig
===================================================================
--- linux.orig/arch/mips/Kconfig
+++ linux/arch/mips/Kconfig
@@ -29,6 +29,8 @@ config MIPS
 	select HAVE_MEMBLOCK
 	select HAVE_MEMBLOCK_NODE_MAP
 	select ARCH_DISCARD_MEMBLOCK
+	select GENERIC_CLOCKEVENTS
+	select GENERIC_CMOS_UPDATE
 
 menu "Machine selection"
 
@@ -856,14 +858,6 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
-config GENERIC_CLOCKEVENTS
-	bool
-	default y
-
-config GENERIC_CMOS_UPDATE
-	bool
-	default y
-
 config SCHED_OMIT_FRAME_POINTER
 	bool
 	default y
@@ -2050,9 +2044,6 @@ config CPU_HAS_SYNC
 	depends on !CPU_R3000
 	default y
 
-config GENERIC_CLOCKEVENTS_BROADCAST
-	bool
-
 #
 # CPU non-features
 #


