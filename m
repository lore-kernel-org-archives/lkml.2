Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab1ASVuf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 16:50:35 -0500
Received: from www.tglx.de ([62.245.132.106]:40804 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753895Ab1ASVuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 16:50:32 -0500
Message-Id: <20110119210840.679834263@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 19 Jan 2011 21:50:16 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Jeff Dike <jdike@addtoit.com>
Subject: [patch 37/37] um: Use generic irq Kconfig
References: <20110119205258.462759212@linutronix.de>
Content-Disposition: inline; filename=um--use-generic-irq-Kconfig.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Dike <jdike@addtoit.com>
---
 arch/um/Kconfig.common |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

Index: linux-2.6/arch/um/Kconfig.common
===================================================================
--- linux-2.6.orig/arch/um/Kconfig.common
+++ linux-2.6/arch/um/Kconfig.common
@@ -3,14 +3,10 @@ config DEFCONFIG_LIST
 	option defconfig_list
 	default "arch/$ARCH/defconfig"
 
-# UML uses the generic IRQ subsystem
-config GENERIC_HARDIRQS
-	bool
-	default y
-
 config UML
 	bool
 	default y
+	select HAVE_GENERIC_HARDIRQS
 
 config MMU
 	bool


