Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759674Ab2FHWZZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 18:25:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51399 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756092Ab2FHWZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 18:25:00 -0400
From: mathieu.poirier@linaro.org
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, mathieu.poirier@linaro.org
Subject: [PATCH RESEND 6/6] drivers/tosa: driver needs I2C and SPI to compile
Date: Fri,  8 Jun 2012 16:24:40 -0600
Message-Id: <1339194280-27475-7-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1339194280-27475-1-git-send-email-mathieu.poirier@linaro.org>
References: <1339194280-27475-1-git-send-email-mathieu.poirier@linaro.org>
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
index fa2b037..2979292 100644
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

