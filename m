Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab0IWGxl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 02:53:41 -0400
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:50666 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754022Ab0IWGwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 02:52:12 -0400
From: matt mooney <mfm@muteddisk.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Magnus Damm <damm@opensource.se>, Matt Fleming <matt@console-pimps.org>,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 14/20] sh: change to new flag variable
Date: Wed, 22 Sep 2010 23:51:21 -0700
Message-Id: <1285224681-29933-1-git-send-email-mfm@muteddisk.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace EXTRA_CFLAGS with ccflags-y.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 arch/sh/cchips/hd6446x/Makefile |    2 +-
 arch/sh/kernel/Makefile         |    2 +-
 arch/sh/lib/Makefile            |    2 +-
 arch/sh/mm/Makefile             |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/sh/cchips/hd6446x/Makefile b/arch/sh/cchips/hd6446x/Makefile
index 9682e3a..59c3483 100644
--- a/arch/sh/cchips/hd6446x/Makefile
+++ b/arch/sh/cchips/hd6446x/Makefile
@@ -1,3 +1,3 @@
 obj-$(CONFIG_HD64461)	+= hd64461.o
 
-EXTRA_CFLAGS += -Werror
+ccflags-y := -Werror
diff --git a/arch/sh/kernel/Makefile b/arch/sh/kernel/Makefile
index e25f3c6..b308391 100644
--- a/arch/sh/kernel/Makefile
+++ b/arch/sh/kernel/Makefile
@@ -44,4 +44,4 @@ obj-$(CONFIG_HAS_IOPORT)	+= io_generic.o
 obj-$(CONFIG_HAVE_HW_BREAKPOINT)		+= hw_breakpoint.o
 obj-$(CONFIG_GENERIC_CLOCKEVENTS_BROADCAST)	+= localtimer.o
 
-EXTRA_CFLAGS += -Werror
+ccflags-y := -Werror
diff --git a/arch/sh/lib/Makefile b/arch/sh/lib/Makefile
index dab4d21..7b95f29 100644
--- a/arch/sh/lib/Makefile
+++ b/arch/sh/lib/Makefile
@@ -30,4 +30,4 @@ lib-$(CONFIG_MMU)		+= copy_page.o __clear_user.o
 lib-$(CONFIG_MCOUNT)		+= mcount.o
 lib-y				+= $(memcpy-y) $(memset-y) $(udivsi3-y)
 
-EXTRA_CFLAGS += -Werror
+ccflags-y := -Werror
diff --git a/arch/sh/mm/Makefile b/arch/sh/mm/Makefile
index 53f7c68..939663c 100644
--- a/arch/sh/mm/Makefile
+++ b/arch/sh/mm/Makefile
@@ -66,4 +66,4 @@ CFLAGS_fault_64.o += -ffixed-r7 \
 	-ffixed-r60 -ffixed-r61 -ffixed-r62 \
 	-fomit-frame-pointer
 
-EXTRA_CFLAGS += -Werror
+ccflags-y := -Werror
-- 
1.7.2.1

