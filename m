Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965858Ab2ERRNi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 13:13:38 -0400
Received: from www.tglx.de ([62.245.132.106]:60008 "EHLO Tesla.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965823Ab2ERRNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 13:13:33 -0400
Message-Id: <20120518163105.678581749@glx-um.de>
User-Agent: quilt/0.48-1
Date: Fri, 18 May 2012 16:45:48 -0000
From: Anna-Maria Gleixner <anna-maria@glx-um.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Hirokazu Takata <takata@linux-m32r.org>
Subject: [patch 10/24] m32r: Use generic time config
References: <20120518163020.548627576@glx-um.de>
Content-Disposition: inline; filename=m32r-use-generic-time-config.patch
X-TGLX-Spam-Score: -1.0
X-TGLX-Spam-Level: -
X-TGLX-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
Cc: Hirokazu Takata <takata@linux-m32r.org>
---
 arch/m32r/Kconfig |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: linux/arch/m32r/Kconfig
===================================================================
--- linux.orig/arch/m32r/Kconfig
+++ linux/arch/m32r/Kconfig
@@ -11,6 +11,7 @@ config M32R
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
 	select GENERIC_ATOMIC64
+	select ARCH_USES_GETTIMEOFFSET
 
 config SBUS
 	bool
@@ -33,9 +34,6 @@ config HZ
 	int
 	default 100
 
-config ARCH_USES_GETTIMEOFFSET
-	def_bool y
-
 source "init/Kconfig"
 
 source "kernel/Kconfig.freezer"


