Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933126Ab1JXRHm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 13:07:42 -0400
Received: from mail.fuel7.com ([74.222.0.51]:42634 "EHLO mail.fuel7.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933055Ab1JXRGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 13:06:32 -0400
From: Kyle Manna <kyle.manna@fuel7.com>
To: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Cc: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Kyle Manna <kyle.manna@fuel7.com>
Subject: [PATCH v2 2/6] mfd: TPS65910: Add I2C slave address macros
Date: Mon, 24 Oct 2011 12:06:00 -0500
Message-Id: <1319475964-10841-3-git-send-email-kyle.manna@fuel7.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1319475964-10841-1-git-send-email-kyle.manna@fuel7.com>
References: <1319475964-10841-1-git-send-email-kyle.manna@fuel7.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add I2C slave addresses to the header file so that platform definitions
can use them.

Signed-off-by: Kyle Manna <kyle.manna@fuel7.com>
---
 include/linux/mfd/tps65910.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/mfd/tps65910.h b/include/linux/mfd/tps65910.h
index 82b4c88..399d80a 100644
--- a/include/linux/mfd/tps65910.h
+++ b/include/linux/mfd/tps65910.h
@@ -21,6 +21,10 @@
 #define TPS65910			0
 #define TPS65911			1
 
+/* I2C Slave Address 7-bit */
+#define TPS65910_I2C_ID0 0x12 /* Smart Reflex */
+#define TPS65910_I2C_ID1 0x2D /* general-purpose control */
+
 /* TPS regulator type list */
 #define REGULATOR_LDO			0
 #define REGULATOR_DCDC			1
-- 
1.7.5.4

