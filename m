Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab1JBNHM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 09:07:12 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:54485 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab1JBNHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 09:07:08 -0400
Subject: [PATCH 2/2] ASoC: Remove unused srate variable in
 tegra_spdif_hw_params
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Stephen Warren <swarren@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
In-Reply-To: <1317560756.21926.3.camel@phoenix>
References: <1317560756.21926.3.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 02 Oct 2011 21:07:02 +0800
Message-ID: <1317560822.21926.4.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/tegra/tegra_spdif.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/sound/soc/tegra/tegra_spdif.c b/sound/soc/tegra/tegra_spdif.c
index 1bd07d1..dd11d0c 100644
--- a/sound/soc/tegra/tegra_spdif.c
+++ b/sound/soc/tegra/tegra_spdif.c
@@ -127,7 +127,7 @@ static int tegra_spdif_hw_params(struct snd_pcm_substream *substream,
 {
 	struct device *dev = substream->pcm->card->dev;
 	struct tegra_spdif *spdif = snd_soc_dai_get_drvdata(dai);
-	int ret, srate, spdifclock;
+	int ret, spdifclock;
 
 	spdif->reg_ctrl &= ~TEGRA_SPDIF_CTRL_PACK;
 	spdif->reg_ctrl &= ~TEGRA_SPDIF_CTRL_BIT_MODE_MASK;
@@ -140,7 +140,6 @@ static int tegra_spdif_hw_params(struct snd_pcm_substream *substream,
 		return -EINVAL;
 	}
 
-	srate = params_rate(params);
 	switch (params_rate(params)) {
 	case 32000:
 		spdifclock = 4096000;
-- 
1.7.4.1



