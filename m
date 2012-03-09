Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab2CIDhh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 22:37:37 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38720 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807Ab2CIDhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 22:37:36 -0500
Message-ID: <1331264250.6239.8.camel@phoenix>
Subject: [PATCH] regulator: tps6524x: Remove unneeded comment for
 N_REGULATORS
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Cyril Chemparathy <cyril@ti.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Fri, 09 Mar 2012 11:37:30 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps6524x-regulator.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/tps6524x-regulator.c b/drivers/regulator/tps6524x-regulator.c
index 70b7b1f..60846e0 100644
--- a/drivers/regulator/tps6524x-regulator.c
+++ b/drivers/regulator/tps6524x-regulator.c
@@ -108,9 +108,7 @@
 #define N_DCDC			3
 #define N_LDO			2
 #define N_SWITCH		2
-#define N_REGULATORS		(3 /* DCDC */ + \
-				 2 /* LDO */  + \
-				 2 /* switch */)
+#define N_REGULATORS		(N_DCDC + N_LDO + N_SWITCH)
 
 #define FIXED_ILIMSEL		BIT(0)
 #define FIXED_VOLTAGE		BIT(1)
-- 
1.7.5.4



