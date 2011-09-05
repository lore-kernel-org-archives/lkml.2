Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab1IEUz5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 16:55:57 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43912 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab1IEUzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 16:55:51 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: rpurdie@rpsys.net, linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org
Subject: [PATCH] leds: set LEDS_TRIGGERS as tristate
Date: Tue,  6 Sep 2011 04:55:43 +0800
Message-Id: <1315256143-29396-1-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LEDS_TRIGGERS is depends on LEDS_CLASSS, which should be tristate. So
set it as tristate too.

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 drivers/leds/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 1c35927..0238719 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -387,7 +387,7 @@ config LEDS_ASIC3
 	  period from 62ms to 125s. Say Y to enable LEDs on the HP iPAQ hx4700.
 
 config LEDS_TRIGGERS
-	bool "LED Trigger support"
+	tristate "LED Trigger support"
 	depends on LEDS_CLASS
 	help
 	  This option enables trigger support for the leds class.
-- 
1.7.4.1

