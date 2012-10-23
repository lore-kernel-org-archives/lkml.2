Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965666Ab2JWVMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:12:32 -0400
Received: from smtp.outflux.net ([198.145.64.163]:39023 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933654Ab2JWUFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:03 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 017/193] arch/mips/jazz: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:01:30 -0700
Message-Id: <1351022666-6960-18-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351022666-6960-1-git-send-email-keescook@chromium.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This config item has not carried much meaning for a while now and is
almost always enabled by default. As agreed during the Linux kernel
summit, remove it.

CC: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/mips/jazz/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/mips/jazz/Kconfig b/arch/mips/jazz/Kconfig
index 1f372b0..fb1e072 100644
--- a/arch/mips/jazz/Kconfig
+++ b/arch/mips/jazz/Kconfig
@@ -1,6 +1,6 @@
 config ACER_PICA_61
-	bool "Support for Acer PICA 1 chipset (EXPERIMENTAL)"
-	depends on MACH_JAZZ && EXPERIMENTAL
+	bool "Support for Acer PICA 1 chipset"
+	depends on MACH_JAZZ
 	select DMA_NONCOHERENT
 	select SYS_SUPPORTS_LITTLE_ENDIAN
 	help
@@ -13,7 +13,7 @@ config MIPS_MAGNUM_4000
 	bool "Support for MIPS Magnum 4000"
 	depends on MACH_JAZZ
 	select DMA_NONCOHERENT
-	select SYS_SUPPORTS_BIG_ENDIAN if EXPERIMENTAL
+	select SYS_SUPPORTS_BIG_ENDIAN
 	select SYS_SUPPORTS_LITTLE_ENDIAN
 	help
 	  This is a machine with a R4000 100 MHz CPU. To compile a Linux
-- 
1.7.9.5

