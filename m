Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222Ab3ACNB6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 08:01:58 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:64636 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab3ACNB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 08:01:56 -0500
Message-ID: <1357218107.4914.1.camel@phoenix>
Subject: [PATCH] regulator: core: Fix comment for regulator_register()
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Date: Thu, 03 Jan 2013 21:01:47 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

regulator_register() does not return 0 on success, fix the comment.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 9afcdda3..861cda1 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3337,7 +3337,8 @@ static void rdev_init_debugfs(struct regulator_dev *rdev)
  * @config: runtime configuration for regulator
  *
  * Called by regulator drivers to register a regulator.
- * Returns 0 on success.
+ * Returns a valid pointer to struct regulator_dev on success
+ * or an ERR_PTR() on error.
  */
 struct regulator_dev *
 regulator_register(const struct regulator_desc *regulator_desc,
-- 
1.7.9.5



