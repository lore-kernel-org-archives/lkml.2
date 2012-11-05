Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933461Ab2KEXKV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:10:21 -0500
Received: from smtp.outflux.net ([198.145.64.163]:33057 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933305Ab2KEXFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:37 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 062/104] drivers/mtd: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:04:19 -0800
Message-Id: <1352156701-4038-63-git-send-email-keescook@chromium.org>
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
 drivers/mtd/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/Kconfig b/drivers/mtd/Kconfig
index 73fcbbe..03f2eb5 100644
--- a/drivers/mtd/Kconfig
+++ b/drivers/mtd/Kconfig
@@ -291,7 +291,7 @@ config SSFDC
 
 config SM_FTL
 	tristate "SmartMedia/xD new translation layer"
-	depends on EXPERIMENTAL && BLOCK
+	depends on BLOCK
 	select MTD_BLKDEVS
 	select MTD_NAND_ECC
 	help
-- 
1.7.9.5

