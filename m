Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936037Ab2KAP3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 11:29:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39596 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935828Ab2KAP25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 11:28:57 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, trivial@kernel.org, tiwai@suse.de,
        perex@perex.cz, alsa-devel@alsa-project.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] sound: Fix typo in drivers sound
Date: Fri,  2 Nov 2012 00:28:50 +0900
Message-Id: <1351783730-24714-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in debug messages within drivers/sound

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 sound/i2c/other/ak4113.c   | 2 +-
 sound/i2c/other/ak4114.c   | 2 +-
 sound/i2c/other/ak4117.c   | 2 +-
 sound/pci/rme9652/hdspm.c  | 2 +-
 sound/soc/codecs/cs42l52.c | 2 +-
 sound/soc/codecs/wm8994.c  | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/i2c/other/ak4113.c b/sound/i2c/other/ak4113.c
index ef68d71..e04e750 100644
--- a/sound/i2c/other/ak4113.c
+++ b/sound/i2c/other/ak4113.c
@@ -426,7 +426,7 @@ static struct snd_kcontrol_new snd_ak4113_iec958_controls[] = {
 },
 {
 	.iface =	SNDRV_CTL_ELEM_IFACE_PCM,
-	.name =		"IEC958 Preample Capture Default",
+	.name =		"IEC958 Preamble Capture Default",
 	.access =	SNDRV_CTL_ELEM_ACCESS_READ |
 		SNDRV_CTL_ELEM_ACCESS_VOLATILE,
 	.info =		snd_ak4113_spdif_pinfo,
diff --git a/sound/i2c/other/ak4114.c b/sound/i2c/other/ak4114.c
index 816e7d2..5bf4fca 100644
--- a/sound/i2c/other/ak4114.c
+++ b/sound/i2c/other/ak4114.c
@@ -401,7 +401,7 @@ static struct snd_kcontrol_new snd_ak4114_iec958_controls[] = {
 },
 {
 	.iface =	SNDRV_CTL_ELEM_IFACE_PCM,
-	.name =		"IEC958 Preample Capture Default",
+	.name =		"IEC958 Preamble Capture Default",
 	.access =	SNDRV_CTL_ELEM_ACCESS_READ | SNDRV_CTL_ELEM_ACCESS_VOLATILE,
 	.info =		snd_ak4114_spdif_pinfo,
 	.get =		snd_ak4114_spdif_pget,
diff --git a/sound/i2c/other/ak4117.c b/sound/i2c/other/ak4117.c
index b4b2a51..40e33c9 100644
--- a/sound/i2c/other/ak4117.c
+++ b/sound/i2c/other/ak4117.c
@@ -380,7 +380,7 @@ static struct snd_kcontrol_new snd_ak4117_iec958_controls[] = {
 },
 {
 	.iface =	SNDRV_CTL_ELEM_IFACE_PCM,
-	.name =		"IEC958 Preample Capture Default",
+	.name =		"IEC958 Preamble Capture Default",
 	.access =	SNDRV_CTL_ELEM_ACCESS_READ | SNDRV_CTL_ELEM_ACCESS_VOLATILE,
 	.info =		snd_ak4117_spdif_pinfo,
 	.get =		snd_ak4117_spdif_pget,
diff --git a/sound/pci/rme9652/hdspm.c b/sound/pci/rme9652/hdspm.c
index f1cd1e3..9a8d5ce 100644
--- a/sound/pci/rme9652/hdspm.c
+++ b/sound/pci/rme9652/hdspm.c
@@ -4899,7 +4899,7 @@ snd_hdspm_proc_read_madi(struct snd_info_entry * entry,
 		insel = "Coaxial";
 		break;
 	default:
-		insel = "Unkown";
+		insel = "Unknown";
 	}
 
 	snd_iprintf(buffer,
diff --git a/sound/soc/codecs/cs42l52.c b/sound/soc/codecs/cs42l52.c
index 6159929..4d8db36 100644
--- a/sound/soc/codecs/cs42l52.c
+++ b/sound/soc/codecs/cs42l52.c
@@ -763,7 +763,7 @@ static int cs42l52_set_sysclk(struct snd_soc_dai *codec_dai,
 	if ((freq >= CS42L52_MIN_CLK) && (freq <= CS42L52_MAX_CLK)) {
 		cs42l52->sysclk = freq;
 	} else {
-		dev_err(codec->dev, "Invalid freq paramter\n");
+		dev_err(codec->dev, "Invalid freq parameter\n");
 		return -EINVAL;
 	}
 	return 0;
diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index 11982bf..88dbabc 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -3734,7 +3734,7 @@ static irqreturn_t wm8958_mic_irq(int irq, void *data)
 	} while (count--);
 
 	if (count == 0)
-		dev_warn(codec->dev, "No impedence range reported for jack\n");
+		dev_warn(codec->dev, "No impedance range reported for jack\n");
 
 #ifndef CONFIG_SND_SOC_WM8994_MODULE
 	trace_snd_soc_jack_irq(dev_name(codec->dev));
-- 
1.8.0.rc3.16.g8ead1bf

