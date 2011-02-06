Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab1BFWYc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 17:24:32 -0500
Received: from www.tglx.de ([62.245.132.106]:50031 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753295Ab1BFWYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 17:24:15 -0500
Message-Id: <20110206222246.281228273@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 06 Feb 2011 22:23:50 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Subject: [patch 2/2] score: Select GENERIC_HARDIRQS_NO_DEPRECATED
References: <20110206222131.508619512@linutronix.de>
Content-Disposition: inline; filename=score-set-nodepr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All chips converted and proper accessor functions used.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/score/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: linux-next/arch/score/Kconfig
===================================================================
--- linux-next.orig/arch/score/Kconfig
+++ linux-next/arch/score/Kconfig
@@ -3,6 +3,7 @@ menu "Machine selection"
 config SCORE
        def_bool y
        select HAVE_GENERIC_HARDIRQS
+       select GENERIC_HARDIRQS_NO_DEPRECATED
 
 choice
 	prompt "System type"


