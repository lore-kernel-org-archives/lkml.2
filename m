Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab1APSjj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 13:39:39 -0500
Received: from georges.telenet-ops.be ([195.130.137.68]:49988 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404Ab1APSji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 13:39:38 -0500
Date: Sun, 16 Jan 2011 19:39:36 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Ungerer <gerg@uclinux.org>
cc: uClinux list <uclinux-dev@uclinux.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH resend] m68knommu: Remove dependencies on nonexistent
 M68KNOMMU
Message-ID: <alpine.DEB.2.00.1101161937280.7839@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

M68KNOMMU is set nowhere.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
The list is getting shorted. Recently two occurrences were killed in the
watchdog section.

 drivers/net/can/mscan/Kconfig |    2 +-
 lib/Kconfig.debug             |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/mscan/Kconfig b/drivers/net/can/mscan/Kconfig
index 27d1d39..d387069 100644
--- a/drivers/net/can/mscan/Kconfig
+++ b/drivers/net/can/mscan/Kconfig
@@ -1,5 +1,5 @@
 config CAN_MSCAN
-	depends on CAN_DEV && (PPC || M68K || M68KNOMMU)
+	depends on CAN_DEV && (PPC || M68K)
 	tristate "Support for Freescale MSCAN based chips"
 	---help---
 	  The Motorola Scalable Controller Area Network (MSCAN) definition
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 2d05adb..e21527b 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -805,7 +805,7 @@ config ARCH_WANT_FRAME_POINTERS
 config FRAME_POINTER
 	bool "Compile the kernel with frame pointers"
 	depends on DEBUG_KERNEL && \
-		(CRIS || M68K || M68KNOMMU || FRV || UML || \
+		(CRIS || M68K || FRV || UML || \
 		 AVR32 || SUPERH || BLACKFIN || MN10300) || \
 		ARCH_WANT_FRAME_POINTERS
 	default y if (DEBUG_INFO && UML) || ARCH_WANT_FRAME_POINTERS
-- 
1.7.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
