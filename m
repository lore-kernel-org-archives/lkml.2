Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab1FIPGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 11:06:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47072 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752458Ab1FIPGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 11:06:42 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Add rdev_crit() macro
Date: Thu,  9 Jun 2011 16:06:37 +0100
Message-Id: <1307631997-32061-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No actual users but provide the macro so there's less surprise when it's
not there.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 47bf85d..f5e4665 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -34,6 +34,8 @@
 
 #include "dummy.h"
 
+#define rdev_crit(rdev, fmt, ...)					\
+	pr_crit("%s: " fmt, rdev_get_name(rdev), ##__VA_ARGS__)
 #define rdev_err(rdev, fmt, ...)					\
 	pr_err("%s: " fmt, rdev_get_name(rdev), ##__VA_ARGS__)
 #define rdev_warn(rdev, fmt, ...)					\
-- 
1.7.5.3

