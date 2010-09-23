Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab0IWGvh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 02:51:37 -0400
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:44286 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753844Ab0IWGvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 02:51:35 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg Ungerer <gerg@uclinux.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Tim Abbott <tabbott@ksplice.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 08/20] m68knommu: change to new flag variables
Date: Wed, 22 Sep 2010 23:50:45 -0700
Message-Id: <1285224645-29728-1-git-send-email-mfm@muteddisk.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace EXTRA_CFLAGS with ccflags-y and EXTRA_AFLAGS with asflags-y.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 arch/m68knommu/platform/5206/Makefile     |    4 ++--
 arch/m68knommu/platform/5206e/Makefile    |    4 ++--
 arch/m68knommu/platform/520x/Makefile     |    4 ++--
 arch/m68knommu/platform/523x/Makefile     |    4 ++--
 arch/m68knommu/platform/5249/Makefile     |    4 ++--
 arch/m68knommu/platform/5272/Makefile     |    4 ++--
 arch/m68knommu/platform/527x/Makefile     |    4 ++--
 arch/m68knommu/platform/528x/Makefile     |    4 ++--
 arch/m68knommu/platform/5307/Makefile     |    4 ++--
 arch/m68knommu/platform/532x/Makefile     |    4 ++--
 arch/m68knommu/platform/5407/Makefile     |    4 ++--
 arch/m68knommu/platform/coldfire/Makefile |    4 ++--
 12 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/arch/m68knommu/platform/5206/Makefile b/arch/m68knommu/platform/5206/Makefile
index 113c333..b5db056 100644
--- a/arch/m68knommu/platform/5206/Makefile
+++ b/arch/m68knommu/platform/5206/Makefile
@@ -8,8 +8,8 @@
 # on the console port whenever a DBG interrupt occurs.  You have to
 # set up you HW breakpoints to trigger a DBG interrupt:
 #
-# EXTRA_CFLAGS += -DTRAP_DBG_INTERRUPT
-# EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
+# ccflags-y := -DTRAP_DBG_INTERRUPT
+# asflags-y := -DTRAP_DBG_INTERRUPT
 #
 
 asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
diff --git a/arch/m68knommu/platform/5206e/Makefile b/arch/m68knommu/platform/5206e/Makefile
index 113c333..b5db056 100644
--- a/arch/m68knommu/platform/5206e/Makefile
+++ b/arch/m68knommu/platform/5206e/Makefile
@@ -8,8 +8,8 @@
 # on the console port whenever a DBG interrupt occurs.  You have to
 # set up you HW breakpoints to trigger a DBG interrupt:
 #
-# EXTRA_CFLAGS += -DTRAP_DBG_INTERRUPT
-# EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
+# ccflags-y := -DTRAP_DBG_INTERRUPT
+# asflags-y := -DTRAP_DBG_INTERRUPT
 #
 
 asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
diff --git a/arch/m68knommu/platform/520x/Makefile b/arch/m68knommu/platform/520x/Makefile
index 435ab34..ad3f4e5 100644
--- a/arch/m68knommu/platform/520x/Makefile
+++ b/arch/m68knommu/platform/520x/Makefile
@@ -8,8 +8,8 @@
 # on the console port whenever a DBG interrupt occurs.  You have to
 # set up you HW breakpoints to trigger a DBG interrupt:
 #
-# EXTRA_CFLAGS += -DTRAP_DBG_INTERRUPT
-# EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
+# ccflags-y := -DTRAP_DBG_INTERRUPT
+# asflags-y := -DTRAP_DBG_INTERRUPT
 #
 
 asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
diff --git a/arch/m68knommu/platform/523x/Makefile b/arch/m68knommu/platform/523x/Makefile
index b8f9b45..c04b8f7 100644
--- a/arch/m68knommu/platform/523x/Makefile
+++ b/arch/m68knommu/platform/523x/Makefile
@@ -8,8 +8,8 @@
 # on the console port whenever a DBG interrupt occurs.  You have to
 # set up you HW breakpoints to trigger a DBG interrupt:
 #
-# EXTRA_CFLAGS += -DTRAP_DBG_INTERRUPT
-# EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
+# ccflags-y := -DTRAP_DBG_INTERRUPT
+# asflags-y := -DTRAP_DBG_INTERRUPT
 #
 
 asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
diff --git a/arch/m68knommu/platform/5249/Makefile b/arch/m68knommu/platform/5249/Makefile
index f56225d..4bed30f 100644
--- a/arch/m68knommu/platform/5249/Makefile
+++ b/arch/m68knommu/platform/5249/Makefile
@@ -8,8 +8,8 @@
 # on the console port whenever a DBG interrupt occurs.  You have to
 # set up you HW breakpoints to trigger a DBG interrupt:
 #
-# EXTRA_CFLAGS += -DTRAP_DBG_INTERRUPT
-# EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
+# ccflags-y := -DTRAP_DBG_INTERRUPT
+# asflags-y := -DTRAP_DBG_INTERRUPT
 #
 
 asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
