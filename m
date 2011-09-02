Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933206Ab1IBD6H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 23:58:07 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:35020 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933195Ab1IBD6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 23:58:02 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ruslan Pisarev <ruslan@rpisarev.org.ua>,
        Ilia Mirkin <imirkin@alum.mit.edu>, Joe Perches <joe@perches.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Arnd Bergmann <arnd@arndb.de>,
        Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH v4 08/19] Staging: cx25821: Fix wrong statement indent in cx25821-i2c.c
Date: Fri,  2 Sep 2011 11:55:36 +0800
Message-Id: <1314935747-6881-9-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1314935747-6881-1-git-send-email-leonidsbox@gmail.com>
References: <1314935747-6881-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix wrong brace placement and statement indent in cx25821-i2c.c

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-i2c.c |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-i2c.c b/drivers/staging/cx25821/cx25821-i2c.c
index 130dfeb..4d3d0ce 100644
--- a/drivers/staging/cx25821/cx25821-i2c.c
+++ b/drivers/staging/cx25821/cx25821-i2c.c
@@ -370,16 +370,16 @@ int cx25821_i2c_read(struct cx25821_i2c *bus, u16 reg_addr, int *value)
 
 	struct i2c_msg msgs[2] = {
 		{
-		 .addr = client->addr,
-		 .flags = 0,
-		 .len = 2,
-		 .buf = addr,
-		 }, {
-		     .addr = client->addr,
-		     .flags = I2C_M_RD,
-		     .len = 4,
-		     .buf = buf,
-		     }
+			.addr = client->addr,
+			.flags = 0,
+			.len = 2,
+			.buf = addr,
+		}, {
+			.addr = client->addr,
+			.flags = I2C_M_RD,
+			.len = 4,
+			.buf = buf,
+		}
 	};
 
 	addr[0] = (reg_addr >> 8);
@@ -403,11 +403,11 @@ int cx25821_i2c_write(struct cx25821_i2c *bus, u16 reg_addr, int value)
 
 	struct i2c_msg msgs[1] = {
 		{
-		 .addr = client->addr,
-		 .flags = 0,
-		 .len = 6,
-		 .buf = buf,
-		 }
+			.addr = client->addr,
+			.flags = 0,
+			.len = 6,
+			.buf = buf,
+		}
 	};
 
 	buf[0] = reg_addr >> 8;
-- 
1.7.0.4

