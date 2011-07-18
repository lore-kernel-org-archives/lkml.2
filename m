Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864Ab1GRDCb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 23:02:31 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:32937 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab1GRDCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 23:02:30 -0400
Subject: [PATCH] regulator: tps65912: Remove unused define of
 TPS65912_MAX_REG_ID
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Margarita Olaya Cabrera <magi@slimlogic.co.uk>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jul 2011 11:02:17 +0800
Message-ID: <1310958137.23337.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we define TPS65912_MAX_REG_ID as TPS65912_REG_LDO_10,
but TPS65912_REG_LDO_10 is not defined at all.
( It looks like a typo of TPS65912_REG_LDO10 )
Currently, TPS65912_MAX_REG_ID is not used in this driver,
it is safe to just remove it.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps65912-regulator.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/tps65912-regulator.c b/drivers/regulator/tps65912-regulator.c
index 3a9313e..39d4a17 100644
--- a/drivers/regulator/tps65912-regulator.c
+++ b/drivers/regulator/tps65912-regulator.c
@@ -43,8 +43,6 @@
 #define TPS65912_REG_LDO9	12
 #define TPS65912_REG_LDO10	13
 
-#define TPS65912_MAX_REG_ID	TPS65912_REG_LDO_10
-
 /* Number of step-down converters available */
 #define TPS65912_NUM_DCDC	4
 
-- 
1.7.4.1



