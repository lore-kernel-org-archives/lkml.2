Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab1HOIio (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 04:38:44 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64460 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab1HOIik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 04:38:40 -0400
Subject: [PATCH] ASoC: nuc900-pcm: remove unused variable 'dai'
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Wan ZongShun <mcuos.com@gmail.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Aug 2011 16:38:34 +0800
Message-ID: <1313397514.25061.4.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused variable 'dai' to eliminate below warning.

  CC      sound/soc/nuc900/nuc900-pcm.o
sound/soc/nuc900/nuc900-pcm.c: In function 'nuc900_dma_new':
sound/soc/nuc900/nuc900-pcm.c:321: warning: unused variable 'dai'

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/nuc900/nuc900-pcm.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/sound/soc/nuc900/nuc900-pcm.c b/sound/soc/nuc900/nuc900-pcm.c
index d589ef1..e46d551 100644
--- a/sound/soc/nuc900/nuc900-pcm.c
+++ b/sound/soc/nuc900/nuc900-pcm.c
@@ -318,7 +318,6 @@ static u64 nuc900_pcm_dmamask = DMA_BIT_MASK(32);
 static int nuc900_dma_new(struct snd_soc_pcm_runtime *rtd)
 {
 	struct snd_card *card = rtd->card->snd_card;
-	struct snd_soc_dai *dai = rtd->cpu_dai;
 	struct snd_pcm *pcm = rtd->pcm;
 
 	if (!card->dev->dma_mask)
-- 
1.7.4.1



