Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966868Ab2EOVEa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 17:04:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42678 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966843Ab2EOVDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 17:03:13 -0400
From: mathieu.poirier@linaro.org
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, mathieu.poirier@linaro.org
Subject: [PATCH 5/5] drivers/tosa: driver needs I2C and SPI to compile
Date: Tue, 15 May 2012 15:03:01 -0600
Message-Id: <1337115781-27979-6-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1337115781-27979-1-git-send-email-mathieu.poirier@linaro.org>
References: <1337115781-27979-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

This driver requires both SPI and I2C to build.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/video/backlight/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
index af16884..d7487d2 100644
--- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -88,7 +88,7 @@ config LCD_PLATFORM
 
 config LCD_TOSA
 	tristate "Sharp SL-6000 LCD Driver"
-	depends on SPI && MACH_TOSA
+	depends on I2C && SPI && MACH_TOSA
 	help
 	  If you have an Sharp SL-6000 Zaurus say Y to enable a driver
 	  for its LCD.
-- 
1.7.5.4

