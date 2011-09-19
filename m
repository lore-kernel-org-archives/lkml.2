Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454Ab1ISSEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 14:04:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38802 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756283Ab1ISSEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 14:04:36 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/5] regmap: Prototype regcache_sync()
Date: Mon, 19 Sep 2011 19:03:41 +0100
Message-Id: <1316455424-11173-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <1316455424-11173-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20110919175948.GD540@opensource.wolfsonmicro.com>
 <1316455424-11173-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/regmap.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index cae69e6..63b3075 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -140,4 +140,5 @@ int regmap_bulk_read(struct regmap *map, unsigned int reg, void *val,
 int regmap_update_bits(struct regmap *map, unsigned int reg,
 		       unsigned int mask, unsigned int val);
 
+int regcache_sync(struct regmap *map);
 #endif
-- 
1.7.6.3

