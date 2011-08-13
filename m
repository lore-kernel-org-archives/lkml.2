Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab1HMDdK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 23:33:10 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51990 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970Ab1HMDdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 23:33:08 -0400
Subject: [PATCH] ASoC: s6000-pcm: remove unused variable 'dai'
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Daniel =?ISO-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 13 Aug 2011 11:32:56 +0800
Message-ID: <1313206376.29596.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/s6000/s6000-pcm.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/sound/soc/s6000/s6000-pcm.c b/sound/soc/s6000/s6000-pcm.c
index 80c85fd..55efc2b 100644
--- a/sound/soc/s6000/s6000-pcm.c
+++ b/sound/soc/s6000/s6000-pcm.c
@@ -446,7 +446,6 @@ static u64 s6000_pcm_dmamask = DMA_BIT_MASK(32);
 static int s6000_pcm_new(struct snd_soc_pcm_runtime *runtime)
 {
 	struct snd_card *card = runtime->card->snd_card;
-	struct snd_soc_dai *dai = runtime->cpu_dai;
 	struct snd_pcm *pcm = runtime->pcm;
 	struct s6000_pcm_dma_params *params;
 	int res;
-- 
1.7.4.1



