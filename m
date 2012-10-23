Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965426Ab2JWUzh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:55:37 -0400
Received: from smtp.outflux.net ([198.145.64.163]:43223 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933738Ab2JWUFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:19 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 119/193] drivers/sbus/char: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:03:12 -0700
Message-Id: <1351022666-6960-120-git-send-email-keescook@chromium.org>
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

CC: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/sbus/char/Kconfig |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/sbus/char/Kconfig b/drivers/sbus/char/Kconfig
index 73cde85..5ba684f 100644
--- a/drivers/sbus/char/Kconfig
+++ b/drivers/sbus/char/Kconfig
@@ -21,8 +21,7 @@ config OBP_FLASH
 	  able to upgrade the OBP firmware, say Y here.
 
 config TADPOLE_TS102_UCTRL
-	tristate "Tadpole TS102 Microcontroller support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "Tadpole TS102 Microcontroller support"
 	help
 	  Say Y here to directly support the TS102 Microcontroller interface
 	  on the Tadpole Sparcbook 3.  This device handles power-management
@@ -30,8 +29,8 @@ config TADPOLE_TS102_UCTRL
 	  monitors and mice.
 
 config SUN_JSFLASH
-	tristate "JavaStation OS Flash SIMM (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && SPARC32
+	tristate "JavaStation OS Flash SIMM"
+	depends on SPARC32
 	help
 	  If you say Y here, you will be able to boot from your JavaStation's
 	  Flash memory.
-- 
1.7.9.5

