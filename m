Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab2DHWkf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 18:40:35 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12301 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985Ab2DHWke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 18:40:34 -0400
Date: Mon, 9 Apr 2012 00:40:32 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: trivial@kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH][Trivial] Delete trailing whitespace from
 sound/soc/codecs/wm8994.c
Message-ID: <alpine.LNX.2.00.1204090038270.11747@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While reading through sound/soc/codecs/wm8994.c I noticed a fair
amount of trailing whitespace. This patch gets rid of it.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 sound/soc/codecs/wm8994.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index 7c49642..c6c2cb2 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -398,7 +398,7 @@ static void wm8994_set_retune_mobile(struct snd_soc_codec *codec, int block)
 		wm8994->dac_rates[iface]);
 
 	/* The EQ will be disabled while reconfiguring it, remember the
-	 * current configuration. 
+	 * current configuration.
 	 */
 	save = snd_soc_read(codec, base);
 	save &= WM8994_AIF1DAC1_EQ_ENA;
@@ -991,7 +991,7 @@ static void wm8994_update_class_w(struct snd_soc_codec *codec)
 				    WM8994_CP_DYN_SRC_SEL_MASK,
 				    source | WM8994_CP_DYN_PWR);
 		wm8994->hubs.class_w = true;
-		
+
 	} else {
 		dev_dbg(codec->dev, "Class W disabled\n");
 		snd_soc_update_bits(codec, WM8994_CLASS_W_1,
@@ -1358,7 +1358,7 @@ static const struct snd_kcontrol_new wm8958_aif3adc_mux =
 	SOC_DAPM_ENUM("AIF3ADC Mux", wm8958_aif3adc_enum);
 
 static const char *mono_pcm_out_text[] = {
-	"None", "AIF2ADCL", "AIF2ADCR", 
+	"None", "AIF2ADCL", "AIF2ADCR",
 };
 
 static const struct soc_enum mono_pcm_out_enum =
@@ -2122,7 +2122,7 @@ static int wm8994_set_dai_sysclk(struct snd_soc_dai *dai,
 
 	case WM8994_SYSCLK_OPCLK:
 		/* Special case - a division (times 10) is given and
-		 * no effect on main clocking. 
+		 * no effect on main clocking.
 		 */
 		if (freq) {
 			for (i = 0; i < ARRAY_SIZE(opclk_divs); i++)
@@ -2958,14 +2958,14 @@ static void wm8994_handle_retune_mobile_pdata(struct wm8994_priv *wm8994)
 
 		/* Expand the array... */
 		t = krealloc(wm8994->retune_mobile_texts,
-			     sizeof(char *) * 
+			     sizeof(char *) *
 			     (wm8994->num_retune_mobile_texts + 1),
 			     GFP_KERNEL);
 		if (t == NULL)
 			continue;
 
 		/* ...store the new entry... */
-		t[wm8994->num_retune_mobile_texts] = 
+		t[wm8994->num_retune_mobile_texts] =
 			pdata->retune_mobile_cfgs[i].name;
 
 		/* ...and remember the new version. */
@@ -3907,7 +3907,6 @@ static int wm8994_codec_probe(struct snd_soc_codec *codec)
 					  ARRAY_SIZE(wm8994_dac_widgets));
 		break;
 	}
-		
 
 	wm_hubs_add_analogue_routes(codec, 0, 0);
 	snd_soc_dapm_add_routes(dapm, intercon, ARRAY_SIZE(intercon));
-- 
1.7.10


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

