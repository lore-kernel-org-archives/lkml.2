Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965692Ab2JWVNb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:13:31 -0400
Received: from smtp.outflux.net ([198.145.64.163]:39952 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933648Ab2JWUFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:02 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>
Subject: [PATCH 052/193] drivers/idle: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:02:05 -0700
Message-Id: <1351022666-6960-53-git-send-email-keescook@chromium.org>
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

