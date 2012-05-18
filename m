Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933016Ab2ERRPJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 13:15:09 -0400
Received: from www.tglx.de ([62.245.132.106]:60005 "EHLO Tesla.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965768Ab2ERRN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 13:13:26 -0400
Message-Id: <20120518163106.727602709@glx-um.de>
User-Agent: quilt/0.48-1
Date: Fri, 18 May 2012 16:45:52 -0000
From: Anna-Maria Gleixner <anna-maria@glx-um.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Chen Liqin <liqin.chen@sunplusct.com>
Subject: [patch 18/24] score: Use generic time config
References: <20120518163020.548627576@glx-um.de>
Content-Disposition: inline; filename=score-use-generic-time-config.patch
X-TGLX-Spam-Score: -1.0
X-TGLX-Spam-Level: -
X-TGLX-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/Kconfig |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: linux/arch/score/Kconfig
===================================================================
--- linux.orig/arch/score/Kconfig
+++ linux/arch/score/Kconfig
@@ -9,6 +9,7 @@ config SCORE
        select HAVE_MEMBLOCK_NODE_MAP
        select ARCH_DISCARD_MEMBLOCK
        select GENERIC_CPU_DEVICES
+       select GENERIC_CLOCKEVENTS
 
 choice
 	prompt "System type"
@@ -51,9 +52,6 @@ config GENERIC_HWEIGHT
 config GENERIC_CALIBRATE_DELAY
 	def_bool y
 
-config GENERIC_CLOCKEVENTS
-	def_bool y
-
 menu "Kernel type"
 
 config 32BIT


