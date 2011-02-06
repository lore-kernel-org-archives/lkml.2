Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab1BFXEy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:04:54 -0500
Received: from www.tglx.de ([62.245.132.106]:47667 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754201Ab1BFXEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:04:53 -0500
Message-Id: <20110206230415.770450568@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 06 Feb 2011 23:04:44 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Subject: [patch 3/3] tile: Select GENERIC_HARDIRQS_NO_DEPRECATED
References: <20110206230305.461141290@linutronix.de>
Content-Disposition: inline; filename=tile-set-nodepr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq chip converted and proper accessor functions used.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/tile/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: linux-next/arch/tile/Kconfig
===================================================================
--- linux-next.orig/arch/tile/Kconfig
+++ linux-next/arch/tile/Kconfig
@@ -11,6 +11,7 @@ config TILE
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
+	select GENERIC_HARDIRQS_NO_DEPRECATED
 
 # FIXME: investigate whether we need/want these options.
 #	select HAVE_IOREMAP_PROT


