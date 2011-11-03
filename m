Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933103Ab1KCRJw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 13:09:52 -0400
Received: from mail.fuel7.com ([74.222.0.51]:59266 "EHLO mail.fuel7.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040Ab1KCRIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 13:08:24 -0400
From: Kyle Manna <kyle.manna@fuel7.com>
To: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Cc: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Kyle Manna <kyle.manna@fuel7.com>
Subject: [PATCH v3 3/6] mfd: TPS65910: Fix typo that clobbers genirq
Date: Thu,  3 Nov 2011 12:08:03 -0500
Message-Id: <1320340086-15371-4-git-send-email-kyle.manna@fuel7.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1320340086-15371-1-git-send-email-kyle.manna@fuel7.com>
References: <1320340086-15371-1-git-send-email-kyle.manna@fuel7.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a typo that clobbers other interrupts in an unobvious way.

Signed-off-by: Kyle Manna <kyle.manna@fuel7.com>
---
 drivers/mfd/tps65910.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index 0d9c3eb..87cb3c9 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -177,7 +177,7 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
 		goto err2;
 
 	init_data->irq = pmic_plat_data->irq;
-	init_data->irq_base = pmic_plat_data->irq;
+	init_data->irq_base = pmic_plat_data->irq_base;
 
 	tps65910_gpio_init(tps65910, pmic_plat_data->gpio_base);
 
-- 
1.7.5.4

