Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318Ab1KCRI5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 13:08:57 -0400
Received: from mail.fuel7.com ([74.222.0.51]:59274 "EHLO mail.fuel7.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027Ab1KCRIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 13:08:25 -0400
From: Kyle Manna <kyle.manna@fuel7.com>
To: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Cc: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Kyle Manna <kyle.manna@fuel7.com>
Subject: [PATCH v3 4/6] mfd: TPS65910: Move linux/gpio.h include to header
Date: Thu,  3 Nov 2011 12:08:04 -0500
Message-Id: <1320340086-15371-5-git-send-email-kyle.manna@fuel7.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1320340086-15371-1-git-send-email-kyle.manna@fuel7.com>
References: <1320340086-15371-1-git-send-email-kyle.manna@fuel7.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tps65910.h file depends on linux/gpio.h.  Move the include from the
source file to the tps65910.h header file.

Signed-off-by: Kyle Manna <kyle.manna@fuel7.com>
---
 drivers/mfd/tps65910.c       |    1 -
 include/linux/mfd/tps65910.h |    3 +++
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index 87cb3c9..f48a4ae 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -18,7 +18,6 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
-#include <linux/gpio.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/tps65910.h>
 
diff --git a/include/linux/mfd/tps65910.h b/include/linux/mfd/tps65910.h
index 399d80a..503ded3 100644
--- a/include/linux/mfd/tps65910.h
+++ b/include/linux/mfd/tps65910.h
@@ -17,6 +17,9 @@
 #ifndef __LINUX_MFD_TPS65910_H
 #define __LINUX_MFD_TPS65910_H
 
+#include <linux/gpio.h>
+#include <linux/regulator/machine.h>
+
 /* TPS chip id list */
 #define TPS65910			0
 #define TPS65911			1
-- 
1.7.5.4

