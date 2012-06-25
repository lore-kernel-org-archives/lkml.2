Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744Ab2FYTLt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 15:11:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45333 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820Ab2FYTLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 15:11:47 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] ARM: Delete asm/system.h
To: linux@arm.linux.org.uk
Cc: dhowells@redhat.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Mon, 25 Jun 2012 20:11:31 +0100
Message-ID: <20120625191130.27109.42551.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete asm/system.h from the ARM arch.  This was missed when the others were
deleted.

Reported-by: Russell King <linux@arm.linux.org.uk>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/arm/include/asm/jump_label.h |    1 -
 arch/arm/include/asm/system.h     |    8 --------
 arch/arm/mach-msm/idle.c          |    2 +-
 arch/arm/plat-omap/mux.c          |    2 --
 drivers/usb/gadget/lpc32xx_udc.c  |    1 -
 5 files changed, 1 insertions(+), 13 deletions(-)
 delete mode 100644 arch/arm/include/asm/system.h

diff --git a/arch/arm/include/asm/jump_label.h b/arch/arm/include/asm/jump_label.h
index bfc198c..f0409ec 100644
--- a/arch/arm/include/asm/jump_label.h
+++ b/arch/arm/include/asm/jump_label.h
@@ -4,7 +4,6 @@
 #ifdef __KERNEL__
 
 #include <linux/types.h>
-#include <asm/system.h>
 
 #define JUMP_LABEL_NOP_SIZE 4
 
diff --git a/arch/arm/include/asm/system.h b/arch/arm/include/asm/system.h
deleted file mode 100644
index 74542c5..0000000
--- a/arch/arm/include/asm/system.h
+++ /dev/null
@@ -1,8 +0,0 @@
-/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
-#include <asm/barrier.h>
-#include <asm/compiler.h>
-#include <asm/cmpxchg.h>
-#include <asm/exec.h>
-#include <asm/switch_to.h>
-#include <asm/system_info.h>
-#include <asm/system_misc.h>
diff --git a/arch/arm/mach-msm/idle.c b/arch/arm/mach-msm/idle.c
index 0c9e13c..e4d0c66 100644
--- a/arch/arm/mach-msm/idle.c
+++ b/arch/arm/mach-msm/idle.c
@@ -17,7 +17,7 @@
  */
 
 #include <linux/init.h>
-#include <asm/system.h>
+#include <asm/system_misc.h>
 
 static void msm_idle(void)
 {
diff --git a/arch/arm/plat-omap/mux.c b/arch/arm/plat-omap/mux.c
index cff8712..da503eb 100644
--- a/arch/arm/plat-omap/mux.c
+++ b/arch/arm/plat-omap/mux.c
@@ -28,8 +28,6 @@
 #include <linux/io.h>
 #include <linux/spinlock.h>
 
-#include <asm/system.h>
-
 #include <plat/cpu.h>
 #include <plat/mux.h>
 
diff --git a/drivers/usb/gadget/lpc32xx_udc.c b/drivers/usb/gadget/lpc32xx_udc.c
index 262acfd..626963e 100644
--- a/drivers/usb/gadget/lpc32xx_udc.c
+++ b/drivers/usb/gadget/lpc32xx_udc.c
@@ -55,7 +55,6 @@
 #include <mach/hardware.h>
 #include <linux/io.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 
 #include <mach/platform.h>
 #include <mach/irqs.h>

