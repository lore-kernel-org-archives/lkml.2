Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443Ab1HIOfO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 10:35:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36533 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750824Ab1HIOfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 10:35:13 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Fix kerneldoc errors for regmap
Date: Tue,  9 Aug 2011 10:24:49 +0900
Message-Id: <1312853089-25803-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/regmap.h |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index c878a4b..4de137b 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -27,15 +27,15 @@ struct spi_device;
  * @val_bits: Number of bits in a register value, mandatory.
  *
  * @max_register: Optional, specifies the maximum valid register index.
- * @writeable_register: Optional callback returning true if the register
- *                      can be written to.
- * @readable_register: Optional callback returning true if the register
- *                     can be read from.
- * @volatile_register: Optional callback returning true if the register
- *                     value can't be cached.
- * @precious_register: Optional callback returning true if the rgister
- *                     should not be read outside of a call from the driver
- *                     (eg, a clear on read interrupt status register).
+ * @writeable_reg: Optional callback returning true if the register
+ *                 can be written to.
+ * @readable_reg: Optional callback returning true if the register
+ *                can be read from.
+ * @volatile_reg: Optional callback returning true if the register
+ *                value can't be cached.
+ * @precious_reg: Optional callback returning true if the rgister
+ *                should not be read outside of a call from the driver
+ *                (eg, a clear on read interrupt status register).
  */
 struct regmap_config {
 	int reg_bits;
-- 
1.7.5.4

