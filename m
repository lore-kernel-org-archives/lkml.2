Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606Ab1HaFui (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 01:50:38 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:44562 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758Ab1HaFuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 01:50:35 -0400
Subject: [PATCH] ASoC: Remove unused variable 'card' in imx_pcm_fiq_new
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sascha Hauer <s.hauer@pengutronix.de>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Aug 2011 13:50:25 +0800
Message-ID: <1314769825.28750.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix below build warning:

  CC      sound/soc/imx/imx-pcm-fiq.o
sound/soc/imx/imx-pcm-fiq.c: In function 'imx_pcm_fiq_new':
sound/soc/imx/imx-pcm-fiq.c:243: warning: unused variable 'card'

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/imx/imx-pcm-fiq.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/sound/soc/imx/imx-pcm-fiq.c b/sound/soc/imx/imx-pcm-fiq.c
index 309c59e..7945625 100644
--- a/sound/soc/imx/imx-pcm-fiq.c
+++ b/sound/soc/imx/imx-pcm-fiq.c
@@ -240,7 +240,6 @@ static int ssi_irq = 0;
 
 static int imx_pcm_fiq_new(struct snd_soc_pcm_runtime *rtd)
 {
-	struct snd_card *card = rtd->card->snd_card;
 	struct snd_soc_dai *dai = rtd->cpu_dai;
 	struct snd_pcm *pcm = rtd->pcm;
 	int ret;
-- 
1.7.4.1



