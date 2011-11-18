Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848Ab1KRGLP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 01:11:15 -0500
Received: from mail-gy0-f179.google.com ([209.85.160.179]:59707 "EHLO
	mail-gy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851Ab1KRGLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 01:11:14 -0500
X-Greylist: delayed 459 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Nov 2011 01:10:49 EST
From: Zac Storer <zac.3.14159@gmail.com>
To: khali@linux-fr.org
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Zac Storer <zac.3.14159@gmail.com>
Subject: [PATCH 32/32] Drivers: hwmon: adm1031: fixed a brace coding style issue
Date: Thu, 17 Nov 2011 23:11:09 -0700
Message-Id: <1321596670-11365-1-git-send-email-zac.3.14159@gmail.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a brace coding style issue.

Signed-off-by: Zac Storer <zac.3.14159@gmail.com>
---
 drivers/hwmon/adm1031.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/adm1031.c b/drivers/hwmon/adm1031.c
index 0683e6b..04e2adc 100644
--- a/drivers/hwmon/adm1031.c
+++ b/drivers/hwmon/adm1031.c
@@ -299,7 +299,7 @@ set_fan_auto_channel(struct device *dev, struct device_attribute *attr,
 	data->conf1 = FAN_CHAN_TO_REG(reg, data->conf1);
 	if ((data->conf1 & ADM1031_CONF1_AUTO_MODE) ^
 	    (old_fan_mode & ADM1031_CONF1_AUTO_MODE)) {
-		if (data->conf1 & ADM1031_CONF1_AUTO_MODE){
+		if (data->conf1 & ADM1031_CONF1_AUTO_MODE) {
 			/* Switch to Auto Fan Mode
 			 * Save PWM registers
 			 * Set PWM registers to 33% Both */
-- 
1.7.7.3

