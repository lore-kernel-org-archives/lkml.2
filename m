Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab1ISIem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 04:34:42 -0400
Received: from mail-gw0-f42.google.com ([74.125.83.42]:35649 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab1ISIel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 04:34:41 -0400
Subject: [PATCH] ASoC: sn95031: Staticize sn95031_pcm_hw_params
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Vinod Koul <vinod.koul@linux.intel.com>,
        Harsha Priya <priya.harsha@intel.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Sep 2011 16:34:28 +0800
Message-ID: <1316421268.23109.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/sn95031.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/sn95031.c b/sound/soc/codecs/sn95031.c
index b4f1cb4..29945b0 100644
--- a/sound/soc/codecs/sn95031.c
+++ b/sound/soc/codecs/sn95031.c
@@ -658,7 +658,7 @@ static int sn95031_pcm_spkr_mute(struct snd_soc_dai *dai, int mute)
 	return 0;
 }
 
-int sn95031_pcm_hw_params(struct snd_pcm_substream *substream,
+static int sn95031_pcm_hw_params(struct snd_pcm_substream *substream,
 		struct snd_pcm_hw_params *params, struct snd_soc_dai *dai)
 {
 	unsigned int format, rate;
-- 
1.7.4.1



