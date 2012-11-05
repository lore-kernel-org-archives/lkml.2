Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933410Ab2KEXKS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:10:18 -0500
Received: from smtp.outflux.net ([198.145.64.163]:33830 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933308Ab2KEXFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:37 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 063/104] drivers/mtd/chips: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:04:20 -0800
Message-Id: <1352156701-4038-64-git-send-email-keescook@chromium.org>
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

CC: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/mtd/chips/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/chips/Kconfig b/drivers/mtd/chips/Kconfig
index e469b01..c219e3d 100644
--- a/drivers/mtd/chips/Kconfig
+++ b/drivers/mtd/chips/Kconfig
@@ -225,7 +225,7 @@ config MTD_ABSENT
 
 config MTD_XIP
 	bool "XIP aware MTD support"
-	depends on !SMP && (MTD_CFI_INTELEXT || MTD_CFI_AMDSTD) && EXPERIMENTAL && ARCH_MTD_XIP
+	depends on !SMP && (MTD_CFI_INTELEXT || MTD_CFI_AMDSTD) && ARCH_MTD_XIP
 	default y if XIP_KERNEL
 	help
 	  This allows MTD support to work with flash memory which is also
-- 
1.7.9.5

