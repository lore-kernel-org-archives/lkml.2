Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119Ab1GFNUw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 09:20:52 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33581 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab1GFNUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 09:20:51 -0400
Subject: [PATCH] ASoC: pxa2xx-pcm: remove unused variable 'dai'
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Eric Miao <eric.y.miao@gmail.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jul 2011 21:20:42 +0800
Message-ID: <1309958442.4613.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused variable 'dai' to eliminate below warning.

  CC      sound/soc/pxa/pxa2xx-pcm.o
sound/soc/pxa/pxa2xx-pcm.c: In function 'pxa2xx_soc_pcm_new':
sound/soc/pxa/pxa2xx-pcm.c:91: warning: unused variable 'dai'

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/pxa/pxa2xx-pcm.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/sound/soc/pxa/pxa2xx-pcm.c b/sound/soc/pxa/pxa2xx-pcm.c
index da28394..c430600 100644
--- a/sound/soc/pxa/pxa2xx-pcm.c
+++ b/sound/soc/pxa/pxa2xx-pcm.c
@@ -88,7 +88,6 @@ static u64 pxa2xx_pcm_dmamask = DMA_BIT_MASK(32);
 static int pxa2xx_soc_pcm_new(struct snd_soc_pcm_runtime *rtd)
 {
 	struct snd_card *card = rtd->card->snd_card;
-	struct snd_soc_dai *dai = rtd->cpu_dai;
 	struct snd_pcm *pcm = rtd->pcm;
 	int ret = 0;
 
-- 
1.7.4.1



