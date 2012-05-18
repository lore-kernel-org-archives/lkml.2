Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965818Ab2ERRNc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 13:13:32 -0400
Received: from www.tglx.de ([62.245.132.106]:60004 "EHLO Tesla.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965680Ab2ERRNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 13:13:24 -0400
Message-Id: <20120518163107.383567224@glx-um.de>
User-Agent: quilt/0.48-1
Date: Fri, 18 May 2012 16:45:55 -0000
From: Anna-Maria Gleixner <anna-maria@glx-um.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: [patch 23/24] unicore32: Use generic time config
References: <20120518163020.548627576@glx-um.de>
Content-Disposition: inline; filename=unicore32-use-generic-time-config.patch
X-TGLX-Spam-Score: -1.0
X-TGLX-Spam-Level: -
X-TGLX-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 arch/unicore32/Kconfig |    3 ---
 1 file changed, 3 deletions(-)

Index: linux/arch/unicore32/Kconfig
===================================================================
--- linux.orig/arch/unicore32/Kconfig
+++ linux/arch/unicore32/Kconfig
@@ -25,9 +25,6 @@ config HAVE_PWM
 config GENERIC_GPIO
 	def_bool y
 
-config GENERIC_CLOCKEVENTS
-	bool
-
 config GENERIC_CSUM
 	def_bool y
 


