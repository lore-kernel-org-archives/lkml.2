Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307Ab2HYG5J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 02:57:09 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49972 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab2HYG47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 02:56:59 -0400
Message-ID: <1345877808.6369.1.camel@phoenix>
Subject: [PATCH] regulator: max8907: Add MODULE_ALIAS
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Gyungoh Yoo <jack.yoo@maxim-ic.com>,
        Stephen Warren <swarren@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Date: Sat, 25 Aug 2012 14:56:48 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver can be built as a module, add MODULE_ALIAS for it.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8907-regulator.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/max8907-regulator.c b/drivers/regulator/max8907-regulator.c
index 3a5104f..19c765a 100644
--- a/drivers/regulator/max8907-regulator.c
+++ b/drivers/regulator/max8907-regulator.c
@@ -402,3 +402,4 @@ module_exit(max8907_reg_exit);
 MODULE_DESCRIPTION("MAX8907 regulator driver");
 MODULE_AUTHOR("Gyungoh Yoo <jack.yoo@maxim-ic.com>");
 MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:max8907-regulator");
-- 
1.7.9.5



