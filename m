Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965152Ab2EOCRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:17:23 -0400
Received: from mail.windriver.com ([147.11.1.11]:49071 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964877Ab2EOCQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:15 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 020/179] ASoC: Ensure output PGA is enabled for line outputs in wm_hubs
Date: Mon, 14 May 2012 22:11:56 -0400
Message-ID: <1337048075-6132-21-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit d0b48af6c2b887354d0893e598d92911ce52620e upstream.

Also fix a left/right typo while we're at it.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Liam Girdwood <lrg@ti.com.
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/soc/codecs/wm_hubs.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/sound/soc/codecs/wm_hubs.c b/sound/soc/codecs/wm_hubs.c
index db6122f..4f1d50b 100644
--- a/sound/soc/codecs/wm_hubs.c
+++ b/sound/soc/codecs/wm_hubs.c
@@ -748,17 +748,17 @@ static const struct snd_soc_dapm_route analogue_routes[] = {
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
@@ -767,17 +767,17 @@ static const struct snd_soc_dapm_route lineout1_se_routes[] = {
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
-- 
1.7.9.6

