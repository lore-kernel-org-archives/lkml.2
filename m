Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab0KUPDo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 10:03:44 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:42943 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930Ab0KUPDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 10:03:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=iT3kNGSLRXQbwIOYfNAyEb2oYL7l57BRFAGuPt3wz1aMByIQJ3Xlh+tuyM6McX6tZp
         Y0FY40X1sKUNt7pNZMYgokXrFNlIZba36oI9vgb0hetoHl+km3xGOGM9TSHVvKELnndj
         o+8676j8kg78soh42UqulBsFIRWSy2kF4r6bY=
Subject: [PATCH] ASoC: stac9766 - reg_cache_default to stac9766_reg
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jon Smirl <jonsmirl@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 21 Nov 2010 23:03:33 +0800
Message-ID: <1290351813.13154.15.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like this is missing during multi-component conversion.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/stac9766.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/stac9766.c b/sound/soc/codecs/stac9766.c
index 8aad3a2..04c5224 100644
--- a/sound/soc/codecs/stac9766.c
+++ b/sound/soc/codecs/stac9766.c
@@ -384,6 +384,7 @@ static struct snd_soc_codec_driver soc_codec_dev_stac9766 = {
 	.reg_cache_size = sizeof(stac9766_reg),
 	.reg_word_size = sizeof(u16),
 	.reg_cache_step = 2,
+	.reg_cache_default = stac9766_reg,
 };
 
 static __devinit int stac9766_probe(struct platform_device *pdev)
-- 
1.7.0.4



