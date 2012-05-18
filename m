Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933043Ab2ERRPq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 13:15:46 -0400
Received: from www.tglx.de ([62.245.132.106]:60003 "EHLO Tesla.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965742Ab2ERRNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 13:13:22 -0400
Message-Id: <20120518163105.939597527@glx-um.de>
User-Agent: quilt/0.48-1
Date: Fri, 18 May 2012 16:45:49 -0000
From: Anna-Maria Gleixner <anna-maria@glx-um.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Michal Simek <monstr@monstr.eu>
Subject: [patch 12/24] microblaze: Use generic time config
References: <20120518163020.548627576@glx-um.de>
Content-Disposition: inline; filename=microblaze-use-generic-time-config.patch
X-TGLX-Spam-Score: -1.0
X-TGLX-Spam-Level: -
X-TGLX-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
Cc: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/Kconfig |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

Index: linux/arch/microblaze/Kconfig
===================================================================
--- linux.orig/arch/microblaze/Kconfig
+++ linux/arch/microblaze/Kconfig
@@ -22,6 +22,7 @@ config MICROBLAZE
 	select GENERIC_PCI_IOMAP
 	select GENERIC_CPU_DEVICES
 	select GENERIC_ATOMIC64
+	select GENERIC_CLOCKEVENTS
 
 config SWAP
 	def_bool n
@@ -50,12 +51,6 @@ config GENERIC_HWEIGHT
 config GENERIC_CALIBRATE_DELAY
 	def_bool y
 
-config GENERIC_TIME_VSYSCALL
-	def_bool n
-
-config GENERIC_CLOCKEVENTS
-	def_bool y
-
 config GENERIC_GPIO
 	def_bool y
 


