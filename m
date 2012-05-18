Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965839Ab2ERROK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 13:14:10 -0400
Received: from www.tglx.de ([62.245.132.106]:60009 "EHLO Tesla.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965616Ab2ERRNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 13:13:35 -0400
Message-Id: <20120518163105.156595383@glx-um.de>
User-Agent: quilt/0.48-1
Date: Fri, 18 May 2012 16:45:46 -0000
From: Anna-Maria Gleixner <anna-maria@glx-um.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Mark Salter <msalter@redhat.com>
Subject: [patch 06/24] c6x: Use generic time config
References: <20120518163020.548627576@glx-um.de>
Content-Disposition: inline; filename=c6x-use-generic-time-config.patch
X-TGLX-Spam-Score: -1.0
X-TGLX-Spam-Level: -
X-TGLX-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
Cc: Mark Salter <msalter@redhat.com>
---
 arch/c6x/Kconfig |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

Index: linux/arch/c6x/Kconfig
===================================================================
--- linux.orig/arch/c6x/Kconfig
+++ linux/arch/c6x/Kconfig
@@ -15,6 +15,7 @@ config TMS320C6X
 	select IRQ_DOMAIN
 	select OF
 	select OF_EARLY_FLATTREE
+	select GENERIC_CLOCKEVENTS
 
 config MMU
 	def_bool n
@@ -43,12 +44,6 @@ config GENERIC_CALIBRATE_DELAY
 config GENERIC_HWEIGHT
 	def_bool y
 
-config GENERIC_CLOCKEVENTS
-	def_bool y
-
-config GENERIC_CLOCKEVENTS_BROADCAST
-	bool
-
 config GENERIC_BUG
 	def_bool y
 


