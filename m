Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703Ab2LQVEj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 16:04:39 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:47248 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab2LQVEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 16:04:37 -0500
From: Laurent Navet <laurent.navet@gmail.com>
To: khali@linux-fr.org
Cc: w.sang@pengutronix.de, ben-linux@fluff.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Laurent Navet <laurent.navet@gmail.com>
Subject: [PATCH] driver i2c-nforce2: fix pointer CodingStyle issues
Date: Mon, 17 Dec 2012 22:04:19 +0100
Message-Id: <1355778259-8445-1-git-send-email-laurent.navet@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix these errors reported by checkpatch.pl
- drivers/i2c/busses/i2c-nforce2.c:191
- drivers/i2c/busses/i2c-nforce2.c:193
ERROR: "foo * bar" should be "foo *bar"

- drivers/i2c/busses/i2c-nforce2.c:302:
ERROR: "(foo*)" should be "(foo *)"

Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
---
 drivers/i2c/busses/i2c-nforce2.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/i2c-nforce2.c b/drivers/i2c/busses/i2c-nforce2.c
index 392303b..9db5ff5 100644
--- a/drivers/i2c/busses/i2c-nforce2.c
+++ b/drivers/i2c/busses/i2c-nforce2.c
@@ -188,9 +188,9 @@ static int nforce2_check_status(struct i2c_adapter *adap)
 }
 
 /* Return negative errno on error */
-static s32 nforce2_access(struct i2c_adapter * adap, u16 addr,
+static s32 nforce2_access(struct i2c_adapter *adap, u16 addr,
 		unsigned short flags, char read_write,
-		u8 command, int size, union i2c_smbus_data * data)
+		u8 command, int size, union i2c_smbus_data *data)
 {
 	struct nforce2_smbus *smbus = adap->algo_data;
 	unsigned char protocol, pec;
@@ -299,7 +299,7 @@ static u32 nforce2_func(struct i2c_adapter *adapter)
 	return I2C_FUNC_SMBUS_QUICK | I2C_FUNC_SMBUS_BYTE |
 	       I2C_FUNC_SMBUS_BYTE_DATA | I2C_FUNC_SMBUS_WORD_DATA |
 	       I2C_FUNC_SMBUS_PEC |
-	       (((struct nforce2_smbus*)adapter->algo_data)->blockops ?
+	       (((struct nforce2_smbus *)adapter->algo_data)->blockops ?
 		I2C_FUNC_SMBUS_BLOCK_DATA : 0);
 }
 
-- 
1.7.10.4

