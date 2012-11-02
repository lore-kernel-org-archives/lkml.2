Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142Ab2KBOZi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 10:25:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51365 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab2KBOZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 10:25:36 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org, tiwai@suse.de,
        perex@perex.cz
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] sound: soc: Fix typo in sound/codecs
Date: Fri,  2 Nov 2012 23:25:30 +0900
Message-Id: <1351866330-5761-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in sound/soc/codecs

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 sound/soc/codecs/ab8500-codec.c | 2 +-
 sound/soc/codecs/wm8974.c       | 6 +++---
 sound/soc/codecs/wm8978.c       | 6 +++---
 sound/soc/codecs/wm8983.c       | 6 +++---
 sound/soc/codecs/wm8985.c       | 6 +++---
 5 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/sound/soc/codecs/ab8500-codec.c b/sound/soc/codecs/ab8500-codec.c
index af54749..f848878 100644
--- a/sound/soc/codecs/ab8500-codec.c
+++ b/sound/soc/codecs/ab8500-codec.c
@@ -2147,7 +2147,7 @@ static int ab8500_codec_set_dai_fmt(struct snd_soc_dai *dai, unsigned int fmt)
 	status = ab8500_codec_set_dai_clock_gate(codec, fmt);
 	if (status) {
 		dev_err(dai->codec->dev,
-			"%s: ERRROR: Failed to set clock gate (%d).\n",
+			"%s: ERROR: Failed to set clock gate (%d).\n",
 			__func__, status);
 		return status;
 	}
diff --git a/sound/soc/codecs/wm8974.c b/sound/soc/codecs/wm8974.c
index 9a39511..cc4c1c0 100644
--- a/sound/soc/codecs/wm8974.c
+++ b/sound/soc/codecs/wm8974.c
@@ -113,15 +113,15 @@ SOC_ENUM("Equaliser Function", wm8974_enum[3]),
 SOC_ENUM("EQ1 Cut Off", wm8974_enum[4]),
 SOC_SINGLE_TLV("EQ1 Volume", WM8974_EQ1,  0, 24, 1, eq_tlv),
 
-SOC_ENUM("Equaliser EQ2 Bandwith", wm8974_enum[5]),
+SOC_ENUM("Equaliser EQ2 Bandwidth", wm8974_enum[5]),
 SOC_ENUM("EQ2 Cut Off", wm8974_enum[6]),
 SOC_SINGLE_TLV("EQ2 Volume", WM8974_EQ2,  0, 24, 1, eq_tlv),
 
-SOC_ENUM("Equaliser EQ3 Bandwith", wm8974_enum[7]),
+SOC_ENUM("Equaliser EQ3 Bandwidth", wm8974_enum[7]),
 SOC_ENUM("EQ3 Cut Off", wm8974_enum[8]),
 SOC_SINGLE_TLV("EQ3 Volume", WM8974_EQ3,  0, 24, 1, eq_tlv),
 
-SOC_ENUM("Equaliser EQ4 Bandwith", wm8974_enum[9]),
+SOC_ENUM("Equaliser EQ4 Bandwidth", wm8974_enum[9]),
 SOC_ENUM("EQ4 Cut Off", wm8974_enum[10]),
 SOC_SINGLE_TLV("EQ4 Volume", WM8974_EQ4,  0, 24, 1, eq_tlv),
 
