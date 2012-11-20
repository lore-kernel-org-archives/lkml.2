Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754Ab2KTEdb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 23:33:31 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58862 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751462Ab2KTEda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 23:33:30 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] mfd: wm5102: Mark some more status registers as volatile
Date: Tue, 20 Nov 2012 13:33:19 +0900
Message-Id: <1353385999-10275-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353385999-10275-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20121120043211.GE4483@opensource.wolfsonmicro.com>
 <1353385999-10275-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm5102-tables.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mfd/wm5102-tables.c b/drivers/mfd/wm5102-tables.c
index ffeba98..1ade455 100644
--- a/drivers/mfd/wm5102-tables.c
+++ b/drivers/mfd/wm5102-tables.c
@@ -2331,6 +2331,9 @@ static bool wm5102_volatile_register(struct device *dev, unsigned int reg)
 	case ARIZONA_SOFTWARE_RESET:
 	case ARIZONA_DEVICE_REVISION:
 	case ARIZONA_OUTPUT_STATUS_1:
+	case ARIZONA_RAW_OUTPUT_STATUS_1:
+	case ARIZONA_SLIMBUS_RX_PORT_STATUS:
+	case ARIZONA_SLIMBUS_TX_PORT_STATUS:
 	case ARIZONA_SAMPLE_RATE_1_STATUS:
 	case ARIZONA_SAMPLE_RATE_2_STATUS:
 	case ARIZONA_SAMPLE_RATE_3_STATUS:
-- 
1.7.10.4

