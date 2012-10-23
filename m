Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933760Ab2JWVFd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:05:33 -0400
Received: from smtp.outflux.net ([198.145.64.163]:59887 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933687Ab2JWUFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:11 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Bryan Wu <bryan.wu@canonical.com>,
        Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH 058/193] drivers/leds: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:02:11 -0700
Message-Id: <1351022666-6960-59-git-send-email-keescook@chromium.org>
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

CC: Bryan Wu <bryan.wu@canonical.com>
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

