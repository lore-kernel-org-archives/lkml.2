Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab1FPHZy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:25:54 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:53036 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756426Ab1FPHFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:05:34 -0400
X-Sasl-enc: C2ECFBV0vF9wWP8zt6BCVc9HQ1hIEDuSNc9Zx6EUb1y3 1308207933
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:16:11 2011
Message-Id: <20110616001611.576846018@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:15:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Subject: [23/91] ASoC: Ensure output PGA is enabled for line outputs in
In-Reply-To: <20110616001900.GA25375@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------
 wm_hubs

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit d0b48af6c2b887354d0893e598d92911ce52620e upstream.

Also fix a left/right typo while we're at it.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Liam Girdwood <lrg@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/wm_hubs.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/sound/soc/codecs/wm_hubs.c
+++ b/sound/soc/codecs/wm_hubs.c
@@ -639,17 +639,17 @@ static const struct snd_soc_dapm_route a
 static const struct snd_soc_dapm_route lineout1_diff_routes[] = {
 	{ "LINEOUT1 Mixer", "IN1L Switch", "IN1L PGA" },
 	{ "LINEOUT1 Mixer", "IN1R Switch", "IN1R PGA" },
-	{ "LINEOUT1 Mixer", "Output Switch", "Left Output Mixer" },
+	{ "LINEOUT1 Mixer", "Output Switch", "Left Output PGA" },
 
 	{ "LINEOUT1N Driver", NULL, "LINEOUT1 Mixer" },
 	{ "LINEOUT1P Driver", NULL, "LINEOUT1 Mixer" },
 };
 
 static const struct snd_soc_dapm_route lineout1_se_routes[] = {
-	{ "LINEOUT1N Mixer", "Left Output Switch", "Left Output Mixer" },
-	{ "LINEOUT1N Mixer", "Right Output Switch", "Left Output Mixer" },
+	{ "LINEOUT1N Mixer", "Left Output Switch", "Left Output PGA" },
+	{ "LINEOUT1N Mixer", "Right Output Switch", "Right Output PGA" },
 
-	{ "LINEOUT1P Mixer", "Left Output Switch", "Left Output Mixer" },
+	{ "LINEOUT1P Mixer", "Left Output Switch", "Left Output PGA" },
 
 	{ "LINEOUT1N Driver", NULL, "LINEOUT1N Mixer" },
 	{ "LINEOUT1P Driver", NULL, "LINEOUT1P Mixer" },
@@ -658,17 +658,17 @@ static const struct snd_soc_dapm_route l
 static const struct snd_soc_dapm_route lineout2_diff_routes[] = {
 	{ "LINEOUT2 Mixer", "IN2L Switch", "IN2L PGA" },
 	{ "LINEOUT2 Mixer", "IN2R Switch", "IN2R PGA" },
-	{ "LINEOUT2 Mixer", "Output Switch", "Right Output Mixer" },
+	{ "LINEOUT2 Mixer", "Output Switch", "Right Output PGA" },
 
 	{ "LINEOUT2N Driver", NULL, "LINEOUT2 Mixer" },
 	{ "LINEOUT2P Driver", NULL, "LINEOUT2 Mixer" },
 };
 
 static const struct snd_soc_dapm_route lineout2_se_routes[] = {
-	{ "LINEOUT2N Mixer", "Left Output Switch", "Left Output Mixer" },
-	{ "LINEOUT2N Mixer", "Right Output Switch", "Left Output Mixer" },
+	{ "LINEOUT2N Mixer", "Left Output Switch", "Left Output PGA" },
+	{ "LINEOUT2N Mixer", "Right Output Switch", "Right Output PGA" },
 
-	{ "LINEOUT2P Mixer", "Right Output Switch", "Right Output Mixer" },
+	{ "LINEOUT2P Mixer", "Right Output Switch", "Right Output PGA" },
 
 	{ "LINEOUT2N Driver", NULL, "LINEOUT2N Mixer" },
 	{ "LINEOUT2P Driver", NULL, "LINEOUT2P Mixer" },


