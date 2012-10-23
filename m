Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965637Ab2JWVHa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:07:30 -0400
Received: from smtp.outflux.net ([198.145.64.163]:37902 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933675Ab2JWUFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:06 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>
Subject: [PATCH 069/193] drivers/memstick/host: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:02:22 -0700
Message-Id: <1351022666-6960-70-git-send-email-keescook@chromium.org>
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

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/memstick/host/Kconfig |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/memstick/host/Kconfig b/drivers/memstick/host/Kconfig
index cc0997a..0e6a907 100644
--- a/drivers/memstick/host/Kconfig
+++ b/drivers/memstick/host/Kconfig
@@ -5,8 +5,8 @@
 comment "MemoryStick Host Controller Drivers"
 
 config MEMSTICK_TIFM_MS
-	tristate "TI Flash Media MemoryStick Interface support  (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && PCI
+	tristate "TI Flash Media MemoryStick Interface support "
+	depends on PCI
 	select TIFM_CORE
 	help
 	  Say Y here if you want to be able to access MemoryStick cards with
@@ -21,8 +21,8 @@ config MEMSTICK_TIFM_MS
 	  module will be called tifm_ms.
 
 config MEMSTICK_JMICRON_38X
-	tristate "JMicron JMB38X MemoryStick interface support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && PCI
+	tristate "JMicron JMB38X MemoryStick interface support"
+	depends on PCI
 
 	help
 	  Say Y here if you want to be able to access MemoryStick cards with
@@ -32,8 +32,8 @@ config MEMSTICK_JMICRON_38X
 	  module will be called jmb38x_ms.
 
 config MEMSTICK_R592
-	tristate "Ricoh R5C592 MemoryStick interface support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && PCI
+	tristate "Ricoh R5C592 MemoryStick interface support"
+	depends on PCI
 
 	help
 	  Say Y here if you want to be able to access MemoryStick cards with
-- 
1.7.9.5

