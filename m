Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492Ab2C2EVc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 00:21:32 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59836 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab2C2EVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 00:21:24 -0400
Message-ID: <1332994877.4275.1.camel@phoenix>
Subject: [PATCH] regulator: Fix comments in include/linux/regulator/machine.h
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Thu, 29 Mar 2012 12:21:17 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 include/linux/regulator/machine.h |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/include/linux/regulator/machine.h b/include/linux/regulator/machine.h
index 7abb160..b021084 100644
--- a/include/linux/regulator/machine.h
+++ b/include/linux/regulator/machine.h
@@ -71,7 +71,7 @@ struct regulator_state {
  * @uV_offset: Offset applied to voltages from consumer to compensate for
  *             voltage drops.
  *
- * @min_uA: Smallest consumers consumers may set.
+ * @min_uA: Smallest current consumers may set.
  * @max_uA: Largest current consumers may set.
  *
  * @valid_modes_mask: Mask of modes which may be configured by consumers.
@@ -134,10 +134,8 @@ struct regulation_constraints {
 /**
  * struct regulator_consumer_supply - supply -> device mapping
  *
- * This maps a supply name to a device.  Only one of dev or dev_name
- * can be specified.  Use of dev_name allows support for buses which
- * make struct device available late such as I2C and is the preferred
- * form.
+ * This maps a supply name to a device. Use of dev_name allows support for
+ * buses which make struct device available late such as I2C.
  *
  * @dev_name: Result of dev_name() for the consumer.
  * @supply: Name for the supply.
-- 
1.7.5.4



