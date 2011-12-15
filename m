Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369Ab1LOGyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 01:54:15 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42625 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932261Ab1LOGyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 01:54:14 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        David Dajun Chen <dchen@diasemi.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Declare da9052_regmap_config for the bus drivers
Date: Thu, 15 Dec 2011 14:54:09 +0800
Message-Id: <1323932049-24300-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes build failures.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/mfd/da9052/da9052.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/mfd/da9052/da9052.h b/include/linux/mfd/da9052/da9052.h
index c8899ab..5702d1b 100644
--- a/include/linux/mfd/da9052/da9052.h
+++ b/include/linux/mfd/da9052/da9052.h
@@ -126,4 +126,6 @@ static inline int da9052_reg_update(struct da9052 *da9052, unsigned char reg,
 int da9052_device_init(struct da9052 *da9052, u8 chip_id);
 void da9052_device_exit(struct da9052 *da9052);
 
+extern struct regmap_config da9052_regmap_config;
+
 #endif /* __MFD_DA9052_DA9052_H */
-- 
1.7.7.3

