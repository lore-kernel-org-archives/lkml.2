Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222Ab1JDOHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 10:07:32 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:55677 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756856Ab1JDOHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 10:07:31 -0400
Subject: ASoC: wm8994: Is the rate_reg for wm8994-aif2 correct?
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Oct 2011 22:07:18 +0800
Message-ID: <1317737239.6419.6.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Mark,
While reading wm8994.c, it seems the correct rate_reg for wm8994-aif2
should be WM8994_AIF2_RATE.
I cannot find wm8994 datasheet, could you help checking it?

Thanks,
Axel

>From 5b4cb1e9eae945dfe473139a80d16da6f2fee622 Mon Sep 17 00:00:00 2001
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 4 Oct 2011 22:00:01 +0800
Subject: [PATCH] ASoC: wm8994: Fix setting rate_reg for wm8994-aif2

For wm8994-aif2, the rate_reg should be WM8994_AIF2_RATE.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8994.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index 4225e1f..d5b69c0 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -2421,7 +2421,7 @@ static void wm8994_aif_shutdown(struct snd_pcm_substream *substream,
 		rate_reg = WM8994_AIF1_RATE;
 		break;
 	case 2:
-		rate_reg = WM8994_AIF1_RATE;
+		rate_reg = WM8994_AIF2_RATE;
 		break;
 	default:
 		break;
-- 
1.7.4.1



