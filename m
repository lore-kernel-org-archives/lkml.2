Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab1L1MtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 07:49:18 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55933 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753507Ab1L1MtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 07:49:16 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Export regulator_is_supported_voltage()
Date: Wed, 28 Dec 2011 12:49:13 +0000
Message-Id: <1325076553-18962-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's part of the driver interface so should be available to modules.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index dbdebed6..6f7d411 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1787,6 +1787,7 @@ int regulator_is_supported_voltage(struct regulator *regulator,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(regulator_is_supported_voltage);
 
 static int _regulator_do_set_voltage(struct regulator_dev *rdev,
 				     int min_uV, int max_uV)
-- 
1.7.7.3

