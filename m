Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab1H3ESh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 00:18:37 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:49060 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab1H3ESe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 00:18:34 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ruslan Pisarev <ruslan@rpisarev.org.ua>,
        Ilia Mirkin <imirkin@alum.mit.edu>, Ilya Gorskin <Revent82@gmail.com>,
        Joe Perches <joe@perches.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Arnd Bergmann <arnd@arndb.de>,
        Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH v3 07/18] Staging: cx25821: Fix wrong brace placement in cx25821-i2c.c
Date: Tue, 30 Aug 2011 12:17:02 +0800
Message-Id: <1314677833-4689-8-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1314677833-4689-1-git-send-email-leonidsbox@gmail.com>
References: <1314677833-4689-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix wrong brace placement in cx25821-i2c.c

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-i2c.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-i2c.c b/drivers/staging/cx25821/cx25821-i2c.c
index 130dfeb..ea5a878 100644
--- a/drivers/staging/cx25821/cx25821-i2c.c
+++ b/drivers/staging/cx25821/cx25821-i2c.c
@@ -374,12 +374,12 @@ int cx25821_i2c_read(struct cx25821_i2c *bus, u16 reg_addr, int *value)
 		 .flags = 0,
 		 .len = 2,
 		 .buf = addr,
-		 }, {
+		}, {
 		     .addr = client->addr,
 		     .flags = I2C_M_RD,
 		     .len = 4,
 		     .buf = buf,
-		     }
+		}
 	};
 
 	addr[0] = (reg_addr >> 8);
@@ -407,7 +407,7 @@ int cx25821_i2c_write(struct cx25821_i2c *bus, u16 reg_addr, int value)
 		 .flags = 0,
 		 .len = 6,
 		 .buf = buf,
-		 }
+		}
 	};
 
 	buf[0] = reg_addr >> 8;
-- 
1.7.0.4

