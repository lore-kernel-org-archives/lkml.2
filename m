Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933475Ab2KEXNN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:13:13 -0500
Received: from smtp.outflux.net ([198.145.64.163]:36427 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754732Ab2KEXFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:34 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Alex Dubov <oakad@yahoo.com>
Subject: [PATCH 060/104] drivers/memstick/host: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:04:17 -0800
Message-Id: <1352156701-4038-61-git-send-email-keescook@chromium.org>
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

Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Alex Dubov <oakad@yahoo.com>
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

