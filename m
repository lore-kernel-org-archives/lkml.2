Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756994Ab1GKAxv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 20:53:51 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:55894 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756977Ab1GKAxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 20:53:46 -0400
Subject: [PATCH] gpio: da9052: remove a redundant assignment for
 gpio->da9052
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Dajun Chen <dchen@diasemi.com>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Jul 2011 08:53:38 +0800
Message-ID: <1310345618.2316.0.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We just set it twice in da9052_gpio_probe.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/gpio/gpio-da9052.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpio-da9052.c b/drivers/gpio/gpio-da9052.c
index c23761f..038f5eb 100644
--- a/drivers/gpio/gpio-da9052.c
+++ b/drivers/gpio/gpio-da9052.c
@@ -219,7 +219,6 @@ static int __devinit da9052_gpio_probe(struct platform_device *pdev)
 	gpio->da9052 = dev_get_drvdata(pdev->dev.parent);
 	pdata = gpio->da9052->dev->platform_data;
 
-	gpio->da9052 = dev_get_drvdata(pdev->dev.parent);
 	gpio->gp = reference_gp;
 	if (pdata && pdata->gpio_base)
 		gpio->gp.base = pdata->gpio_base;
-- 
1.7.4.1



