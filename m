Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932928Ab2KEXSw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:18:52 -0500
Received: from smtp.outflux.net ([198.145.64.163]:43302 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755137Ab2KEXF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:27 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 080/104] drivers/video: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:04:37 -0800
Message-Id: <1352156701-4038-81-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352156701-4038-1-git-send-email-keescook@chromium.org>
References: <1352156701-4038-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
while now and is almost always enabled by default. As agreed during the
Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

CC: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/video/Kconfig |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index d08d799..58b038a 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -1112,8 +1112,8 @@ config FB_RIVA_BACKLIGHT
 	  Say Y here if you want to control the backlight of your display.
 
 config FB_I740
-	tristate "Intel740 support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && FB && PCI
+	tristate "Intel740 support"
+	depends on FB && PCI
 	select FB_MODE_HELPERS
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
@@ -1124,8 +1124,8 @@ config FB_I740
 	  This driver supports graphics cards based on Intel740 chip.
 
 config FB_I810
-	tristate "Intel 810/815 support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && FB && PCI && X86_32 && AGP_INTEL
+	tristate "Intel 810/815 support"
+	depends on FB && PCI && X86_32 && AGP_INTEL
 	select FB_MODE_HELPERS
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
@@ -1187,8 +1187,8 @@ config FB_CARILLO_RANCH
 	  This driver supports the LE80578 (Carillo Ranch) board
 
 config FB_INTEL
-	tristate "Intel 830M/845G/852GM/855GM/865G/915G/945G/945GM/965G/965GM support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && FB && PCI && X86 && AGP_INTEL && EXPERT
+	tristate "Intel 830M/845G/852GM/855GM/865G/915G/945G/945GM/965G/965GM support"
+	depends on FB && PCI && X86 && AGP_INTEL && EXPERT
 	select FB_MODE_HELPERS
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
@@ -1432,7 +1432,7 @@ config FB_ATY_CT
 	  is at <http://support.ati.com/products/pc/mach64/mach64.html>.
 
 config FB_ATY_GENERIC_LCD
-	bool "Mach64 generic LCD support (EXPERIMENTAL)"
+	bool "Mach64 generic LCD support"
 	depends on FB_ATY_CT
 	help
 	  Say Y if you have a laptop with an ATI Rage LT PRO, Rage Mobility,
@@ -1479,7 +1479,7 @@ config FB_S3_DDC
 
 config FB_SAVAGE
 	tristate "S3 Savage support"
-	depends on FB && PCI && EXPERIMENTAL
+	depends on FB && PCI
 	select FB_MODE_HELPERS
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
@@ -1633,15 +1633,15 @@ config FB_3DFX
 	  module will be called tdfxfb.
 
 config FB_3DFX_ACCEL
-	bool "3Dfx Acceleration functions (EXPERIMENTAL)"
-	depends on FB_3DFX && EXPERIMENTAL
+	bool "3Dfx Acceleration functions"
+	depends on FB_3DFX
 	---help---
 	This will compile the 3Dfx Banshee/Voodoo3/VSA-100 frame buffer
 	device driver with acceleration functions.
 
 config FB_3DFX_I2C
 	bool "Enable DDC/I2C support"
-	depends on FB_3DFX && EXPERIMENTAL
+	depends on FB_3DFX
 	select FB_DDC
 	default y
 	help
@@ -1714,8 +1714,8 @@ config FB_ARK
 	  and ICS 5342 RAMDAC.
 
 config FB_PM3
-	tristate "Permedia3 support (EXPERIMENTAL)"
-	depends on FB && PCI && EXPERIMENTAL
+	tristate "Permedia3 support"
+	depends on FB && PCI
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
-- 
1.7.9.5

