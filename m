Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab1BFXjq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:39:46 -0500
Received: from www.tglx.de ([62.245.132.106]:40383 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754397Ab1BFXjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:39:40 -0500
Message-Id: <20110206233905.071519671@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 06 Feb 2011 23:39:35 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg Ungerer <gerg@uclinux.org>
Subject: [patch 10/10] m68knommu: Select GENERIC_HARDIRQS_NO_DEPRECATED
References: <20110206233845.480884215@linutronix.de>
Content-Disposition: inline; filename=m68k-set-nodepr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All chips converted and proper accessor functions used.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/m68knommu/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: linux-next/arch/m68knommu/Kconfig
===================================================================
--- linux-next.orig/arch/m68knommu/Kconfig
+++ linux-next/arch/m68knommu/Kconfig
@@ -3,6 +3,7 @@ config M68K
 	default y
 	select HAVE_IDE
 	select HAVE_GENERIC_HARDIRQS
+	select GENERIC_HARDIRQS_NO_DEPRECATED
 
 config MMU
 	bool


