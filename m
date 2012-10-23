Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965238Ab2JWUtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:49:19 -0400
Received: from smtp.outflux.net ([198.145.64.163]:41280 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933660Ab2JWUFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:23 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 130/193] drivers/video/geode: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:03:23 -0700
Message-Id: <1351022666-6960-131-git-send-email-keescook@chromium.org>
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

CC: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/video/geode/Kconfig |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/video/geode/Kconfig b/drivers/video/geode/Kconfig
index c5d8ba4..21e351a 100644
--- a/drivers/video/geode/Kconfig
+++ b/drivers/video/geode/Kconfig
@@ -2,14 +2,14 @@
 # Geode family framebuffer configuration
 #
 config FB_GEODE
-	bool "AMD Geode family framebuffer support (EXPERIMENTAL)"
-	depends on FB && PCI && EXPERIMENTAL && X86
+	bool "AMD Geode family framebuffer support"
+	depends on FB && PCI && X86
 	---help---
 	  Say 'Y' here to allow you to select framebuffer drivers for
 	  the AMD Geode family of processors.
 
 config FB_GEODE_LX
-	tristate "AMD Geode LX framebuffer support (EXPERIMENTAL)"
+	tristate "AMD Geode LX framebuffer support"
 	depends on FB && FB_GEODE
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
@@ -24,8 +24,8 @@ config FB_GEODE_LX
 	  If unsure, say N.
 
 config FB_GEODE_GX
-	tristate "AMD Geode GX framebuffer support (EXPERIMENTAL)"
-	depends on FB && FB_GEODE && EXPERIMENTAL
+	tristate "AMD Geode GX framebuffer support"
+	depends on FB && FB_GEODE
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
@@ -39,8 +39,8 @@ config FB_GEODE_GX
 	  If unsure, say N.
 
 config FB_GEODE_GX1
-	tristate "AMD Geode GX1 framebuffer support (EXPERIMENTAL)"
-	depends on FB && FB_GEODE && EXPERIMENTAL
+	tristate "AMD Geode GX1 framebuffer support"
+	depends on FB && FB_GEODE
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
-- 
1.7.9.5

