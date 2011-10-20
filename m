Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795Ab1JTDAO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 23:00:14 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:53041 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab1JTDAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 23:00:13 -0400
Message-ID: <1319079606.5380.6.camel@phoenix>
Subject: [PATCH] ASoC: rt5631: Remove unused codec field from struct
 rt5631_priv
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: flove <flove@realtek.com>, Johnny Hsu <johnnyhsu@realtek.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Date: Thu, 20 Oct 2011 11:00:06 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/rt5631.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/rt5631.c b/sound/soc/codecs/rt5631.c
index 86e69f4..27a078c 100644
--- a/sound/soc/codecs/rt5631.c
+++ b/sound/soc/codecs/rt5631.c
@@ -31,7 +31,6 @@
 #include "rt5631.h"
 
 struct rt5631_priv {
-	struct snd_soc_codec *codec;
 	int codec_version;
 	int master;
 	int sysclk;
@@ -1632,7 +1631,6 @@ static int rt5631_probe(struct snd_soc_codec *codec)
 	}
 
 	codec->dapm.bias_level = SND_SOC_BIAS_STANDBY;
-	rt5631->codec = codec;
 
 	return 0;
 }
-- 
1.7.5.4



