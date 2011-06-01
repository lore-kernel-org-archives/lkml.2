Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161823Ab1FAIO4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:14:56 -0400
Received: from cantor.suse.de ([195.135.220.2]:43720 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161815Ab1FAIOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:14:49 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:04:04 2011
Message-Id: <20110601080403.668828807@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:00:32 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [096/146] ASoC: Ensure output PGA is enabled for line outputs in
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

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
@@ -786,17 +786,17 @@ static const struct snd_soc_dapm_route a
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
@@ -805,17 +805,17 @@ static const struct snd_soc_dapm_route l
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


