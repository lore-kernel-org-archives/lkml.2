Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964908Ab2KEXXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:23:39 -0500
Received: from smtp.outflux.net ([198.145.64.163]:41967 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755108Ab2KEXF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:26 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Len Brown <len.brown@intel.com>
Subject: [PATCH 051/104] drivers/idle: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:04:08 -0800
Message-Id: <1352156701-4038-52-git-send-email-keescook@chromium.org>
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

Cc: Len Brown <len.brown@intel.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/idle/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/idle/Kconfig b/drivers/idle/Kconfig
index 8489eb5..4732dfc 100644
--- a/drivers/idle/Kconfig
+++ b/drivers/idle/Kconfig
@@ -18,7 +18,6 @@ config I7300_IDLE_IOAT_CHANNEL
 config I7300_IDLE
 	tristate "Intel chipset idle memory power saving driver"
 	select I7300_IDLE_IOAT_CHANNEL
-	depends on EXPERIMENTAL
 	help
 	  Enable memory power savings when idle with certain Intel server
 	  chipsets. The chipset must have I/O AT support, such as the
-- 
1.7.9.5

