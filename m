Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965115Ab2JWUm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:42:28 -0400
Received: from smtp.outflux.net ([198.145.64.163]:36332 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933812Ab2JWUF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:29 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: [PATCH 112/193] drivers/pcmcia: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:03:05 -0700
Message-Id: <1351022666-6960-113-git-send-email-keescook@chromium.org>
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

