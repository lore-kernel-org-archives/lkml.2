Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233Ab1FTWSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 18:18:37 -0400
Received: from claw.goop.org ([74.207.240.146]:53606 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755883Ab1FTWPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 18:15:23 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Xen Devel <Xen-devel@lists.xensource.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 03/15] xen/trace: set up tracepoint skeleton
Date: Mon, 20 Jun 2011 15:14:59 -0700
Message-Id: <b17d244c04d6852ecb91d6b1a5760b9c73bc7d0b.1308607697.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/Makefile |    2 +-
 arch/x86/xen/trace.c  |    4 ++++
 2 files changed, 5 insertions(+), 1 deletions(-)
 create mode 100644 arch/x86/xen/trace.c

diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
index 17c565d..6fdf366 100644
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -13,7 +13,7 @@ CFLAGS_mmu.o			:= $(nostackp)
 obj-y		:= enlighten.o setup.o multicalls.o mmu.o irq.o \
 			time.o xen-asm.o xen-asm_$(BITS).o \
 			grant-table.o suspend.o platform-pci-unplug.o \
-			p2m.o
+			p2m.o trace.o
 
 obj-$(CONFIG_SMP)		+= smp.o
 obj-$(CONFIG_PARAVIRT_SPINLOCKS)+= spinlock.o
diff --git a/arch/x86/xen/trace.c b/arch/x86/xen/trace.c
new file mode 100644
index 0000000..8cca616
--- /dev/null
+++ b/arch/x86/xen/trace.c
@@ -0,0 +1,4 @@
+#include <linux/ftrace.h>
+
+#define CREATE_TRACE_POINTS
+#include <trace/events/xen.h>
-- 
1.7.5.4

