Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab1LHNeL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 08:34:11 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62395 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab1LHNeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 08:34:05 -0500
Message-ID: <1323351217.3398.0.camel@phoenix>
Subject: [PATCH] hwmon: jz4740: Staticise jz4740_hwmon_driver
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lars-Peter Clausen <lars@metafoo.de>, Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>, lm-sensors@lm-sensors.org
Date: Thu, 08 Dec 2011 21:33:37 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not used outside this driver so no need to make the symbol global.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/hwmon/jz4740-hwmon.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/jz4740-hwmon.c b/drivers/hwmon/jz4740-hwmon.c
index 3d7e590..5253d23 100644
--- a/drivers/hwmon/jz4740-hwmon.c
+++ b/drivers/hwmon/jz4740-hwmon.c
@@ -203,7 +203,7 @@ static int __devexit jz4740_hwmon_remove(struct platform_device *pdev)
 	return 0;
 }
 
-struct platform_driver jz4740_hwmon_driver = {
+static struct platform_driver jz4740_hwmon_driver = {
 	.probe	= jz4740_hwmon_probe,
 	.remove = __devexit_p(jz4740_hwmon_remove),
 	.driver = {
-- 
1.7.5.4



