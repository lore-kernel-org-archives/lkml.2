Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933915Ab2JWUHf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:07:35 -0400
Received: from smtp.outflux.net ([198.145.64.163]:42887 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933606Ab2JWUHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:07:33 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 072/193] drivers/mtd: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:02:25 -0700
Message-Id: <1351022666-6960-73-git-send-email-keescook@chromium.org>
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

