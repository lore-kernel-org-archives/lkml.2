Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933518Ab2KEXNP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:13:15 -0500
Received: from smtp.outflux.net ([198.145.64.163]:47264 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932913Ab2KEXFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:34 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Alex Dubov <oakad@yahoo.com>
Subject: [PATCH 061/104] drivers/memstick: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:04:18 -0800
Message-Id: <1352156701-4038-62-git-send-email-keescook@chromium.org>
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
 drivers/memstick/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/memstick/Kconfig b/drivers/memstick/Kconfig
index f0ca41c..1314605 100644
--- a/drivers/memstick/Kconfig
+++ b/drivers/memstick/Kconfig
@@ -3,7 +3,7 @@
 #
 
 menuconfig MEMSTICK
-	tristate "Sony MemoryStick card support (EXPERIMENTAL)"
+	tristate "Sony MemoryStick card support"
 	help
 	  Sony MemoryStick is a proprietary storage/extension card protocol.
 
-- 
1.7.9.5

