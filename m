Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab1AUP5A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 10:57:00 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59114 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892Ab1AUP47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 10:56:59 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: John Stultz <john.stultz@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH] RTC: remove Kconfig symbol for UIE emulation
Date: Fri, 21 Jan 2011 16:56:46 +0100
Message-Id: <1295625406-15340-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1290136329-18291-5-git-send-email-john.stultz@linaro.org>
References: <1290136329-18291-5-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The effect of changing the value of this symbol is gone since

	042620a (RTC: Remove UIE emulation)

so remove symbol, too.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/rtc/Kconfig |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 4941cad..cdd9719 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -97,18 +97,6 @@ config RTC_INTF_DEV
 
 	  If unsure, say Y.
 
-config RTC_INTF_DEV_UIE_EMUL
-	bool "RTC UIE emulation on dev interface"
-	depends on RTC_INTF_DEV
-	help
-	  Provides an emulation for RTC_UIE if the underlying rtc chip
-	  driver does not expose RTC_UIE ioctls. Those requests generate
-	  once-per-second update interrupts, used for synchronization.
-
-	  The emulation code will read the time from the hardware
-	  clock several times per second, please enable this option
-	  only if you know that you really need it.
-
 config RTC_DRV_TEST
 	tristate "Test driver/device"
 	help
-- 
1.7.2.3

