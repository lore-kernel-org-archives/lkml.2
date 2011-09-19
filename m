Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396Ab1ISSEk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 14:04:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38804 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756290Ab1ISSEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 14:04:36 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 4/5] regmap: Indentation tweaks in regcache
Date: Mon, 19 Sep 2011 19:03:43 +0100
Message-Id: <1316455424-11173-4-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <1316455424-11173-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20110919175948.GD540@opensource.wolfsonmicro.com>
 <1316455424-11173-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 7806941..e2b172b 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -178,6 +178,7 @@ int regcache_read(struct regmap *map,
 
 	if (!regmap_volatile(map, reg))
 		return map->cache_ops->read(map, reg, value);
+
 	return -EINVAL;
 }
 EXPORT_SYMBOL_GPL(regcache_read);
@@ -204,6 +205,7 @@ int regcache_write(struct regmap *map,
 
 	if (!regmap_volatile(map, reg))
 		return map->cache_ops->write(map, reg, value);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(regcache_write);
-- 
1.7.6.3

