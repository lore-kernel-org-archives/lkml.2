Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346Ab0HNOb5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 10:31:57 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58208 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757271Ab0HNOb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 10:31:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=xafkvMKfoHMNa2tLRpPZ92P7fd7y6iLjwJystHlCsvh4LT6at9Cvdi5pB0Z0JCuMEa
         RdtyAdUt08nLVYo5eLUwuEqtWHJVX8P8hcRSmEgVw88VSdFFeg9jiq+ibbxkUtnpXc+3
         GgeRcGnKPTpm0oXgdgPZJNd/FvDW1bowSdAjE=
Subject: [PATCH] regulator: tps6507x - remove incorrect comments
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Anuj Aggarwal <anuj.aggarwal@ti.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 14 Aug 2010 22:32:13 +0800
Message-ID: <1281796333.3780.4.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver is a platform driver, not a i2c driver.
Thus remove incorrect tps6507x_remove comments.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps6507x-regulator.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/tps6507x-regulator.c b/drivers/regulator/tps6507x-regulator.c
index c239f42..020f587 100644
--- a/drivers/regulator/tps6507x-regulator.c
+++ b/drivers/regulator/tps6507x-regulator.c
@@ -626,12 +626,6 @@ fail:
 	return error;
 }
 
-/**
- * tps6507x_remove - TPS6507x driver i2c remove handler
- * @client: i2c driver client device structure
- *
- * Unregister TPS driver as an i2c client device driver
- */
 static int __devexit tps6507x_pmic_remove(struct platform_device *pdev)
 {
 	struct tps6507x_dev *tps6507x_dev = platform_get_drvdata(pdev);
-- 
1.7.0.4



