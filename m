Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751224Ab1IXKnx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 06:43:53 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:32951 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab1IXKnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 06:43:52 -0400
Subject: [PATCH] ASoC: Drop exporting ad1980_dai
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Roy Huang <roy.huang@analog.com>, Cliff Cai <cliff.cai@analog.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 24 Sep 2011 18:43:43 +0800
Message-ID: <1316861023.11157.4.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ad1980_dai is not used outside this driver,
thus drop exporting it.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/ad1980.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/ad1980.c b/sound/soc/codecs/ad1980.c
index 4c0fc30..e3931cc 100644
--- a/sound/soc/codecs/ad1980.c
+++ b/sound/soc/codecs/ad1980.c
@@ -148,7 +148,6 @@ static struct snd_soc_dai_driver ad1980_dai = {
 		.rates = SNDRV_PCM_RATE_48000,
 		.formats = SND_SOC_STD_AC97_FMTS, },
 };
-EXPORT_SYMBOL_GPL(ad1980_dai);
 
 static int ad1980_reset(struct snd_soc_codec *codec, int try_warm)
 {
-- 
1.7.4.1



