Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751210Ab1JTEQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 00:16:39 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53430 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722Ab1JTEQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 00:16:38 -0400
Message-ID: <1319084191.12737.2.camel@phoenix>
Subject: [PATCH 2/2] ASoC: wm8996: Use SND_SOC_DAPM_AIF_OUT for AIF2 Capture
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Date: Thu, 20 Oct 2011 12:16:31 +0800
In-Reply-To: <1319084004.12737.0.camel@phoenix>
References: <1319084004.12737.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8996.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wm8996.c b/sound/soc/codecs/wm8996.c
index 43e46c7..1d7b174 100644
--- a/sound/soc/codecs/wm8996.c
+++ b/sound/soc/codecs/wm8996.c
@@ -1113,9 +1113,9 @@ SND_SOC_DAPM_AIF_IN("AIF2RX1", "AIF2 Playback", 0,
 SND_SOC_DAPM_AIF_IN("AIF2RX0", "AIF2 Playback", 1,
 		    WM8996_POWER_MANAGEMENT_4, 8, 0),
 
-SND_SOC_DAPM_AIF_IN("AIF2TX1", "AIF2 Capture", 0,
+SND_SOC_DAPM_AIF_OUT("AIF2TX1", "AIF2 Capture", 0,
 		    WM8996_POWER_MANAGEMENT_6, 9, 0),
-SND_SOC_DAPM_AIF_IN("AIF2TX0", "AIF2 Capture", 1,
+SND_SOC_DAPM_AIF_OUT("AIF2TX0", "AIF2 Capture", 1,
 		    WM8996_POWER_MANAGEMENT_6, 8, 0),
 
 SND_SOC_DAPM_AIF_IN("AIF1RX5", "AIF1 Playback", 5,
-- 
1.7.5.4



