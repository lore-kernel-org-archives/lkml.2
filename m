Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484Ab2DCMZm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 08:25:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46321 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753415Ab2DCMZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 08:25:40 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Export regcache_sync_region()
Date: Tue,  3 Apr 2012 13:25:37 +0100
Message-Id: <1333455937-5772-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

regcache_sync_region() isn't going to be useful to most drivers if we
don't export it since otherwise they can't use it when built modular.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 87f54db..74b6909 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -346,6 +346,7 @@ out:
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(regcache_sync_region);
 
 /**
  * regcache_cache_only: Put a register map into cache only mode
-- 
1.7.9.1

