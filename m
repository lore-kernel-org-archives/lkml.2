Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab1AGIoX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 03:44:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753797Ab1AGIoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 03:44:22 -0500
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: WANG Cong <amwang@redhat.com>, Michal Simek <monstr@monstr.eu>,
        Sam Ravnborg <sam@ravnborg.org>, microblaze-uclinux@itee.uq.edu.au
Subject: [Patch] microblaze: remove obsolete DEBUG_BOOTMEM
Date: Fri,  7 Jan 2011 16:43:54 +0800
Message-Id: <1294389835-18282-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"git grep" shows this is the last piece of code using DEBUG_BOOTMEM,
so remove it.

Signed-off-by: WANG Cong <amwang@redhat.com>

---
diff --git a/arch/microblaze/Kconfig.debug b/arch/microblaze/Kconfig.debug
index e66e25c..012e377 100644
--- a/arch/microblaze/Kconfig.debug
+++ b/arch/microblaze/Kconfig.debug
@@ -23,8 +23,4 @@ config HEART_BEAT
 	  This option turns on/off heart beat kernel functionality.
 	  First GPIO node is taken.
 
-config DEBUG_BOOTMEM
-	depends on DEBUG_KERNEL
-	bool "Debug BOOTMEM initialization"
-
 endmenu
diff --git a/arch/microblaze/configs/mmu_defconfig b/arch/microblaze/configs/mmu_defconfig
index 8b422b1..ab8fbe7 100644
--- a/arch/microblaze/configs/mmu_defconfig
+++ b/arch/microblaze/configs/mmu_defconfig
@@ -66,5 +66,4 @@ CONFIG_DEBUG_SPINLOCK=y
 CONFIG_DEBUG_INFO=y
 # CONFIG_RCU_CPU_STALL_DETECTOR is not set
 CONFIG_EARLY_PRINTK=y
-CONFIG_DEBUG_BOOTMEM=y
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
