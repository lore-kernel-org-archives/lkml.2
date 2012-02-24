Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab2BXNi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 08:38:26 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47042 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755195Ab2BXNiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 08:38:25 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/3] regmap: Add stub for regcache_sync_region()
Date: Fri, 24 Feb 2012 13:38:22 +0000
Message-Id: <1330090702-22160-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1330090702-22160-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1330090702-22160-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added on another branch.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/regmap.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index c500c64..4cd8035 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -296,6 +296,13 @@ static inline int regcache_sync(struct regmap *map)
 	return -EINVAL;
 }
 
+static inline int regcache_sync_region(struct regmap *map, unsigned int min,
+				       unsigned int max)
+{
+	WARN_ONCE(1, "regmap API is disabled");
+	return -EINVAL;
+}
+
 static inline void regcache_cache_only(struct regmap *map, bool enable)
 {
 	WARN_ONCE(1, "regmap API is disabled");
-- 
1.7.9.1

