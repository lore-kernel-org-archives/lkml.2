Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab2IQFbK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 01:31:10 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7047 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab2IQFbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 01:31:07 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sun, 16 Sep 2012 22:31:06 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <sameo@linux.intel.com>, <fengguang.wu@intel.com>
CC: <linux-kernel@vger.kernel.org>, Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH] mfd: tps65090: remove redundant check
Date: Mon, 17 Sep 2012 11:00:47 +0530
Message-ID: <1347859847-23341-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove redundant check in is_volatile_reg().

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
 drivers/mfd/tps65090.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/tps65090.c b/drivers/mfd/tps65090.c
index 50fd87c..074ae32 100644
--- a/drivers/mfd/tps65090.c
+++ b/drivers/mfd/tps65090.c
@@ -236,7 +236,7 @@ static int __devinit tps65090_irq_init(struct tps65090 *tps65090, int irq,
 
 static bool is_volatile_reg(struct device *dev, unsigned int reg)
 {
-	if ((reg == TPS65090_INT_STS) || (reg == TPS65090_INT_STS))
+	if (reg == TPS65090_INT_STS)
 		return true;
 	else
 		return false;
-- 
1.7.1.1

