Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab0LAGco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 01:32:44 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46091 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab0LAGcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 01:32:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=aNm8P3jDfC2TPQu8RvGUlt2tOwZL7FCX3H2Au2gdL5rSlrZW6vWEMh6s7SJgz1qd3q
         zZimW/Fdn/HlfXDncx4BcVzcdz9G4kuGRRS1bgULXaLGvmnUJBz92kolYRvlYlJoJF11
         +A6B7q7bhcpAAL15d8mgQnvlpAZOmYS1CNppw=
Subject: [PATCH] ASoC: Remove unused aic3x_i2c_init and aic3x_i2c_exit
	functions
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Vladimir Barinov <vbarinov@embeddedalley.com>,
        Jarkko Nikula <jhnikula@gmail.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain
Date: Wed, 01 Dec 2010 14:38:24 +0800
Message-Id: <1291185504.5563.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/tlv320aic3x.c |   15 ---------------
 1 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/sound/soc/codecs/tlv320aic3x.c b/sound/soc/codecs/tlv320aic3x.c
index fc5abdf..8cd4cf5 100644
--- a/sound/soc/codecs/tlv320aic3x.c
+++ b/sound/soc/codecs/tlv320aic3x.c
@@ -1545,21 +1545,6 @@ static struct i2c_driver aic3x_i2c_driver = {
 	.remove = aic3x_i2c_remove,
 	.id_table = aic3x_i2c_id,
 };
-
-static inline void aic3x_i2c_init(void)
-{
-	int ret;
-
-	ret = i2c_add_driver(&aic3x_i2c_driver);
-	if (ret)
-		printk(KERN_ERR "%s: error regsitering i2c driver, %d\n",
-		       __func__, ret);
-}
-
-static inline void aic3x_i2c_exit(void)
-{
-	i2c_del_driver(&aic3x_i2c_driver);
-}
 #endif
 
 static int __init aic3x_modinit(void)
-- 
1.7.2



