Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933663Ab1IOMnO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 08:43:14 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:56293 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933561Ab1IOMkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 08:40:47 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <samuel.ortiz@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Misael Lopez Cruz <misael.lopez@ti.com>
Subject: [PATCH 15/17] ASoC: twl6040/sdp4430: Change legacy DAI name
Date: Thu, 15 Sep 2011 15:39:37 +0300
Message-Id: <1316090379-30760-16-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1316090379-30760-1-git-send-email-peter.ujfalusi@ti.com>
References: <1316090379-30760-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the legacy DAI name from "twl6040-hifi" to "twl6040-legacy" to
be more intuitive.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 sound/soc/codecs/twl6040.c |    2 +-
 sound/soc/omap/sdp4430.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/twl6040.c b/sound/soc/codecs/twl6040.c
index 891b9ec..1be8d1b 100644
--- a/sound/soc/codecs/twl6040.c
+++ b/sound/soc/codecs/twl6040.c
@@ -1440,7 +1440,7 @@ static struct snd_soc_dai_ops twl6040_dai_ops = {
 
 static struct snd_soc_dai_driver twl6040_dai[] = {
 {
-	.name = "twl6040-hifi",
+	.name = "twl6040-legacy",
 	.playback = {
 		.stream_name = "Playback",
 		.channels_min = 1,
diff --git a/sound/soc/omap/sdp4430.c b/sound/soc/omap/sdp4430.c
index d462f1a..060066b 100644
--- a/sound/soc/omap/sdp4430.c
+++ b/sound/soc/omap/sdp4430.c
@@ -166,7 +166,7 @@ static struct snd_soc_dai_link sdp4430_dai = {
 	.name = "TWL6040",
 	.stream_name = "TWL6040",
 	.cpu_dai_name = "omap-mcpdm",
-	.codec_dai_name = "twl6040-hifi",
+	.codec_dai_name = "twl6040-legacy",
 	.platform_name = "omap-pcm-audio",
 	.codec_name = "twl6040-codec",
 	.init = sdp4430_twl6040_init,
-- 
1.7.6.1

