Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab1JBNGO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 09:06:14 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:60929 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab1JBNGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 09:06:06 -0400
Subject: [PATCH 1/2] ASoC: Remove unused rate variable in
 magician_playback_hw_params
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Philipp Zabel <philipp.zabel@gmail.com>, Eric Miao <eric.y.miao@gmail.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 02 Oct 2011 21:05:56 +0800
Message-ID: <1317560756.21926.3.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/pxa/magician.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/sound/soc/pxa/magician.c b/sound/soc/pxa/magician.c
index 67dcc36..098e5f4 100644
--- a/sound/soc/pxa/magician.c
+++ b/sound/soc/pxa/magician.c
@@ -92,11 +92,10 @@ static int magician_playback_hw_params(struct snd_pcm_substream *substream,
 	struct snd_soc_pcm_runtime *rtd = substream->private_data;
 	struct snd_soc_dai *codec_dai = rtd->codec_dai;
 	struct snd_soc_dai *cpu_dai = rtd->cpu_dai;
-	unsigned int acps, acds, width, rate;
+	unsigned int acps, acds, width;
 	unsigned int div4 = PXA_SSP_CLK_SCDB_4;
 	int ret = 0;
 
-	rate = params_rate(params);
 	width = snd_pcm_format_physical_width(params_format(params));
 
 	/*
-- 
1.7.4.1



