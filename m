Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab2KEXR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:17:29 -0500
Received: from smtp.outflux.net ([198.145.64.163]:37907 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932956Ab2KEXF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:28 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Wim Van Sebroeck <wim@iguana.be>
Subject: [PATCH 085/104] drivers/watchdog: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:04:42 -0800
Message-Id: <1352156701-4038-86-git-send-email-keescook@chromium.org>
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

CC: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/watchdog/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index ad1bb93..807d73c 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -431,7 +431,7 @@ config ALIM7101_WDT
 
 config F71808E_WDT
 	tristate "Fintek F71808E, F71862FG, F71869, F71882FG and F71889FG Watchdog"
-	depends on X86 && EXPERIMENTAL
+	depends on X86
 	help
 	  This is the driver for the hardware watchdog on the Fintek
 	  F71808E, F71862FG, F71869, F71882FG and F71889FG Super I/O controllers.
@@ -622,7 +622,7 @@ config IT8712F_WDT
 
 config IT87_WDT
 	tristate "IT87 Watchdog Timer"
-	depends on X86 && EXPERIMENTAL
+	depends on X86
 	---help---
 	  This is the driver for the hardware watchdog on the ITE IT8702,
 	  IT8712, IT8716, IT8718, IT8720, IT8721, IT8726 and IT8728
-- 
1.7.9.5

