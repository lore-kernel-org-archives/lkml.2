Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158Ab2J2Ieu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 04:34:50 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53892 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758121Ab2J2Ieo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 04:34:44 -0400
Message-ID: <1351499678.14725.3.camel@phoenix>
Subject: [PATCH] hwmon: da9055: Fix chan_mux[DA9055_ADC_ADCIN3] setting
From: Axel Lin <axel.lin@ingics.com>
To: Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>
Cc: David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Date: Mon, 29 Oct 2012 16:34:38 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set chan_mux[DA9055_ADC_ADCIN3] = DA9055_ADC_MUX_ADCIN3.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
Hi,
  This looks like a typo, but I don't have a hardware to test it.
Axel
 drivers/hwmon/da9055-hwmon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/da9055-hwmon.c b/drivers/hwmon/da9055-hwmon.c
index 0b41f2c..3a3377c 100644
--- a/drivers/hwmon/da9055-hwmon.c
+++ b/drivers/hwmon/da9055-hwmon.c
@@ -54,7 +54,7 @@ static const u8 chan_mux[DA9055_ADC_TJUNC + 1] = {
 	[DA9055_ADC_VSYS]	= DA9055_ADC_MUX_VSYS,
 	[DA9055_ADC_ADCIN1]	= DA9055_ADC_MUX_ADCIN1,
 	[DA9055_ADC_ADCIN2]	= DA9055_ADC_MUX_ADCIN2,
-	[DA9055_ADC_ADCIN3]	= DA9055_ADC_MUX_ADCIN1,
+	[DA9055_ADC_ADCIN3]	= DA9055_ADC_MUX_ADCIN3,
 	[DA9055_ADC_TJUNC]	= DA9055_ADC_MUX_T_SENSE,
 };
 
-- 
1.7.9.5



