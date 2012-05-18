Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965869Ab2ERROu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 13:14:50 -0400
Received: from www.tglx.de ([62.245.132.106]:60006 "EHLO Tesla.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965788Ab2ERRN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 13:13:28 -0400
Message-Id: <20120518163106.464567389@glx-um.de>
User-Agent: quilt/0.48-1
Date: Fri, 18 May 2012 16:45:51 -0000
From: Anna-Maria Gleixner <anna-maria@glx-um.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [patch 16/24] powerpc: Use generic time config
References: <20120518163020.548627576@glx-um.de>
Content-Disposition: inline; filename=powerpc-use-generic-time-config.patch
X-TGLX-Spam-Score: -1.0
X-TGLX-Spam-Level: -
X-TGLX-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/powerpc/Kconfig |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

Index: linux/arch/powerpc/Kconfig
===================================================================
--- linux.orig/arch/powerpc/Kconfig
+++ linux/arch/powerpc/Kconfig
@@ -27,15 +27,6 @@ config MMU
 	bool
 	default y
 
-config GENERIC_CMOS_UPDATE
-	def_bool y
-
-config GENERIC_TIME_VSYSCALL
-	def_bool y
-
-config GENERIC_CLOCKEVENTS
-	def_bool y
-
 config HAVE_SETUP_PER_CPU_AREA
 	def_bool PPC64
 
@@ -144,6 +135,9 @@ config PPC
 	select HAVE_BPF_JIT if (PPC64 && NET)
 	select HAVE_ARCH_JUMP_LABEL
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
+	select GENERIC_CMOS_UPDATE
+	select GENERIC_TIME_VSYSCALL
+	select GENERIC_CLOCKEVENTS
 
 config EARLY_PRINTK
 	bool


