Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965204Ab2JWUpv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:45:51 -0400
Received: from smtp.outflux.net ([198.145.64.163]:48736 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933794Ab2JWUFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:25 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Wim Van Sebroeck <wim@iguana.be>
Subject: [PATCH 135/193] drivers/watchdog: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:03:28 -0700
Message-Id: <1351022666-6960-136-git-send-email-keescook@chromium.org>
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