diff --git a/sound/soc/codecs/wm8978.c b/sound/soc/codecs/wm8978.c
index 5421fd9..4302071 100644
--- a/sound/soc/codecs/wm8978.c
+++ b/sound/soc/codecs/wm8978.c
@@ -166,15 +166,15 @@ static const struct snd_kcontrol_new wm8978_snd_controls[] = {
 	SOC_ENUM("EQ1 Cut Off", eq1),
 	SOC_SINGLE_TLV("EQ1 Volume", WM8978_EQ1,  0, 24, 1, eq_tlv),
 
-	SOC_ENUM("Equaliser EQ2 Bandwith", eq2bw),
+	SOC_ENUM("Equaliser EQ2 Bandwidth", eq2bw),
 	SOC_ENUM("EQ2 Cut Off", eq2),
 	SOC_SINGLE_TLV("EQ2 Volume", WM8978_EQ2,  0, 24, 1, eq_tlv),
 
-	SOC_ENUM("Equaliser EQ3 Bandwith", eq3bw),
+	SOC_ENUM("Equaliser EQ3 Bandwidth", eq3bw),
 	SOC_ENUM("EQ3 Cut Off", eq3),
 	SOC_SINGLE_TLV("EQ3 Volume", WM8978_EQ3,  0, 24, 1, eq_tlv),
 
-	SOC_ENUM("Equaliser EQ4 Bandwith", eq4bw),
+	SOC_ENUM("Equaliser EQ4 Bandwidth", eq4bw),
 	SOC_ENUM("EQ4 Cut Off", eq4),
 	SOC_SINGLE_TLV("EQ4 Volume", WM8978_EQ4,  0, 24, 1, eq_tlv),
 
diff --git a/sound/soc/codecs/wm8983.c b/sound/soc/codecs/wm8983.c
index d8879f2..494e42f 100644
--- a/sound/soc/codecs/wm8983.c
+++ b/sound/soc/codecs/wm8983.c
@@ -353,13 +353,13 @@ static const struct snd_kcontrol_new wm8983_snd_controls[] = {
 	SOC_ENUM_EXT("Equalizer Function", eqmode, eqmode_get, eqmode_put),
 	SOC_ENUM("EQ1 Cutoff", eq1_cutoff),
 	SOC_SINGLE_TLV("EQ1 Volume", WM8983_EQ1_LOW_SHELF,  0, 24, 1, eq_tlv),
-	SOC_ENUM("EQ2 Bandwith", eq2_bw),
+	SOC_ENUM("EQ2 Bandwidth", eq2_bw),
 	SOC_ENUM("EQ2 Cutoff", eq2_cutoff),
 	SOC_SINGLE_TLV("EQ2 Volume", WM8983_EQ2_PEAK_1, 0, 24, 1, eq_tlv),
-	SOC_ENUM("EQ3 Bandwith", eq3_bw),
+	SOC_ENUM("EQ3 Bandwidth", eq3_bw),
 	SOC_ENUM("EQ3 Cutoff", eq3_cutoff),
 	SOC_SINGLE_TLV("EQ3 Volume", WM8983_EQ3_PEAK_2, 0, 24, 1, eq_tlv),
-	SOC_ENUM("EQ4 Bandwith", eq4_bw),
+	SOC_ENUM("EQ4 Bandwidth", eq4_bw),
 	SOC_ENUM("EQ4 Cutoff", eq4_cutoff),
 	SOC_SINGLE_TLV("EQ4 Volume", WM8983_EQ4_PEAK_3, 0, 24, 1, eq_tlv),
 	SOC_ENUM("EQ5 Cutoff", eq5_cutoff),
diff --git a/sound/soc/codecs/wm8985.c b/sound/soc/codecs/wm8985.c
index 14f6663..3b37fc4 100644
--- a/sound/soc/codecs/wm8985.c
+++ b/sound/soc/codecs/wm8985.c
@@ -371,13 +371,13 @@ static const struct snd_kcontrol_new wm8985_snd_controls[] = {
 	SOC_ENUM_EXT("Equalizer Function", eqmode, eqmode_get, eqmode_put),
 	SOC_ENUM("EQ1 Cutoff", eq1_cutoff),
 	SOC_SINGLE_TLV("EQ1 Volume", WM8985_EQ1_LOW_SHELF,  0, 24, 1, eq_tlv),
-	SOC_ENUM("EQ2 Bandwith", eq2_bw),
+	SOC_ENUM("EQ2 Bandwidth", eq2_bw),
 	SOC_ENUM("EQ2 Cutoff", eq2_cutoff),
 	SOC_SINGLE_TLV("EQ2 Volume", WM8985_EQ2_PEAK_1, 0, 24, 1, eq_tlv),
-	SOC_ENUM("EQ3 Bandwith", eq3_bw),
+	SOC_ENUM("EQ3 Bandwidth", eq3_bw),
 	SOC_ENUM("EQ3 Cutoff", eq3_cutoff),
 	SOC_SINGLE_TLV("EQ3 Volume", WM8985_EQ3_PEAK_2, 0, 24, 1, eq_tlv),
-	SOC_ENUM("EQ4 Bandwith", eq4_bw),
+	SOC_ENUM("EQ4 Bandwidth", eq4_bw),
 	SOC_ENUM("EQ4 Cutoff", eq4_cutoff),
 	SOC_SINGLE_TLV("EQ4 Volume", WM8985_EQ4_PEAK_3, 0, 24, 1, eq_tlv),
 	SOC_ENUM("EQ5 Cutoff", eq5_cutoff),
-- 
1.8.0.rc3.16.g8ead1bf

