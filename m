Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab2FERN5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 13:13:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40019 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753467Ab2FERNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 13:13:55 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] MAINTAINERS: Add Wolfson gpiolib drivers to the Wolfson entry
Date: Tue,  5 Jun 2012 18:13:53 +0100
Message-Id: <1338916433-4062-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7b51a06..dfc2074 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7577,6 +7577,7 @@ F:	Documentation/hwmon/wm83??
 F:	arch/arm/mach-s3c64xx/mach-crag6410*
 F:	drivers/clk/clk-wm83*.c
 F:	drivers/leds/leds-wm83*.c
+F:	drivers/gpio/gpio-*wm*.c
 F:	drivers/hwmon/wm83??-hwmon.c
 F:	drivers/input/misc/wm831x-on.c
 F:	drivers/input/touchscreen/wm831x-ts.c
-- 
1.7.10

