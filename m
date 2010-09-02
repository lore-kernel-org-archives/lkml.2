Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368Ab0IBXo0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 19:44:26 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:64896 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212Ab0IBXoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 19:44:24 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6093"; a="53211617"
From: Kenneth Heitke <kheitke@codeaurora.org>
To: khali@linux-fr.org, ben-linux@fluff.org, srinidhi.kasagar@stericsson.com,
        tsoni@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kenneth Heitke <kheitke@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 1/2] msm: i2c: Add msm_qup_i2c.h
Date: Thu,  2 Sep 2010 17:44:19 -0600
Message-Id: <1283471059-22262-2-git-send-email-kheitke@codeaurora.org>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1283471059-22262-1-git-send-email-kheitke@codeaurora.org>
References: <1283471059-22262-1-git-send-email-kheitke@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Defines the platform data used by the MSM QUP I2C driver.

Signed-off-by: Kenneth Heitke <kheitke@codeaurora.org>
---
 arch/arm/mach-msm/include/mach/msm_qup_i2c.h |   28 ++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-msm/include/mach/msm_qup_i2c.h

diff --git a/arch/arm/mach-msm/include/mach/msm_qup_i2c.h b/arch/arm/mach-msm/include/mach/msm_qup_i2c.h
new file mode 100644
index 0000000..e26684b
--- /dev/null
+++ b/arch/arm/mach-msm/include/mach/msm_qup_i2c.h
@@ -0,0 +1,28 @@
+/*
+ * Qualcomm MSM QUP i2c Controller Platform Data
+ *
+ * Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+#ifndef __MSM_QUP_I2C_MSM_H
+#define __MSM_QUP_I2C_MSM_H
+
+struct msm_i2c_platform_data {
+	int bus_freq;		/* I2C bus frequency (Hz) */
+	int src_clk_rate;	/* I2C controller clock rate (Hz) */
+};
+
+#endif /* __MSM_QUP_I2C_MSM_H */
-- 
1.7.1.1

--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
