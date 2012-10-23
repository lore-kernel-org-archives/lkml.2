Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965613Ab2JWVH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:07:27 -0400
Received: from smtp.outflux.net ([198.145.64.163]:48913 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933678Ab2JWUFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:07 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 060/193] drivers/macintosh: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:02:13 -0700
Message-Id: <1351022666-6960-61-git-send-email-keescook@chromium.org>
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

CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/macintosh/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/macintosh/Kconfig b/drivers/macintosh/Kconfig
index a555da6..696238b 100644
--- a/drivers/macintosh/Kconfig
+++ b/drivers/macintosh/Kconfig
@@ -278,7 +278,7 @@ config PMAC_RACKMETER
 
 config SENSORS_AMS
 	tristate "Apple Motion Sensor driver"
-	depends on PPC_PMAC && !PPC64 && INPUT && ((ADB_PMU && I2C = y) || (ADB_PMU && !I2C) || I2C) && EXPERIMENTAL
+	depends on PPC_PMAC && !PPC64 && INPUT && ((ADB_PMU && I2C = y) || (ADB_PMU && !I2C) || I2C)
 	select INPUT_POLLDEV
 	help
 	  Support for the motion sensor included in PowerBooks. Includes
-- 
1.7.9.5

