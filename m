Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933139Ab2ERRQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 13:16:50 -0400
Received: from www.tglx.de ([62.245.132.106]:59999 "EHLO Tesla.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965692Ab2ERRNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 13:13:14 -0400
Message-Id: <20120518163107.251597655@glx-um.de>
User-Agent: quilt/0.48-1
Date: Fri, 18 May 2012 16:45:55 -0000
From: Anna-Maria Gleixner <anna-maria@glx-um.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Richard Weinberger <richard@nod.at>
Subject: [patch 22/24] um: Use generic time config
References: <20120518163020.548627576@glx-um.de>
Content-Disposition: inline; filename=um-use-generic-time-config.patch
X-TGLX-Spam-Score: -1.0
X-TGLX-Spam-Level: -
X-TGLX-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
Cc: Richard Weinberger <richard@nod.at>
---
 arch/um/Kconfig.common |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

Index: linux/arch/um/Kconfig.common
===================================================================
--- linux.orig/arch/um/Kconfig.common
+++ linux/arch/um/Kconfig.common
@@ -10,6 +10,7 @@ config UML
 	select GENERIC_IRQ_SHOW
 	select GENERIC_CPU_DEVICES
 	select GENERIC_IO
+	select GENERIC_CLOCKEVENTS
 
 config MMU
 	bool
@@ -52,10 +53,6 @@ config GENERIC_BUG
 	default y
 	depends on BUG
 
-config GENERIC_CLOCKEVENTS
-	bool
-	default y
-
 # Used in kernel/irq/manage.c and include/linux/irq.h
 config IRQ_RELEASE_METHOD
 	bool


