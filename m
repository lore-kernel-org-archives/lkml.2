Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965651Ab2ERRNF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 13:13:05 -0400
Received: from www.tglx.de ([62.245.132.106]:59991 "EHLO Tesla.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965605Ab2ERRM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 13:12:59 -0400
Message-Id: <20120518163105.416570309@glx-um.de>
User-Agent: quilt/0.48-1
Date: Fri, 18 May 2012 16:45:47 -0000
From: Anna-Maria Gleixner <anna-maria@glx-um.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Richard Kuo <rkuo@codeaurora.org>
Subject: [patch 08/24] hexagon: Use generic time config
References: <20120518163020.548627576@glx-um.de>
Content-Disposition: inline; filename=hexagon-use-generic-time-config.patch
X-TGLX-Spam-Score: -1.0
X-TGLX-Spam-Level: -
X-TGLX-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

config GENERIC_TIME not longer used.

Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
Cc: Richard Kuo <rkuo@codeaurora.org>
---
 arch/hexagon/Kconfig |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

Index: linux/arch/hexagon/Kconfig
===================================================================
--- linux.orig/arch/hexagon/Kconfig
+++ linux/arch/hexagon/Kconfig
@@ -28,6 +28,9 @@ config HEXAGON
 	select NO_IOPORT
 	select GENERIC_IOMAP
 	# mostly generic routines, with some accelerated ones
+	select KTIME_SCALAR
+	select GENERIC_CLOCKEVENTS
+	select GENERIC_CLOCKEVENTS_BROADCAST
 	---help---
 	  Qualcomm Hexagon is a processor architecture designed for high
 	  performance and low power across a wide variety of applications.
@@ -56,9 +59,6 @@ config PCI
 config EARLY_PRINTK
 	def_bool y
 
-config KTIME_SCALAR
-	def_bool y
-
 config MMU
 	def_bool y
 
@@ -98,15 +98,6 @@ config GENERIC_FIND_NEXT_BIT
 config GENERIC_HWEIGHT
 	def_bool y
 
-config GENERIC_TIME
-	def_bool y
-
-config GENERIC_CLOCKEVENTS
-	def_bool y
-
-config GENERIC_CLOCKEVENTS_BROADCAST
-	def_bool y
-
 config STACKTRACE_SUPPORT
 	def_bool y
 	select STACKTRACE


