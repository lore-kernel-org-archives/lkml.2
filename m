Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab2IES1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 14:27:21 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61440 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114Ab2IES1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 14:27:19 -0400
From: Luis Gonzalez Fernandez <luisgf@gmail.com>
To: sameo@linux.intel.com, linux-kernel@vger.kernel.org
Cc: Luis Gonzalez Fernandez <luisgf@gmail.com>
Subject: [PATCH 1/1] mfd: Remove unused variable 'desc'
Date: Wed,  5 Sep 2012 20:27:08 +0200
Message-Id: <1346869628-21531-1-git-send-email-luisgf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused variable 'desc' in da9052_device_init() function that
throws warnings during compilation.

./linux-3.6/drivers/mfd/da9052-core.c: In function ‘da9052_device_init’:
./linux-3.6/drivers/mfd/da9052-core.c:775:19: warning: unused variable ‘desc’ [-Wunused-variable]

Signed-off-by: Luis Gonzalez Fernandez <luisgf@gmail.com>
---
 drivers/mfd/da9052-core.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mfd/da9052-core.c b/drivers/mfd/da9052-core.c
index 1f1313c..2544910 100644
--- a/drivers/mfd/da9052-core.c
+++ b/drivers/mfd/da9052-core.c
@@ -772,7 +772,6 @@ EXPORT_SYMBOL_GPL(da9052_regmap_config);
 int __devinit da9052_device_init(struct da9052 *da9052, u8 chip_id)
 {
 	struct da9052_pdata *pdata = da9052->dev->platform_data;
-	struct irq_desc *desc;
 	int ret;
 
 	mutex_init(&da9052->auxadc_lock);
-- 
1.7.9.5

