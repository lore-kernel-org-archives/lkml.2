Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933745Ab1IONAI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 09:00:08 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:39171 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933730Ab1IONAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 09:00:05 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <samuel.ortiz@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Misael Lopez Cruz <misael.lopez@ti.com>, linux-input@vger.kernel.org
Subject: [PATCH 6/8] ASoC: twl6040: Correct supported number of playback channels
Date: Thu, 15 Sep 2011 15:59:19 +0300
Message-Id: <1316091561-30899-7-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1316091561-30899-1-git-send-email-peter.ujfalusi@ti.com>
References: <1316091561-30899-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

twl6040 supports 5 playback, and 2 capture channels

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 sound/soc/codecs/twl6040.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/twl6040.c b/sound/soc/codecs/twl6040.c
index a386cb3..70f9a64 100644
--- a/sound/soc/codecs/twl6040.c
+++ b/sound/soc/codecs/twl6040.c
@@ -1498,7 +1498,7 @@ static struct snd_soc_dai_driver twl6040_dai[] = {
 	.playback = {
 		.stream_name = "Playback",
 		.channels_min = 1,
-		.channels_max = 2,
+		.channels_max = 5,
 		.rates = TWL6040_RATES,
 		.formats = TWL6040_FORMATS,
 	},
-- 
1.7.6.1

