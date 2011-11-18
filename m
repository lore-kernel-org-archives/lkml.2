Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450Ab1KRIQF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 03:16:05 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43121 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab1KRIQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 03:16:04 -0500
From: Zac Storer <zac.3.14159@gmail.com>
To: khali@linux-fr.org
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Zac Storer <zac.3.14159@gmail.com>
Subject: [PATCH 33/33] Drivers: hwmon: adm1031: fixed a coding style issue
Date: Fri, 18 Nov 2011 01:15:58 -0700
Message-Id: <1321604158-13150-1-git-send-email-zac.3.14159@gmail.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style issue.

Signed-off-by: Zac Storer <zac.3.14159@gmail.com>
---
 drivers/hwmon/adm1031.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/adm1031.c b/drivers/hwmon/adm1031.c
index 04e2adc..6e80cf0 100644
--- a/drivers/hwmon/adm1031.c
+++ b/drivers/hwmon/adm1031.c
@@ -175,7 +175,7 @@ static int FAN_TO_REG(int reg, int div)
 
 #define AUTO_TEMP_MIN_TO_REG(val, reg)	\
 	((((val)/500) & 0xf8)|((reg) & 0x7))
-#define AUTO_TEMP_RANGE_FROM_REG(reg)	(5000 * (1<< ((reg)&0x7)))
+#define AUTO_TEMP_RANGE_FROM_REG(reg)	(5000 * (1 << ((reg)&0x7)))
 #define AUTO_TEMP_MIN_FROM_REG(reg)	(1000 * ((((reg) >> 3) & 0x1f) << 2))
 
 #define AUTO_TEMP_MIN_FROM_REG_DEG(reg)	((((reg) >> 3) & 0x1f) << 2)
-- 
1.7.7.3

