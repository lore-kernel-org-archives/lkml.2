Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab1JCFyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 01:54:24 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45837 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755145Ab1JCFyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 01:54:18 -0400
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] regmap: Fix doc comment
Date: Mon,  3 Oct 2011 06:54:16 +0100
Message-Id: <1317621256-32476-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 2d55b26..f32c08c 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -291,7 +291,7 @@ EXPORT_SYMBOL_GPL(regcache_cache_only);
  * regcache_cache_bypass: Put a register map into cache bypass mode
  *
  * @map: map to configure
- * @cache_only: flag if changes should not be written to the hardware
+ * @cache_bypass: flag if changes should not be written to the hardware
  *
  * When a register map is marked with the cache bypass option, writes
  * to the register map API will only update the hardware and not the
-- 
1.7.6.4

