Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427Ab1FCAeC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 20:34:02 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46151 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296Ab1FCAeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 20:34:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=J3QUWYKLJuNR2PrbPAhqWnhH2GXVeMwBoiDU8MHQt+aTZ5wcRzbPet7DAYTbQ1mpzK
         6F8x4XmHffiOK24E6klylGnxk6bWukYCvq2lQwDraNz8XIdDagj6TQMwOTSb3LxkY9Kx
         I1mCuqoSqJQN4NhCVFav0NW+plRoeTqrdcTaM=
From: Curtis McEnroe <programble@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Curtis McEnroe <programble@gmail.com>
Subject: [PATCH 3/5] [media] tm6000: Cleaned up code style in tm6000-i2c.c
Date: Thu,  2 Jun 2011 20:33:32 -0400
Message-Id: <1307061214-14837-2-git-send-email-programble@gmail.com>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <1307061214-14837-1-git-send-email-programble@gmail.com>
References: <1307061214-14837-1-git-send-email-programble@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced __FUNCTION__ with __func__

Signed-off-by: Curtis McEnroe <programble@gmail.com>
---
 drivers/staging/tm6000/tm6000-i2c.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-i2c.c b/drivers/staging/tm6000/tm6000-i2c.c
index 8828c12..5a651ea 100644
--- a/drivers/staging/tm6000/tm6000-i2c.c
+++ b/drivers/staging/tm6000/tm6000-i2c.c
@@ -40,7 +40,7 @@ MODULE_PARM_DESC(i2c_debug, "enable debug messages [i2c]");
 
 #define i2c_dprintk(lvl, fmt, args...) if (i2c_debug >= lvl) do { \
 			printk(KERN_DEBUG "%s at %s: " fmt, \
-			dev->name, __FUNCTION__ , ##args); } while (0)
+			dev->name, __func__, ##args); } while (0)
 
 static int tm6000_i2c_send_regs(struct tm6000_core *dev, unsigned char addr,
 				__u8 reg, char *buf, int len)
-- 
1.7.5.2

