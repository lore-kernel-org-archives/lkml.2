Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863Ab2HSAoS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 20:44:18 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:40103 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751134Ab2HSAoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 20:44:15 -0400
Message-ID: <503036DE.20600@xenotime.net>
Date: Sat, 18 Aug 2012 17:44:14 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: fix kernel-doc warnings in drivers/regulator/core.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix regulator kernel-doc warnings:

Warning(drivers/regulator/core.c:2308): No description found for parameter 'rdev'
Warning(drivers/regulator/core.c:2308): Excess function parameter 'regulator' description in 'regulator_set_voltage_time_sel'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc:	Liam Girdwood <lrg@ti.com>
Cc:	Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- lnx-36-rc2.orig/drivers/regulator/core.c
+++ lnx-36-rc2/drivers/regulator/core.c
@@ -2291,8 +2291,8 @@ int regulator_set_voltage_time(struct re
 EXPORT_SYMBOL_GPL(regulator_set_voltage_time);
 
 /**
- *regulator_set_voltage_time_sel - get raise/fall time
- * @regulator: regulator source
+ * regulator_set_voltage_time_sel - get raise/fall time
+ * @rdev: regulator source device
  * @old_selector: selector for starting voltage
  * @new_selector: selector for target voltage
  *