diff --git a/arch/m68knommu/platform/5272/Makefile b/arch/m68knommu/platform/5272/Makefile
index 93673ef..34110fc 100644
--- a/arch/m68knommu/platform/5272/Makefile
+++ b/arch/m68knommu/platform/5272/Makefile
@@ -8,8 +8,8 @@
 # on the console port whenever a DBG interrupt occurs.  You have to
 # set up you HW breakpoints to trigger a DBG interrupt:
 #
-# EXTRA_CFLAGS += -DTRAP_DBG_INTERRUPT
-# EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
+# ccflags-y := -DTRAP_DBG_INTERRUPT
+# asflags-y := -DTRAP_DBG_INTERRUPT
 #
 
 asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
diff --git a/arch/m68knommu/platform/527x/Makefile b/arch/m68knommu/platform/527x/Makefile
index 3d90e6d..6ac4b57 100644
--- a/arch/m68knommu/platform/527x/Makefile
+++ b/arch/m68knommu/platform/527x/Makefile
@@ -8,8 +8,8 @@
 # on the console port whenever a DBG interrupt occurs.  You have to
 # set up you HW breakpoints to trigger a DBG interrupt:
 #
-# EXTRA_CFLAGS += -DTRAP_DBG_INTERRUPT
-# EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
+# ccflags-y := -DTRAP_DBG_INTERRUPT
+# asflags-y := -DTRAP_DBG_INTERRUPT
 #
 
 asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
diff --git a/arch/m68knommu/platform/528x/Makefile b/arch/m68knommu/platform/528x/Makefile
index 3d90e6d..6ac4b57 100644
--- a/arch/m68knommu/platform/528x/Makefile
+++ b/arch/m68knommu/platform/528x/Makefile
@@ -8,8 +8,8 @@
 # on the console port whenever a DBG interrupt occurs.  You have to
 # set up you HW breakpoints to trigger a DBG interrupt:
 #
-# EXTRA_CFLAGS += -DTRAP_DBG_INTERRUPT
-# EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
+# ccflags-y := -DTRAP_DBG_INTERRUPT
+# asflags-y := -DTRAP_DBG_INTERRUPT
 #
 
 asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
diff --git a/arch/m68knommu/platform/5307/Makefile b/arch/m68knommu/platform/5307/Makefile
index 6de5269..d4293b7 100644
--- a/arch/m68knommu/platform/5307/Makefile
+++ b/arch/m68knommu/platform/5307/Makefile
@@ -8,8 +8,8 @@
 # on the console port whenever a DBG interrupt occurs. You have to
 # set up you HW breakpoints to trigger a DBG interrupt:
 #
-# EXTRA_CFLAGS += -DTRAP_DBG_INTERRUPT
-# EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
+# ccflags-y := -DTRAP_DBG_INTERRUPT
+# asflags-y := -DTRAP_DBG_INTERRUPT
 #
 
 asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
diff --git a/arch/m68knommu/platform/532x/Makefile b/arch/m68knommu/platform/532x/Makefile
index 4cc2324..ce01669 100644
--- a/arch/m68knommu/platform/532x/Makefile
+++ b/arch/m68knommu/platform/532x/Makefile
@@ -8,8 +8,8 @@
 # on the console port whenever a DBG interrupt occurs. You have to
 # set up you HW breakpoints to trigger a DBG interrupt:
 #
-# EXTRA_CFLAGS += -DTRAP_DBG_INTERRUPT
-# EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
+# ccflags-y := -DTRAP_DBG_INTERRUPT
+# asflags-y := -DTRAP_DBG_INTERRUPT
 #
 
 asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
diff --git a/arch/m68knommu/platform/5407/Makefile b/arch/m68knommu/platform/5407/Makefile
index dee62c5..e83fe14 100644
--- a/arch/m68knommu/platform/5407/Makefile
+++ b/arch/m68knommu/platform/5407/Makefile
@@ -8,8 +8,8 @@
 # on the console port whenever a DBG interrupt occurs. You have to
 # set up you HW breakpoints to trigger a DBG interrupt:
 #
-# EXTRA_CFLAGS += -DTRAP_DBG_INTERRUPT
-# EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
+# ccflags-y := -DTRAP_DBG_INTERRUPT
+# asflags-y := -DTRAP_DBG_INTERRUPT
 #
 
 asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
diff --git a/arch/m68knommu/platform/coldfire/Makefile b/arch/m68knommu/platform/coldfire/Makefile
index f72a0e5..788c13f 100644
--- a/arch/m68knommu/platform/coldfire/Makefile
+++ b/arch/m68knommu/platform/coldfire/Makefile
@@ -8,8 +8,8 @@
 # on the console port whenever a DBG interrupt occurs. You have to
 # set up you HW breakpoints to trigger a DBG interrupt:
 #
-# EXTRA_CFLAGS += -DTRAP_DBG_INTERRUPT
-# EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
+# ccflags-y := -DTRAP_DBG_INTERRUPT
+# asflags-y := -DTRAP_DBG_INTERRUPT
 #
 
 asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
-- 
1.7.2.1

