Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab2KEXQw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:16:52 -0500
Received: from smtp.outflux.net ([198.145.64.163]:39642 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933021Ab2KEXF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:29 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 083/104] drivers/video/omap: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:04:40 -0800
Message-Id: <1352156701-4038-84-git-send-email-keescook@chromium.org>
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

CC: Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/video/omap/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/omap/Kconfig b/drivers/video/omap/Kconfig
index b48f95f..e512581 100644
--- a/drivers/video/omap/Kconfig
+++ b/drivers/video/omap/Kconfig
@@ -1,5 +1,5 @@
 config FB_OMAP
-	tristate "OMAP frame buffer support (EXPERIMENTAL)"
+	tristate "OMAP frame buffer support"
 	depends on FB
 	depends on ARCH_OMAP1
 	select FB_CFB_FILLRECT
-- 
1.7.9.5

