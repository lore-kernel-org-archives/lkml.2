Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab1JVFrf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 01:47:35 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42321 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566Ab1JVFra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 01:47:30 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Joe Perches <joe@perches.com>, Ilia Mirkin <imirkin@alum.mit.edu>,
        Youquan Song <youquan.song@intel.com>,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: [PATCH 14/36] Staging: cx25821: cx25821-i2c.c: Change line endings
Date: Sat, 22 Oct 2011 13:43:34 +0800
Message-Id: <1319262236-6498-15-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
References: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change obscure line endings to less obscure ones. (improve readability)

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-i2c.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-i2c.c b/drivers/staging/cx25821/cx25821-i2c.c
index 4d3d0ce..29df029 100644
--- a/drivers/staging/cx25821/cx25821-i2c.c
+++ b/drivers/staging/cx25821/cx25821-i2c.c
@@ -252,8 +252,8 @@ static int i2c_xfer(struct i2c_adapter *i2c_adap, struct i2c_msg *msgs, int num)
 		} else if (i + 1 < num && (msgs[i + 1].flags & I2C_M_RD) &&
 			   msgs[i].addr == msgs[i + 1].addr) {
 			/* write then read from same address */
-			retval =
-			    i2c_sendbytes(i2c_adap, &msgs[i], msgs[i + 1].len);
+			retval = i2c_sendbytes(i2c_adap, &msgs[i],
+					msgs[i + 1].len);
 
 			if (retval < 0)
 				goto err;
@@ -276,10 +276,8 @@ err:
 
 static u32 cx25821_functionality(struct i2c_adapter *adap)
 {
-	return I2C_FUNC_SMBUS_EMUL |
-	    I2C_FUNC_I2C |
-	    I2C_FUNC_SMBUS_WORD_DATA |
-	    I2C_FUNC_SMBUS_READ_WORD_DATA | I2C_FUNC_SMBUS_WRITE_WORD_DATA;
+	return I2C_FUNC_SMBUS_EMUL | I2C_FUNC_I2C | I2C_FUNC_SMBUS_WORD_DATA |
+		I2C_FUNC_SMBUS_READ_WORD_DATA | I2C_FUNC_SMBUS_WRITE_WORD_DATA;
 }
 
 static struct i2c_algorithm cx25821_i2c_algo_template = {
-- 
1.7.0.4

