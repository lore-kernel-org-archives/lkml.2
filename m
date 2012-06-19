Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab2FSH3F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 03:29:05 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57900 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab2FSH3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 03:29:03 -0400
Message-ID: <1340090932.13155.0.camel@phoenix>
Subject: [PATCH] regulator: core: Export regulator_set_voltage_time_sel()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Yadwinder Singh Brar <yadi.brar01@gmail.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 19 Jun 2012 15:28:52 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
This patch is on top of the patch  I sent earlier today:
[PATCH RFC] regulator: Use list_voltage() to get voltage in regulator_set_voltage_time_sel
http://www.kernelhub.org/?msg=86323&p=2

 drivers/regulator/core.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index e207b21..bda74fd 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2332,6 +2332,7 @@ int regulator_set_voltage_time_sel(struct regulator_dev *rdev,
 
 	return DIV_ROUND_UP(abs(new_volt - old_volt), ramp_delay);
 }
+EXPORT_SYMBOL_GPL(regulator_set_voltage_time_sel);
 
 /**
  * regulator_sync_voltage - re-apply last regulator output voltage
-- 
1.7.9.5



