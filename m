Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933103Ab2ERRQE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 13:16:04 -0400
Received: from www.tglx.de ([62.245.132.106]:60002 "EHLO Tesla.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965650Ab2ERRNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 13:13:20 -0400
Message-Id: <20120518163106.333611712@glx-um.de>
User-Agent: quilt/0.48-1
Date: Fri, 18 May 2012 16:45:51 -0000
From: Anna-Maria Gleixner <anna-maria@glx-um.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jonas Bonn <jonas@southpole.se>
Subject: [patch 15/24] openrisc: Use generic time config
References: <20120518163020.548627576@glx-um.de>
Content-Disposition: inline; filename=openrisc-use-generic-time-config.patch
X-TGLX-Spam-Score: -1.0
X-TGLX-Spam-Level: -
X-TGLX-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
Cc: Jonas Bonn <jonas@southpole.se>
---
 arch/openrisc/Kconfig |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: linux/arch/openrisc/Kconfig
===================================================================
--- linux.orig/arch/openrisc/Kconfig
+++ linux/arch/openrisc/Kconfig
@@ -17,6 +17,7 @@ config OPENRISC
 	select GENERIC_IOMAP
 	select GENERIC_CPU_DEVICES
 	select GENERIC_ATOMIC64
+	select GENERIC_CLOCKEVENTS
 
 config MMU
 	def_bool y
@@ -46,9 +47,6 @@ config NO_IOPORT
 config GENERIC_GPIO
 	def_bool y
 
-config GENERIC_CLOCKEVENTS
-	def_bool y
-
 config TRACE_IRQFLAGS_SUPPORT
         def_bool y
 


