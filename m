Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab2IJDMk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 23:12:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61187 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074Ab2IJDMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 23:12:39 -0400
From: "G.Shark Jeong" <gshark.jeong@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Richard Purdie <rpurdie@rpsys.net>
Cc: Daniel Jeong <daniel.jeong@ti.com>, <linux-kernel@vger.kernel.org>,
        "G.Shark Jeong" <gshark.jeong@gmail.com>
Subject: [PATCH 2/2] backlight: add new lm3630 backlight driver
Date: Mon, 10 Sep 2012 12:09:40 +0900
Message-Id: <1347246580-28213-1-git-send-email-gshark.jeong@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "G.Shark Jeong" <gshark.jeong@gmail.com>

This driver is a general version for LM3630 backlgiht driver chip of TI.

Put NEW_LEDS and LEDS_CLASS into Kconfig file to reduce additional configuration works in LEDs.

www.ti.com

Signed-off-by: G.Shark Jeong <gshark.jeong@gmail.com>
---
 drivers/video/backlight/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
index b9008b5..2f3646d 100644
--- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -356,6 +356,8 @@ config BACKLIGHT_LM3630
 	tristate "Backlight Driver for LM3630"
 	depends on BACKLIGHT_CLASS_DEVICE && I2C
 	select REGMAP_I2C
+	select NEW_LEDS
+	select LEDS_CLASS
 	help
 	  This supports TI LM3630 Backlight Driver
 
-- 
1.7.5.4

