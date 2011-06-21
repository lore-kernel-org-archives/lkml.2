Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab1FUMIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 08:08:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37764 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751559Ab1FUMIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 08:08:50 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/3] power_supply: Fix annotation for s3c_adc_battery_probe()
Date: Tue, 21 Jun 2011 13:08:43 +0100
Message-Id: <1308658125-25013-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A probe() function is used at device init time rather than system init time.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/power/s3c_adc_battery.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/power/s3c_adc_battery.c b/drivers/power/s3c_adc_battery.c
index d36c289..a675e31 100644
--- a/drivers/power/s3c_adc_battery.c
+++ b/drivers/power/s3c_adc_battery.c
@@ -266,7 +266,7 @@ static irqreturn_t s3c_adc_bat_charged(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static int __init s3c_adc_bat_probe(struct platform_device *pdev)
+static int __devinit s3c_adc_bat_probe(struct platform_device *pdev)
 {
 	struct s3c_adc_client	*client;
 	struct s3c_adc_bat_pdata *pdata = pdev->dev.platform_data;
-- 
1.7.5.4

