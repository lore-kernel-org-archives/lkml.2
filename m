Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498Ab0ICBHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 21:07:22 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40296 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab0ICBHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 21:07:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=MgdpPpU5/0T+DK8gdupCspePzoRV16gcJstClc9mVCSyVDZrFIXQnDM1nB8KuREmJ9
         OBFBAR42RZguKqglC9NdSe5Mx+LyrX0jLARyFSIjAfzP55O+J2/DCeaWWnBEUXwbTGMN
         +1GEGKfJbORMPdJFLQ9wnCa7mveR3lV42pjbA=
Subject: [PATCH] Input: tsc2007 - fix a redundant assignment for pdata
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Kwangwoo Lee <kwlee@mtekvision.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Content-Type: text/plain
Date: Fri, 03 Sep 2010 09:11:23 +0800
Message-Id: <1283476283.5439.4.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/input/touchscreen/tsc2007.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/touchscreen/tsc2007.c b/drivers/input/touchscreen/tsc2007.c
index be23780..80467f2 100644
--- a/drivers/input/touchscreen/tsc2007.c
+++ b/drivers/input/touchscreen/tsc2007.c
@@ -265,7 +265,7 @@ static int __devinit tsc2007_probe(struct i2c_client *client,
 				   const struct i2c_device_id *id)
 {
 	struct tsc2007 *ts;
-	struct tsc2007_platform_data *pdata = pdata = client->dev.platform_data;
+	struct tsc2007_platform_data *pdata = client->dev.platform_data;
 	struct input_dev *input_dev;
 	int err;
 
-- 
1.7.2



