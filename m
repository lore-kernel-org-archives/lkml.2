Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab2KWPrh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 10:47:37 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35858 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230Ab2KWPrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 10:47:35 -0500
Message-ID: <1353685636.3260.1.camel@phoenix>
Subject: [PATCH] regulator: tps65090: Add MODULE_ALIAS
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Venu Byravarasu <vbyravarasu@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 23 Nov 2012 23:47:16 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver can be built as a module, add MODULE_ALIAS for it.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/tps65090-regulator.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/tps65090-regulator.c b/drivers/regulator/tps65090-regulator.c
index 3974a99..41c3917 100644
--- a/drivers/regulator/tps65090-regulator.c
+++ b/drivers/regulator/tps65090-regulator.c
@@ -269,3 +269,4 @@ module_exit(tps65090_regulator_exit);
 MODULE_DESCRIPTION("tps65090 regulator driver");
 MODULE_AUTHOR("Venu Byravarasu <vbyravarasu@nvidia.com>");
 MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:tps65090-pmic");
-- 
1.7.9.5



