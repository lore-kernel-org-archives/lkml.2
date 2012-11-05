Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933387Ab2KEX0H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:26:07 -0500
Received: from smtp.outflux.net ([198.145.64.163]:45825 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755094Ab2KEXFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:24 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 057/104] drivers/macintosh: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:04:14 -0800
Message-Id: <1352156701-4038-58-git-send-email-keescook@chromium.org>
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

