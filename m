Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab1BFWpr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 17:45:47 -0500
Received: from www.tglx.de ([62.245.132.106]:59975 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754119Ab1BFWpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 17:45:44 -0500
Message-Id: <20110206224515.430825903@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 06 Feb 2011 22:45:38 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jeff Dike <jdike@addtoit.com>
Subject: [patch 4/4] um: Select GENERIC_HARDIRQS_NO_DEPRECATED
References: <20110206224358.096841291@linutronix.de>
Content-Disposition: inline; filename=um-set-nodepr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq chips converted and proper accessor functions used.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/um/Kconfig.common |    1 +
 1 file changed, 1 insertion(+)

Index: linux-next/arch/um/Kconfig.common
===================================================================
--- linux-next.orig/arch/um/Kconfig.common
+++ linux-next/arch/um/Kconfig.common
@@ -7,6 +7,7 @@ config UML
 	bool
 	default y
 	select HAVE_GENERIC_HARDIRQS
+	select GENERIC_HARDIRQS_NO_DEPRECATED
 
 config MMU
 	bool


