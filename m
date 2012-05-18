Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965788Ab2ERRRq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 13:17:46 -0400
Received: from www.tglx.de ([62.245.132.106]:59993 "EHLO Tesla.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965626Ab2ERRNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 13:13:04 -0400
Message-Id: <20120518163107.122560037@glx-um.de>
User-Agent: quilt/0.48-1
Date: Fri, 18 May 2012 16:45:54 -0000
From: Anna-Maria Gleixner <anna-maria@glx-um.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Chris Metcalf <cmetcalf@tilera.com>
Subject: [patch 21/24] tile: Use generic time config
References: <20120518163020.548627576@glx-um.de>
Content-Disposition: inline; filename=tile-use-generic-time-config.patch
X-TGLX-Spam-Score: -1.0
X-TGLX-Spam-Level: -
X-TGLX-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
Cc:  Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/Kconfig |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: linux/arch/tile/Kconfig
===================================================================
--- linux.orig/arch/tile/Kconfig
+++ linux/arch/tile/Kconfig
@@ -13,6 +13,7 @@ config TILE
 	select GENERIC_IRQ_SHOW
 	select SYS_HYPERVISOR
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
+	select GENERIC_CLOCKEVENTS
 
 # FIXME: investigate whether we need/want these options.
 #	select HAVE_IOREMAP_PROT
@@ -46,9 +47,6 @@ config NEED_PER_CPU_PAGE_FIRST_CHUNK
 config SYS_SUPPORTS_HUGETLBFS
 	def_bool y
 
-config GENERIC_CLOCKEVENTS
-	def_bool y
-
 # FIXME: tilegx can implement a more efficient rwsem.
 config RWSEM_GENERIC_SPINLOCK
 	def_bool y


