Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965703Ab2ERRTO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 13:19:14 -0400
Received: from www.tglx.de ([62.245.132.106]:59989 "EHLO Tesla.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932482Ab2ERRMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 13:12:54 -0400
Message-Id: <20120518163107.510619939@glx-um.de>
User-Agent: quilt/0.48-1
Date: Fri, 18 May 2012 16:45:56 -0000
From: Anna-Maria Gleixner <anna-maria@glx-um.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Matt Turner <mattst88@gmail.com>
Subject: [patch 24/24] alpha: Use generic time config
References: <20120518163020.548627576@glx-um.de>
Content-Disposition: inline; filename=alpha-use-generic-time-config.patch
X-TGLX-Spam-Score: -1.0
X-TGLX-Spam-Level: -
X-TGLX-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
Cc: Matt Turner <mattst88@gmail.com>
---
 arch/alpha/Kconfig |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: linux/arch/alpha/Kconfig
===================================================================
--- linux.orig/arch/alpha/Kconfig
+++ linux/arch/alpha/Kconfig
@@ -15,6 +15,7 @@ config ALPHA
 	select GENERIC_IRQ_SHOW
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
+	select GENERIC_CMOS_UPDATE
 	help
 	  The Alpha is a 64-bit general-purpose processor designed and
 	  marketed by the Digital Equipment Corporation of blessed memory,
@@ -47,9 +48,6 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
-config GENERIC_CMOS_UPDATE
-        def_bool y
-
 config GENERIC_GPIO
 	bool
 


