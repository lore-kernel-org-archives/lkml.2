Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767Ab1IPCrp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 22:47:45 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:42612 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578Ab1IPCro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 22:47:44 -0400
Subject: [PATCH 2/2] ASoC: wm8995: Remove unused i2c variable in
 wm8995_remove()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
In-Reply-To: <1316141193.21890.1.camel@phoenix>
References: <1316141193.21890.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Sep 2011 10:47:37 +0800
Message-ID: <1316141257.21890.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8995.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wm8995.c b/sound/soc/codecs/wm8995.c
index 05f7795..74ae599 100644
--- a/sound/soc/codecs/wm8995.c
+++ b/sound/soc/codecs/wm8995.c
@@ -1573,9 +1573,7 @@ static int wm8995_resume(struct snd_soc_codec *codec)
 static int wm8995_remove(struct snd_soc_codec *codec)
 {
 	struct wm8995_priv *wm8995;
-	struct i2c_client *i2c;
 
-	i2c = container_of(codec->dev, struct i2c_client, dev);
 	wm8995 = snd_soc_codec_get_drvdata(codec);
 	wm8995_set_bias_level(codec, SND_SOC_BIAS_OFF);
 	return 0;
-- 
1.7.4.1



