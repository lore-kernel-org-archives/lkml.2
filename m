Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070Ab0K3BM7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 20:12:59 -0500
Received: from mail.perches.com ([173.55.12.10]:1992 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755812Ab0K3BM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 20:12:58 -0500
From: Joe Perches <joe@perches.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] regulator: Rename rdev_debug to rdev_dbg
Date: Mon, 29 Nov 2010 17:12:56 -0800
Message-Id: <3c50480be4c6fe95a01d79e3c95fba0d9175a81b.1291079473.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.2.245.g03276.dirty
In-Reply-To: <20101129220046.GB8335@opensource.wolfsonmicro.com>
References: <20101129220046.GB8335@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just to please broonie...

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/regulator/core.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index ad1999b..bc841b8 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -38,7 +38,7 @@
 	pr_warn("%s: " fmt, rdev_get_name(rdev), ##__VA_ARGS__)
 #define rdev_info(rdev, fmt, ...)					\
 	pr_info("%s: " fmt, rdev_get_name(rdev), ##__VA_ARGS__)
-#define rdev_debug(rdev, fmt, ...)					\
+#define rdev_dbg(rdev, fmt, ...)					\
 	pr_debug("%s: " fmt, rdev_get_name(rdev), ##__VA_ARGS__)
 
 static DEFINE_MUTEX(regulator_list_mutex);
@@ -792,13 +792,13 @@ static int machine_constraints_voltage(struct regulator_dev *rdev,
 
 		/* use regulator's subset of machine constraints */
 		if (constraints->min_uV < min_uV) {
-			rdev_debug(rdev, "override min_uV, %d -> %d\n",
-				   constraints->min_uV, min_uV);
+			rdev_dbg(rdev, "override min_uV, %d -> %d\n",
+				 constraints->min_uV, min_uV);
 			constraints->min_uV = min_uV;
 		}
 		if (constraints->max_uV > max_uV) {
-			rdev_debug(rdev, "override max_uV, %d -> %d\n",
-				   constraints->max_uV, max_uV);
+			rdev_dbg(rdev, "override max_uV, %d -> %d\n",
+				 constraints->max_uV, max_uV);
 			constraints->max_uV = max_uV;
 		}
 	}
-- 
1.7.3.2.245.g03276.dirty

