Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab1GEDco (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 23:32:44 -0400
Received: from ozlabs.org ([203.10.76.45]:35761 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683Ab1GEDcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 23:32:43 -0400
Date: Tue, 5 Jul 2011 13:32:40 +1000
From: Anton Blanchard <anton@samba.org>
To: fweisbec@gmail.com, mingo@elte.hu, a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] lockup detector: CONFIG_DETECT_SOFTLOCKUP no longer exists
Message-ID: <20110705133240.25e81a7a@kryten>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Replace CONFIG_DETECT_SOFTLOCKUP with CONFIG_LOCKUP_DETECTOR.
 
Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux-2.6-work/lib/Kconfig.debug
===================================================================
--- linux-2.6-work.orig/lib/Kconfig.debug	2011-07-05 12:47:23.728166985 +1000
+++ linux-2.6-work/lib/Kconfig.debug	2011-07-05 12:47:40.478462898 +1000
@@ -227,7 +227,7 @@ config BOOTPARAM_SOFTLOCKUP_PANIC_VALUE
 config DETECT_HUNG_TASK
 	bool "Detect Hung Tasks"
 	depends on DEBUG_KERNEL
-	default DETECT_SOFTLOCKUP
+	default LOCKUP_DETECTOR
 	help
 	  Say Y here to enable the kernel to detect "hung tasks",
 	  which are bugs that cause the task to be stuck in
@@ -866,7 +866,7 @@ config BOOT_PRINTK_DELAY
 	  system, and then set "lpj=M" before setting "boot_delay=N".
 	  NOTE:  Using this option may adversely affect SMP systems.
 	  I.e., processors other than the first one may not boot up.
-	  BOOT_PRINTK_DELAY also may cause DETECT_SOFTLOCKUP to detect
+	  BOOT_PRINTK_DELAY also may cause LOCKUP_DETECTOR to detect
 	  what it believes to be lockup conditions.
 
 config RCU_TORTURE_TEST
