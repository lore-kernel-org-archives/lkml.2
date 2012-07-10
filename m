Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab2GJL16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 07:27:58 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5422 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755188Ab2GJL1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 07:27:55 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 10 Jul 2012 04:27:14 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <w.sang@pengutronix.de>, <khali@linux-fr.org>, <ben-linux@fluff.org>
CC: <swarren@nvidia.com>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 1/5] i2c: tegra: remove unused member variable
Date: Tue, 10 Jul 2012 16:50:40 +0530
Message-ID: <1341919244-23327-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1341919244-23327-1-git-send-email-ldewangan@nvidia.com>
References: <1341919244-23327-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused member variable "iomem" of the
i2c device structure.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
This patch is resend of earlier patch
 i2c: tegra: remove unused member variable.
and sending it as part fo series.

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

