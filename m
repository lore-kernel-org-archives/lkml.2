Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab1JUCoP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 22:44:15 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39163 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab1JUCoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 22:44:14 -0400
Message-ID: <1319165047.4352.4.camel@phoenix>
Subject: [PATCH] ASoC: wm8996: Fix wrong mask for setting
 WM8996_AIF_CLOCKING_2
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Date: Fri, 21 Oct 2011 10:44:07 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8996.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/wm8996.c b/sound/soc/codecs/wm8996.c
index 1d7b174..645c980 100644
--- a/sound/soc/codecs/wm8996.c
+++ b/sound/soc/codecs/wm8996.c
@@ -1920,7 +1920,7 @@ static int wm8996_hw_params(struct snd_pcm_substream *substream,
 	snd_soc_update_bits(codec, lrclk_reg, WM8996_AIF1RX_RATE_MASK,
 			    lrclk);
 	snd_soc_update_bits(codec, WM8996_AIF_CLOCKING_2,
-			    WM8996_DSP1_DIV_SHIFT << dsp_shift, dsp);
+			    WM8996_DSP1_DIV_MASK << dsp_shift, dsp);
 
 	return 0;
 }
-- 
1.7.5.4



