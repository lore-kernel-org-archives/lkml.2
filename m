Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758610Ab2JKLzo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 07:55:44 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59304 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757561Ab2JKLzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 07:55:41 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <peter.ujfalusi@ti.com>
Subject: [PATCH 1/6] MFD: twl6040: Fix typo for power on failure
Date: Thu, 11 Oct 2012 13:55:28 +0200
Message-ID: <1349956533-6374-2-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1349956533-6374-1-git-send-email-peter.ujfalusi@ti.com>
References: <1349956533-6374-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix old copy paste bug:
automatic power-down failed -> automatic power-up failed

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl6040-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/twl6040-core.c b/drivers/mfd/twl6040-core.c
index 3f2a1cf..b220aa2 100644
--- a/drivers/mfd/twl6040-core.c
+++ b/drivers/mfd/twl6040-core.c
@@ -258,7 +258,7 @@ int twl6040_power(struct twl6040 *twl6040, int on)
 			ret = twl6040_power_up_completion(twl6040, naudint);
 			if (ret) {
 				dev_err(twl6040->dev,
-					"automatic power-down failed\n");
+					"automatic power-up failed\n");
 				twl6040->power_count = 0;
 				goto out;
 			}
-- 
1.7.12

