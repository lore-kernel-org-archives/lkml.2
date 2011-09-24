Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750940Ab1IXKQ3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 06:16:29 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63400 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab1IXKQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 06:16:28 -0400
Subject: [PATCH] ASoC: Drop exporting sn95031_get_mic_bias
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Vinod Koul <vinod.koul@linux.intel.com>,
        Harsha Priya <priya.harsha@intel.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 24 Sep 2011 18:16:15 +0800
Message-ID: <1316859375.11157.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sn95031_get_mic_bias() is not used outside this driver
and it is a static function now.
Thus drop exporting sn95031_get_mic_bias.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/sn95031.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/sn95031.c b/sound/soc/codecs/sn95031.c
index d1781d1..8f8ce5f 100644
--- a/sound/soc/codecs/sn95031.c
+++ b/sound/soc/codecs/sn95031.c
@@ -161,7 +161,6 @@ static unsigned int sn95031_get_mic_bias(struct snd_soc_codec *codec)
 	pr_debug("mic bias = %dmV\n", mic_bias);
 	return mic_bias;
 }
-EXPORT_SYMBOL_GPL(sn95031_get_mic_bias);
 /*end - adc helper functions */
 
 static inline unsigned int sn95031_read(struct snd_soc_codec *codec,
-- 
1.7.4.1



