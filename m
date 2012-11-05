Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933042Ab2KEXGg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:06:36 -0500
Received: from smtp.outflux.net ([198.145.64.163]:33908 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753909Ab2KEXGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:06:34 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: [PATCH 068/104] drivers/pcmcia: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:04:25 -0800
Message-Id: <1352156701-4038-69-git-send-email-keescook@chromium.org>
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

CC: Russell King <rmk+kernel@arm.linux.org.uk>
CC: Manuel Lauss <manuel.lauss@googlemail.com>
CC: Dominik Brodowski <linux@dominikbrodowski.net>
CC: Ralf Baechle <ralf@linux-mips.org>
CC: Haojian Zhuang <haojian.zhuang@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/pcmcia/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pcmcia/Kconfig b/drivers/pcmcia/Kconfig
index 8fd255f..b90f85b 100644
--- a/drivers/pcmcia/Kconfig
+++ b/drivers/pcmcia/Kconfig
@@ -36,8 +36,8 @@ config PCMCIA
 	   If unsure, say Y.
 
 config PCMCIA_LOAD_CIS
-	bool "Load CIS updates from userspace (EXPERIMENTAL)"
-	depends on PCMCIA && EXPERIMENTAL
+	bool "Load CIS updates from userspace"
+	depends on PCMCIA
 	select FW_LOADER
 	default y
 	help
-- 
1.7.9.5

