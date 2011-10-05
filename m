Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934125Ab1JEGrX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 02:47:23 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64519 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933776Ab1JEGrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 02:47:22 -0400
Subject: [PATCH] ASoC: Remove unused variable 'wm9090' in wm9090_probe
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Oct 2011 14:47:15 +0800
Message-ID: <1317797235.21481.4.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminate below build warning:
  CC      sound/soc/codecs/wm9090.o
sound/soc/codecs/wm9090.c: In function 'wm9090_probe':
sound/soc/codecs/wm9090.c:550: warning: unused variable 'wm9090'

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm9090.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/wm9090.c b/sound/soc/codecs/wm9090.c
index 228d782..2b5252c 100644
--- a/sound/soc/codecs/wm9090.c
+++ b/sound/soc/codecs/wm9090.c
@@ -548,7 +548,6 @@ static int wm9090_set_bias_level(struct snd_soc_codec *codec,
 
 static int wm9090_probe(struct snd_soc_codec *codec)
 {
-	struct wm9090_priv *wm9090 = snd_soc_codec_get_drvdata(codec);
 	int ret;
 
 	ret = snd_soc_codec_set_cache_io(codec, 8, 16, SND_SOC_I2C);
-- 
1.7.4.1



