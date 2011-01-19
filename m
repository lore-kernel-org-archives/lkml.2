Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab1ASVuO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 16:50:14 -0500
Received: from www.tglx.de ([62.245.132.106]:40752 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754734Ab1ASVuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 16:50:12 -0500
Message-Id: <20110119210840.290576295@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 19 Jan 2011 21:49:48 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Greg Ungerer <gerg@uclinux.org>
Subject: [patch 29/37] m68knommu: Use generic irq Kconfig
References: <20110119205258.462759212@linutronix.de>
Content-Disposition: inline; filename=m68knommu-use-generic-irq-Kconfig.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Greg Ungerer <gerg@uclinux.org>
---
 arch/m68knommu/Kconfig |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

Index: linux-2.6/arch/m68knommu/Kconfig
===================================================================
--- linux-2.6.orig/arch/m68knommu/Kconfig
+++ linux-2.6/arch/m68knommu/Kconfig
@@ -2,6 +2,7 @@ config M68K
 	bool
 	default y
 	select HAVE_IDE
+	select HAVE_GENERIC_HARDIRQS
 
 config MMU
 	bool
@@ -48,10 +49,6 @@ config GENERIC_HWEIGHT
 	bool
 	default y
 
-config GENERIC_HARDIRQS
-	bool
-	default y
-
 config GENERIC_CALIBRATE_DELAY
 	bool
 	default y


