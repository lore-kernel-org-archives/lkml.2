Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab2FTMzl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 08:55:41 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15116 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab2FTMzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 08:55:40 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 20 Jun 2012 05:52:25 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <khali@linux-fr.org>, <w.sang@pengutronix.de>, <swarren@nvidia.com>
CC: <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] i2c: tegra: remove unused member variable.
Date: Wed, 20 Jun 2012 18:25:00 +0530
Message-ID: <1340196900-2916-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused member variable "iomem" of the
i2c device structure.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/i2c/busses/i2c-tegra.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index f15cd49..00cdc10 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -119,7 +119,6 @@ enum msg_end_type {
  * @adapter: core i2c layer adapter information
  * @clk: clock reference for i2c controller
  * @i2c_clk: clock reference for i2c bus
- * @iomem: memory resource for registers
  * @base: ioremapped registers cookie
  * @cont_id: i2c controller id, used for for packet header
  * @irq: irq number of transfer complete interrupt
@@ -137,7 +136,6 @@ struct tegra_i2c_dev {
 	struct i2c_adapter adapter;
 	struct clk *clk;
 	struct clk *i2c_clk;
-	struct resource *iomem;
 	void __iomem *base;
 	int cont_id;
 	int irq;
-- 
1.7.1.1

