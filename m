Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445Ab1KMKbm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 05:31:42 -0500
Received: from brigitte.telenet-ops.be ([195.130.137.66]:58080 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab1KMKbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 05:31:40 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] m68k: Remove references to obsolete CONFIG_SERIAL167
Date: Sun, 13 Nov 2011 11:31:36 +0100
Message-Id: <1321180296-22543-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 51c9d654c2def97827395a7fbfd0c6f865c26544 ("Staging: delete tty
drivers") removed the MVME167 serial driver, but forgot to remove these
references.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/Kconfig.devices           |    2 +-
 arch/m68k/configs/multi_defconfig   |    1 -
 arch/m68k/configs/mvme16x_defconfig |    1 -
 3 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/m68k/Kconfig.devices b/arch/m68k/Kconfig.devices
index 6033f5d..e01eeb2 100644
--- a/arch/m68k/Kconfig.devices
+++ b/arch/m68k/Kconfig.devices
@@ -128,7 +128,7 @@ config DN_SERIAL
 
 config SERIAL_CONSOLE
 	bool "Support for serial port console"
-	depends on (AMIGA || ATARI || SUN3 || SUN3X || VME || APOLLO) && (ATARI_MFPSER=y || ATARI_MIDI=y || AMIGA_BUILTIN_SERIAL=y || MULTIFACE_III_TTY=y || SERIAL=y || SERIAL167 || DN_SERIAL)
+	depends on (AMIGA || ATARI || SUN3 || SUN3X || VME || APOLLO) && (ATARI_MFPSER=y || ATARI_MIDI=y || AMIGA_BUILTIN_SERIAL=y || MULTIFACE_III_TTY=y || SERIAL=y || DN_SERIAL)
 	---help---
 	  If you say Y here, it will be possible to use a serial port as the
 	  system console (the system console is the device which receives all
diff --git a/arch/m68k/configs/multi_defconfig b/arch/m68k/configs/multi_defconfig
index 88fb437..116e2ec 100644
--- a/arch/m68k/configs/multi_defconfig
+++ b/arch/m68k/configs/multi_defconfig
@@ -330,7 +330,6 @@ CONFIG_ATARI_MIDI=y
 CONFIG_ATARI_DSP56K=m
 CONFIG_AMIGA_BUILTIN_SERIAL=y
 CONFIG_MULTIFACE_III_TTY=m
-CONFIG_SERIAL167=y
 CONFIG_DN_SERIAL=y
 CONFIG_SERIAL_CONSOLE=y
 CONFIG_EXT2_FS=y
diff --git a/arch/m68k/configs/mvme16x_defconfig b/arch/m68k/configs/mvme16x_defconfig
index c45aaf3..6dd12e6 100644
--- a/arch/m68k/configs/mvme16x_defconfig
+++ b/arch/m68k/configs/mvme16x_defconfig
@@ -218,7 +218,6 @@ CONFIG_GEN_RTC_X=y
 CONFIG_HID=m
 CONFIG_HIDRAW=y
 # CONFIG_USB_SUPPORT is not set
-CONFIG_SERIAL167=y
 CONFIG_SERIAL_CONSOLE=y
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
-- 
1.7.0.4

