Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126Ab1FGIZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 04:25:40 -0400
Received: from smtp-out-002.synserver.de ([212.40.185.2]:1140 "HELO
	smtp-out-002.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752045Ab1FGIZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 04:25:37 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 10583
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, device-drivers-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org, Mike Frysinger <vapier@gentoo.org>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] ASoC: Blackfin: bf5xx-ad1836: Fix codec device name
Date: Tue,  7 Jun 2011 10:24:46 +0200
Message-Id: <1307435086-29877-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the codec_name field of the dai_link to match the actual device name
of the codec. Otherwise the card won't be instantiated.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 sound/soc/blackfin/bf5xx-ad1836.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/blackfin/bf5xx-ad1836.c b/sound/soc/blackfin/bf5xx-ad1836.c
index ea4951c..f79d165 100644
--- a/sound/soc/blackfin/bf5xx-ad1836.c
+++ b/sound/soc/blackfin/bf5xx-ad1836.c
@@ -75,7 +75,7 @@ static struct snd_soc_dai_link bf5xx_ad1836_dai[] = {
 		.cpu_dai_name = "bfin-tdm.0",
 		.codec_dai_name = "ad1836-hifi",
 		.platform_name = "bfin-tdm-pcm-audio",
-		.codec_name = "ad1836.0",
+		.codec_name = "spi0.4",
 		.ops = &bf5xx_ad1836_ops,
 	},
 	{
@@ -84,7 +84,7 @@ static struct snd_soc_dai_link bf5xx_ad1836_dai[] = {
 		.cpu_dai_name = "bfin-tdm.1",
 		.codec_dai_name = "ad1836-hifi",
 		.platform_name = "bfin-tdm-pcm-audio",
-		.codec_name = "ad1836.0",
+		.codec_name = "spi0.4",
 		.ops = &bf5xx_ad1836_ops,
 	},
 };
-- 
1.7.2.5

