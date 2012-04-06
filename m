Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075Ab2DFFiv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 01:38:51 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4845 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab2DFFiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 01:38:50 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 05 Apr 2012 22:38:50 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: lrg@ti.com, broonie@opensource.wolfsonmicro.com, paul.gortmaker@gmail.com
Cc: linux-kernel@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] regulator: rc5t583: Correct MODULE LICENSE to GPL v2
Date: Fri,  6 Apr 2012 10:58:33 +0530
Message-Id: <1333690113-8341-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing build issue reported by Paul Gortmaker:

It appears this breaks linux-next allmodconfig build, because it
uses an uppercase V in the v2 of its MODULE_LICENSE.

FATAL: modpost: GPL-incompatible module rc5t583-regulator.ko uses
GPL-only symbol 'platform_driver_unregister'
make[2]: *** [__modpost] Error 1

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/regulator/rc5t583-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/rc5t583-regulator.c b/drivers/regulator/rc5t583-regulator.c
index 578bd5d..442106a 100755
--- a/drivers/regulator/rc5t583-regulator.c
+++ b/drivers/regulator/rc5t583-regulator.c
@@ -361,4 +361,4 @@ module_exit(rc5t583_regulator_exit);
 MODULE_AUTHOR("Laxman Dewangan <ldewangan@nvidia.com>");
 MODULE_DESCRIPTION("RC5T583 regulator driver");
 MODULE_ALIAS("platform:rc5t583-regulator");
-MODULE_LICENSE("GPL V2");
+MODULE_LICENSE("GPL v2");
-- 
1.7.1.1

