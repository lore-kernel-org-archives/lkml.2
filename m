Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933736Ab2JWUFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:05:17 -0400
Received: from smtp.outflux.net ([198.145.64.163]:34351 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933673Ab2JWUFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:06 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>
Subject: [PATCH 068/193] drivers/memstick: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:02:21 -0700
Message-Id: <1351022666-6960-69-git-send-email-keescook@chromium.org>
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

