Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab1BFTWT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 14:22:19 -0500
Received: from www.tglx.de ([62.245.132.106]:45169 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913Ab1BFTWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 14:22:16 -0500
Message-Id: <20110206192106.601290592@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 06 Feb 2011 19:22:01 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>
Subject: [patch 7/7] frv: Select GENERIC_HARDIRQS_NO_DEPRECATED
References: <20110206192032.393682621@linutronix.de>
Content-Disposition: inline; filename=frv-set-nodepr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All chips converted

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/frv/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: linux-next/arch/frv/Kconfig
===================================================================
--- linux-next.orig/arch/frv/Kconfig
+++ linux-next/arch/frv/Kconfig
@@ -6,6 +6,7 @@ config FRV
 	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
 	select HAVE_GENERIC_HARDIRQS
+	select GENERIC_HARDIRQS_NO_DEPRECATED
 
 config ZONE_DMA
 	bool


