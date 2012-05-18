Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965877Ab2ERROd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 13:14:33 -0400
Received: from www.tglx.de ([62.245.132.106]:60007 "EHLO Tesla.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965795Ab2ERRN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 13:13:29 -0400
Message-Id: <20120518163105.286556794@glx-um.de>
User-Agent: quilt/0.48-1
Date: Fri, 18 May 2012 16:45:46 -0000
From: Anna-Maria Gleixner <anna-maria@glx-um.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Subject: [patch 07/24] cris: Use generic time config
References: <20120518163020.548627576@glx-um.de>
Content-Disposition: inline; filename=cris-use-generic-time-config.patch
X-TGLX-Spam-Score: -1.0
X-TGLX-Spam-Level: -
X-TGLX-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/Kconfig |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

Index: linux/arch/cris/Kconfig
===================================================================
--- linux.orig/arch/cris/Kconfig
+++ linux/arch/cris/Kconfig
@@ -13,12 +13,6 @@ config RWSEM_GENERIC_SPINLOCK
 config RWSEM_XCHGADD_ALGORITHM
 	bool
 
-config GENERIC_CMOS_UPDATE
-	def_bool y
-
-config ARCH_USES_GETTIMEOFFSET
-	def_bool n
-
 config ARCH_HAS_ILOG2_U32
 	bool
 	default n
@@ -49,6 +43,7 @@ config CRIS
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
 	select GENERIC_IOMAP
+	select GENERIC_CMOS_UPDATE
 
 config HZ
 	int


