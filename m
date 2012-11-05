Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932983Ab2KEXTs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:19:48 -0500
Received: from smtp.outflux.net ([198.145.64.163]:36373 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755131Ab2KEXF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:27 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH 056/104] drivers/leds: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:04:13 -0800
Message-Id: <1352156701-4038-57-git-send-email-keescook@chromium.org>
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

CC: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/leds/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index f508def..3ad5f0c 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -154,7 +154,7 @@ config LEDS_HP6XX
 config LEDS_PCA9532
 	tristate "LED driver for PCA9532 dimmer"
 	depends on LEDS_CLASS
-	depends on I2C && INPUT && EXPERIMENTAL
+	depends on I2C && INPUT
 	help
 	  This option enables support for NXP pca9532
 	  LED controller. It is generally only useful
-- 
1.7.9.5

