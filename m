Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab2ENJFj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 05:05:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57858 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754925Ab2ENJFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 05:05:38 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Export regmap_reinit_cache()
Date: Mon, 14 May 2012 10:05:35 +0100
Message-Id: <1336986335-31279-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's supposed to be there for drivers.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 0bcda48..cc45886 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -471,6 +471,7 @@ int regmap_reinit_cache(struct regmap *map, const struct regmap_config *config)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(regmap_reinit_cache);
 
 /**
  * regmap_exit(): Free a previously allocated register map
-- 
1.7.10

