Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933039Ab0KODGR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 22:06:17 -0500
Received: from mail.perches.com ([173.55.12.10]:1275 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932999Ab0KODGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 22:06:04 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 44/44] sound/soc/codecs: Remove unnecessary semicolons
Date: Sun, 14 Nov 2010 19:05:03 -0800
Message-Id: <97fd199b7dac50613f6843156687223928cce44a.1289789605.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289789604.git.joe@perches.com>
References: <cover.1289789604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 sound/soc/codecs/wm8904.c  |    2 +-
 sound/soc/codecs/wm8940.c  |    1 -
 sound/soc/codecs/wm8993.c  |    2 +-
 sound/soc/codecs/wm_hubs.c |    2 +-
 4 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/wm8904.c b/sound/soc/codecs/wm8904.c
index 33be84e..99ae66d 100644
--- a/sound/soc/codecs/wm8904.c
+++ b/sound/soc/codecs/wm8904.c
@@ -1590,7 +1590,7 @@ static int wm8904_hw_params(struct snd_pcm_substream *substream,
 		       - wm8904->fs);
 	for (i = 1; i < ARRAY_SIZE(clk_sys_rates); i++) {
 		cur_val = abs((wm8904->sysclk_rate /
-			       clk_sys_rates[i].ratio) - wm8904->fs);;
+			       clk_sys_rates[i].ratio) - wm8904->fs);
 		if (cur_val < best_val) {
 			best = i;
 			best_val = cur_val;
diff --git a/sound/soc/codecs/wm8940.c b/sound/soc/codecs/wm8940.c
index 2cb16f8..e3f3572 100644
--- a/sound/soc/codecs/wm8940.c
+++ b/sound/soc/codecs/wm8940.c
@@ -735,7 +735,6 @@ static int wm8940_probe(struct snd_soc_codec *codec)
 		return ret;
 
 	return ret;
-;
 }
 
 static int wm8940_remove(struct snd_soc_codec *codec)
diff --git a/sound/soc/codecs/wm8993.c b/sound/soc/codecs/wm8993.c
index 589e3fa..74af9c5 100644
--- a/sound/soc/codecs/wm8993.c
+++ b/sound/soc/codecs/wm8993.c
@@ -1225,7 +1225,7 @@ static int wm8993_hw_params(struct snd_pcm_substream *substream,
 		       - wm8993->fs);
 	for (i = 1; i < ARRAY_SIZE(clk_sys_rates); i++) {
 		cur_val = abs((wm8993->sysclk_rate /
-			       clk_sys_rates[i].ratio) - wm8993->fs);;
+			       clk_sys_rates[i].ratio) - wm8993->fs);
 		if (cur_val < best_val) {
 			best = i;
 			best_val = cur_val;
diff --git a/sound/soc/codecs/wm_hubs.c b/sound/soc/codecs/wm_hubs.c
index 19ca782..2afbc7a 100644
--- a/sound/soc/codecs/wm_hubs.c
+++ b/sound/soc/codecs/wm_hubs.c
@@ -112,7 +112,7 @@ static void calibrate_dc_servo(struct snd_soc_codec *codec)
 		switch (hubs->dcs_readback_mode) {
 		case 0:
 			reg_l = snd_soc_read(codec, WM8993_DC_SERVO_READBACK_1)
-				& WM8993_DCS_INTEG_CHAN_0_MASK;;
+				& WM8993_DCS_INTEG_CHAN_0_MASK;
 			reg_r = snd_soc_read(codec, WM8993_DC_SERVO_READBACK_2)
 				& WM8993_DCS_INTEG_CHAN_1_MASK;
 			break;
-- 
1.7.3.1.g432b3.dirty

