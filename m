Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434Ab0GLUvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 16:51:23 -0400
Received: from mail.perches.com ([173.55.12.10]:1799 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755132Ab0GLUvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 16:51:09 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
Subject: [PATCH 35/36] sound/soc/davinci: Remove unnecessary casts of private_data
Date: Mon, 12 Jul 2010 13:50:27 -0700
Message-Id: <4cdf03e6ab6a80a90be8aff33f8261a3cb367676.1278967121.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.337.g6068.dirty
In-Reply-To: <cover.1278967120.git.joe@perches.com>
References: <cover.1278967120.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 sound/soc/davinci/davinci-pcm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/davinci/davinci-pcm.c b/sound/soc/davinci/davinci-pcm.c
index 2dc406f..def454e 100644
--- a/sound/soc/davinci/davinci-pcm.c
+++ b/sound/soc/davinci/davinci-pcm.c
@@ -800,7 +800,7 @@ static void davinci_pcm_free(struct snd_pcm *pcm)
 		dma_free_writecombine(pcm->card->dev, buf->bytes,
 				      buf->area, buf->addr);
 		buf->area = NULL;
-		iram_dma = (struct snd_dma_buffer *)buf->private_data;
+		iram_dma = buf->private_data;
 		if (iram_dma) {
 			sram_free(iram_dma->area, iram_dma->bytes);
 			kfree(iram_dma);
-- 
1.7.1.337.g6068.dirty

