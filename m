Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab2FMKXI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 06:23:08 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3805 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab2FMKWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 06:22:30 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 13 Jun 2012 03:21:57 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <khali@linux-fr.org>, <w.sang@pengutronix.de>, <ben-linux@fluff.org>,
        <swarren@wwwdotorg.org>, <olof@lixom.net>
CC: <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V3 2/4] i2c: tegra: add PROTOCOL_MANGLING as supported functionality.
Date: Wed, 13 Jun 2012 15:42:37 +0530
Message-ID: <1339582359-7911-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1339582359-7911-1-git-send-email-ldewangan@nvidia.com>
References: <1339582359-7911-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Tegra i2c driver supports the I2C_M_IGNORE_NAK and hence
returning I2C_FUNC_PROTOCOL_MANGLING as supported functionality.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
No Changes from V1 and V2.

 drivers/i2c/busses/i2c-tegra.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 785f7f7..68433ae 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -563,7 +563,8 @@ static int tegra_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 
 static u32 tegra_i2c_func(struct i2c_adapter *adap)
 {
-	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL | I2C_FUNC_10BIT_ADDR;
+	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL | I2C_FUNC_10BIT_ADDR |
+		I2C_FUNC_PROTOCOL_MANGLING;
 }
 
 static const struct i2c_algorithm tegra_i2c_algo = {
-- 
1.7.1.1

