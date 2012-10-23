Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934061Ab2JWUXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:23:32 -0400
Received: from smtp.outflux.net ([198.145.64.163]:53863 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934017Ab2JWULX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:11:23 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Jiri Kosina <jkosina@suse.cz>, Paul Bolle <pebolle@tiscali.nl>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 129/193] drivers/video/console: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:03:22 -0700
Message-Id: <1351022666-6960-130-git-send-email-keescook@chromium.org>
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
CC: Mathieu Poirier <mathieu.poirier@linaro.org>
CC: Jiri Kosina <jkosina@suse.cz>
CC: Paul Bolle <pebolle@tiscali.nl>
CC: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/video/console/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/console/Kconfig b/drivers/video/console/Kconfig
index e2c96d0..bc922c4 100644
--- a/drivers/video/console/Kconfig
+++ b/drivers/video/console/Kconfig
@@ -46,7 +46,7 @@ config VGACON_SOFT_SCROLLBACK_SIZE
 
 config MDA_CONSOLE
 	depends on !M68K && !PARISC && ISA
-	tristate "MDA text console (dual-headed) (EXPERIMENTAL)"
+	tristate "MDA text console (dual-headed)"
 	---help---
 	  Say Y here if you have an old MDA or monochrome Hercules graphics
 	  adapter in your system acting as a second head ( = video card). You
-- 
1.7.9.5

