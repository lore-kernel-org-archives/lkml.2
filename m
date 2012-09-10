Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756313Ab2IJDSe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 23:18:34 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52362 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074Ab2IJDSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 23:18:23 -0400
From: "G.Shark Jeong" <gshark.jeong@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Richard Purdie <rpurdie@rpsys.net>
Cc: Daniel Jeong <daniel.jeong@ti.com>, <linux-kernel@vger.kernel.org>,
        "G.Shark Jeong" <gshark.jeong@gmail.com>
Subject: [PATCH 2/2] backlight: add new lm3639 backlight driver
Date: Mon, 10 Sep 2012 12:16:04 +0900
Message-Id: <1347246964-28332-1-git-send-email-gshark.jeong@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "G.Shark Jeong" <gshark.jeong@gmail.com>

This driver is a general version for LM3639 backlgiht driver chip of TI.

Put NEW_LEDS and LEDS_CLASS into Kconfig file to reduce additional configuration works in LEDs.

www.ti.com

Signed-off-by: G.Shark Jeong <gshark.jeong@gmail.com>
---
 drivers/video/backlight/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
index 2ed68bd..e6c78cd 100644
--- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -356,6 +356,8 @@ config BACKLIGHT_LM3639
 	tristate "Backlight Driver for LM3639"
 	depends on BACKLIGHT_CLASS_DEVICE && I2C
 	select REGMAP_I2C
+	select NEW_LEDS
+	select LEDS_CLASS
 	help
 	  This supports TI LM3639 Backlight + 1.5A Flash LED Driver
 
-- 
1.7.5.4

