Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933453Ab2JWULA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:11:00 -0400
Received: from smtp.outflux.net ([198.145.64.163]:40558 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933936Ab2JWUK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:10:57 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 014/193] arch/m68k: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:01:27 -0700
Message-Id: <1351022666-6960-15-git-send-email-keescook@chromium.org>
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

CC: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/m68k/Kconfig.bus     |    4 ++--
 arch/m68k/Kconfig.cpu     |    3 +--
 arch/m68k/Kconfig.debug   |    2 +-
 arch/m68k/Kconfig.devices |    6 +++---
 4 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/m68k/Kconfig.bus b/arch/m68k/Kconfig.bus
index ffc0601..93ef034 100644
--- a/arch/m68k/Kconfig.bus
+++ b/arch/m68k/Kconfig.bus
@@ -28,8 +28,8 @@ config ZORRO
 	  Linux use these.
 
 config AMIGA_PCMCIA
-	bool "Amiga 1200/600 PCMCIA support (EXPERIMENTAL)"
-	depends on AMIGA && EXPERIMENTAL
+	bool "Amiga 1200/600 PCMCIA support"
+	depends on AMIGA
 	help
 	  Include support in the kernel for pcmcia on Amiga 1200 and Amiga
 	  600. If you intend to use pcmcia cards say Y; otherwise say N.
diff --git a/arch/m68k/Kconfig.cpu b/arch/m68k/Kconfig.cpu
index c4eb79e..2f2d87b 100644
--- a/arch/m68k/Kconfig.cpu
+++ b/arch/m68k/Kconfig.cpu
@@ -274,9 +274,8 @@ endif # COLDFIRE
 comment "Processor Specific Options"
 
 config M68KFPU_EMU
-	bool "Math emulation support (EXPERIMENTAL)"
+	bool "Math emulation support"
 	depends on MMU
-	depends on EXPERIMENTAL
 	help
 	  At some point in the future, this will cause floating-point math
 	  instructions to be emulated by the kernel on machines that lack a
diff --git a/arch/m68k/Kconfig.debug b/arch/m68k/Kconfig.debug
index 87233ac..fa12283 100644
--- a/arch/m68k/Kconfig.debug
+++ b/arch/m68k/Kconfig.debug
@@ -41,7 +41,7 @@ config NO_KERNEL_MSG
 
 config BDM_DISABLE
 	bool "Disable BDM signals"
-	depends on (EXPERIMENTAL && COLDFIRE)
+	depends on COLDFIRE
 	help
 	  Disable the ColdFire CPU's BDM signals.
 
diff --git a/arch/m68k/Kconfig.devices b/arch/m68k/Kconfig.devices
index 04a3d9b..c4cdfe4 100644
--- a/arch/m68k/Kconfig.devices
+++ b/arch/m68k/Kconfig.devices
@@ -60,8 +60,8 @@ endmenu
 menu "Character devices"
 
 config ATARI_DSP56K
-	tristate "Atari DSP56k support (EXPERIMENTAL)"
-	depends on ATARI && EXPERIMENTAL
+	tristate "Atari DSP56k support"
+	depends on ATARI
 	help
 	  If you want to be able to use the DSP56001 in Falcons, say Y. This
 	  driver is still experimental, and if you don't know what it is, or
@@ -87,7 +87,7 @@ config HPDCA
 
 config HPAPCI
 	tristate "HP APCI serial support"
-	depends on HP300 && SERIAL_8250 && EXPERIMENTAL
+	depends on HP300 && SERIAL_8250
 	help
 	  If you want to use the internal "APCI" serial ports on an HP400
 	  machine, say Y here.
-- 
1.7.9.5

