Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab1I0K0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 06:26:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33293 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753111Ab1I0KZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 06:25:16 -0400
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Liam Girdwood <lrg@ti.com>
Subject: [PATCH 1/5] regmap: Fix signed/unsigned comparison
Date: Tue, 27 Sep 2011 11:25:04 +0100
Message-Id: <1317119108-15338-2-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1317119108-15338-1-git-send-email-dp@opensource.wolfsonmicro.com>
References: <1317119108-15338-1-git-send-email-dp@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache-indexed.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/regmap/regcache-indexed.c b/drivers/base/regmap/regcache-indexed.c
index ff8b44c..268497a 100644
--- a/drivers/base/regmap/regcache-indexed.c
+++ b/drivers/base/regmap/regcache-indexed.c
@@ -41,7 +41,7 @@ static int regcache_indexed_write(struct regmap *map, unsigned int reg,
 
 static int regcache_indexed_sync(struct regmap *map)
 {
-	int i;
+	unsigned int i;
 	int ret;
 
 	for (i = 0; i < map->num_reg_defaults; i++) {
-- 
1.7.6.4

