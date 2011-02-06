Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab1BFThN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 14:37:13 -0500
Received: from www.tglx.de ([62.245.132.106]:53782 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753937Ab1BFTgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 14:36:37 -0500
Message-Id: <20110206193617.429982017@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 06 Feb 2011 19:36:33 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Michal Simek <monstr@monstr.eu>
Subject: [patch 3/3] microblaze: Select GENERIC_HARDIRQS_NO_DEPRECATED
References: <20110206193440.279124802@linutronix.de>
Content-Disposition: inline; filename=microblaze-set-nodepr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All irq_chips converted.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/microblaze/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: linux-next/arch/microblaze/Kconfig
===================================================================
--- linux-next.orig/arch/microblaze/Kconfig
+++ linux-next/arch/microblaze/Kconfig
@@ -17,6 +17,7 @@ config MICROBLAZE
 	select OF_EARLY_FLATTREE
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_PROBE
+	select GENERIC_HARDIRQS_NO_DEPRECATED
 
 config SWAP
 	def_bool n


