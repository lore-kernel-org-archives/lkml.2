Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750928Ab1JTENf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 00:13:35 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49466 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab1JTENe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 00:13:34 -0400
Message-ID: <1319084004.12737.0.camel@phoenix>
Subject: [PATCH 1/2] ASoC: wm8994: Use SND_SOC_DAPM_AIF_OUT for AIF3 Capture
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Date: Thu, 20 Oct 2011 12:13:24 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8994.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index 68e769e..03621e2 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -1419,7 +1419,7 @@ SND_SOC_DAPM_MUX("AIF2DAC Mux", SND_SOC_NOPM, 0, 0, &aif2dac_mux),
 SND_SOC_DAPM_MUX("AIF2ADC Mux", SND_SOC_NOPM, 0, 0, &aif2adc_mux),
 
 SND_SOC_DAPM_AIF_IN("AIF3DACDAT", "AIF3 Playback", 0, SND_SOC_NOPM, 0, 0),
-SND_SOC_DAPM_AIF_IN("AIF3ADCDAT", "AIF3 Capture", 0, SND_SOC_NOPM, 0, 0),
+SND_SOC_DAPM_AIF_OUT("AIF3ADCDAT", "AIF3 Capture", 0, SND_SOC_NOPM, 0, 0),
 
 SND_SOC_DAPM_SUPPLY("TOCLK", WM8994_CLOCKING_1, 4, 0, NULL, 0),
 
-- 
1.7.5.4



