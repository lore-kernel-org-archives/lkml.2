Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936086Ab1KJENk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:13:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44500 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965442Ab1KJDnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:43:13 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:54 2011
Message-Id: <20111109213154.683444571@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:32:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Axel Lin <axel.lin@gmail.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [125/264] ASoC: wm8996: Fix wrong mask for setting WM8996_AIF_CLOCKING_2
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@gmail.com>

commit 3205e6629bc0eb747fb7d1b4b8fec00b7b919e58 upstream.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Liam Girdwood <lrg@ti.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/wm8996.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/wm8996.c
+++ b/sound/soc/codecs/wm8996.c
@@ -1847,7 +1847,7 @@ static int wm8996_hw_params(struct snd_p
 	snd_soc_update_bits(codec, lrclk_reg, WM8996_AIF1RX_RATE_MASK,
 			    lrclk);
 	snd_soc_update_bits(codec, WM8996_AIF_CLOCKING_2,
-			    WM8996_DSP1_DIV_SHIFT << dsp_shift, dsp);
+			    WM8996_DSP1_DIV_MASK << dsp_shift, dsp);
 
 	return 0;
 }


