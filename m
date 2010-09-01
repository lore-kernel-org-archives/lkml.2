Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460Ab0IARJ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 13:09:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42494 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753194Ab0IARJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 13:09:56 -0400
Subject: [PATCH] wm831x_power: Removed duplicate mask from wm831x power
 driver
From: Ian Lartey <ian@opensource.wolfsonmicro.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Julia Lawall <julia@diku.dk>,
        Wolfson Patches <patches@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Sep 2010 18:09:27 +0100
Message-ID: <1283360967.1831.239.camel@Tapajos>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Ian Lartey <ian@opensource.wolfsonmicro.com>
---
 drivers/power/wm831x_power.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/power/wm831x_power.c b/drivers/power/wm831x_power.c
index fbcc36d..a57a941 100644
--- a/drivers/power/wm831x_power.c
+++ b/drivers/power/wm831x_power.c
@@ -267,7 +267,6 @@ static void wm831x_config_battery(struct wm831x *wm831x)
 	ret = wm831x_set_bits(wm831x, WM831X_CHARGER_CONTROL_1,
 			      WM831X_CHG_ENA_MASK |
 			      WM831X_CHG_FAST_MASK |
-			      WM831X_CHG_ITERM_MASK |
 			      WM831X_CHG_ITERM_MASK,
 			      reg1);
 	if (ret != 0)
-- 
1.7.0.4



