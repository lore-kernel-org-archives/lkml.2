Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965785Ab2ERRN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 13:13:27 -0400
Received: from www.tglx.de ([62.245.132.106]:60000 "EHLO Tesla.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965704Ab2ERRNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 13:13:16 -0400
Message-Id: <20120518163106.201635926@glx-um.de>
User-Agent: quilt/0.48-1
Date: Fri, 18 May 2012 16:45:50 -0000
From: Anna-Maria Gleixner <anna-maria@glx-um.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, David Howells <dhowells@redhat.com>
Subject: [patch 14/24] mn10300: Use generic time config
References: <20120518163020.548627576@glx-um.de>
Content-Disposition: inline; filename=mn10300-use-generic-time-config.patch
X-TGLX-Spam-Score: -1.0
X-TGLX-Spam-Level: -
X-TGLX-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
Cc: David Howells <dhowells@redhat.com>
---
 arch/mn10300/Kconfig |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

Index: linux/arch/mn10300/Kconfig
===================================================================
--- linux.orig/arch/mn10300/Kconfig
+++ linux/arch/mn10300/Kconfig
@@ -6,6 +6,7 @@ config MN10300
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_ARCH_KGDB
 	select HAVE_NMI_WATCHDOG if MN10300_WD_TIMER
+	select GENERIC_CLOCKEVENTS
 
 config AM33_2
 	def_bool n
@@ -42,15 +43,9 @@ config RWSEM_XCHGADD_ALGORITHM
 config GENERIC_CALIBRATE_DELAY
 	def_bool y
 
-config GENERIC_CMOS_UPDATE
-        def_bool n
-
 config GENERIC_HWEIGHT
 	def_bool y
 
-config GENERIC_CLOCKEVENTS
-	def_bool y
-
 config GENERIC_BUG
 	def_bool y
 


