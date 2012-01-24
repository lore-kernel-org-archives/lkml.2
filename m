Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271Ab2AXLRa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 06:17:30 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55578 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755909Ab2AXLR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 06:17:28 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Fix documentation for of_node parameter of regulator_register()
Date: Tue, 24 Jan 2012 11:17:26 +0000
Message-Id: <1327403846-6108-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 5bc75a (kernel-doc: fix new warning in regulator core) added
documentation for of_node to address a warning but the documentation
didn't explain what the parameter is for so would be likely to be
unhelpful for users.  Clarify that.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index dab8516..aa51866 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2839,7 +2839,8 @@ static void rdev_init_debugfs(struct regulator_dev *rdev)
  * @dev: struct device for the regulator
  * @init_data: platform provided init data, passed through by driver
  * @driver_data: private regulator data
- * @of_node: target open firmware device structure (may be NULL)
+ * @of_node: OpenFirmware node to parse for device tree bindings (may be
+ *           NULL).
  *
  * Called by regulator drivers to register a regulator.
  * Returns 0 on success.
-- 
1.7.7.3

