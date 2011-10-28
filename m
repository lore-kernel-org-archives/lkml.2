Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933491Ab1J1Vq6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 17:46:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59254 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933414Ab1J1Vqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 17:46:47 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Fix typo in kerneldoc for regmap_update_bits()
Date: Fri, 28 Oct 2011 23:46:44 +0200
Message-Id: <1319838404-29296-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 3aca18d..f7cfff2 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -549,7 +549,7 @@ int regmap_bulk_read(struct regmap *map, unsigned int reg, void *val,
 EXPORT_SYMBOL_GPL(regmap_bulk_read);
 
 /**
- * remap_update_bits: Perform a read/modify/write cycle on the register map
+ * regmap_update_bits: Perform a read/modify/write cycle on the register map
  *
  * @map: Register map to update
  * @reg: Register to update
-- 
1.7.6.3

