Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab0IIJqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 05:46:24 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64857 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab0IIJqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 05:46:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=qaFj9oIMjTrjxZRsoCbY13rDrmzqkwqZBWtSNupj36RQfePwZXJfV4xi9DUmW2XVKm
         HsOxpDmxeBlsB1/AGrnR7SwaKI/bdpl8S24pBMhYF4feGiwMnFCQv8Mej7idnFnK1uf/
         KNc2G2oupqTHuc//h+Jgpl2rl8b6cV/Hd4l3Q=
Subject: [PATCH] ASoC: ad1980 - set reg_cache_default to ad1980_reg
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Roy Huang <roy.huang@analog.com>, Cliff Cai <cliff.cai@analog.com>
Content-Type: text/plain
Date: Thu, 09 Sep 2010 17:50:56 +0800
Message-Id: <1284025856.14894.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/ad1980.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/ad1980.c b/sound/soc/codecs/ad1980.c
index 2b9331a..d36bd1c 100644
--- a/sound/soc/codecs/ad1980.c
+++ b/sound/soc/codecs/ad1980.c
@@ -247,6 +247,7 @@ static struct snd_soc_codec_driver soc_codec_dev_ad1980 = {
 	.remove = 	ad1980_soc_remove,
 	.reg_cache_size = ARRAY_SIZE(ad1980_reg),
 	.reg_word_size = sizeof(u16),
+	.reg_cache_default = ad1980_reg,
 	.reg_cache_step = 2,
 	.write = ac97_write,
 	.read = ac97_read,
-- 
1.7.2



