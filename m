Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab1CYOQ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 10:16:59 -0400
Received: from www.linutronix.de ([62.245.132.108]:36995 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752830Ab1CYOQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 10:16:56 -0400
Message-Id: <20110325141647.161532233@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 14:16:55 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Subject: [patch 2/4] score: Select GENERIC_HARDIRQS_NO_DEPRECATED
References: <20110325141528.825456671@linutronix.de>
Content-Disposition: inline;
	filename=score-select-generic_hardirqs_no_deprecated.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All chips converted and proper accessor functions used.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/arch/score/Kconfig
===================================================================
--- linux-2.6.orig/arch/score/Kconfig
+++ linux-2.6/arch/score/Kconfig
@@ -3,6 +3,7 @@ menu "Machine selection"
 config SCORE
        def_bool y
        select HAVE_GENERIC_HARDIRQS
+       select GENERIC_HARDIRQS_NO_DEPRECATED
 
 choice
 	prompt "System type"


