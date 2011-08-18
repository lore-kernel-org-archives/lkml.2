Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab1HRKON (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 06:14:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51368 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755449Ab1HRKOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 06:14:12 -0400
Subject: [PATCH] Added #include of module.h to s3c_adc_battery.c
From: Ian <ian@opensource.wolfsonmicro.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>, u.kleine-koenig@pengutronix.de,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Vasily Khoruzhick <anarsoul@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Aug 2011 11:14:09 +0100
Message-ID: <1313662449.18176.18.camel@Tapajos>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s3c_adc_battery.c will not compile without moule.h as it contains the
definitions of: MODULE_AUTHOR, MODULE_DESCRIPTION & MODULE_LICENSE.


Signed-off-by: Ian Lartey <ian@opensource.wolfsonmicro.com>
---
 drivers/power/s3c_adc_battery.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/power/s3c_adc_battery.c b/drivers/power/s3c_adc_battery.c
index a675e31..20770ba 100644
--- a/drivers/power/s3c_adc_battery.c
+++ b/drivers/power/s3c_adc_battery.c
@@ -9,6 +9,7 @@
  *
  */
 
+#include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
 #include <linux/power_supply.h>
-- 
1.7.4.1





