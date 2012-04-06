Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300Ab2DFNe2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 09:34:28 -0400
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:56529 "EHLO
	outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756653Ab2DFNe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 09:34:26 -0400
From: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
To: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
        David Henningsson <david.henningsson@canonical.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] ALSA: hda - Rename capture sources of CX20549 to match common conventions
Date: Fri,  6 Apr 2012 15:34:16 +0200
Message-Id: <1333719260-14504-3-git-send-email-kernel@mkarcher.dialup.fu-berlin.de>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1333719260-14504-1-git-send-email-kernel@mkarcher.dialup.fu-berlin.de>
References: <s5hk41ufe2j.wl%tiwai@suse.de>
 <1333719260-14504-1-git-send-email-kernel@mkarcher.dialup.fu-berlin.de>
X-Originating-IP: 87.123.69.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This includes renaming "Line In" to line, also in the mixer settings.

Signed-off-by: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
---
 sound/pci/hda/patch_conexant.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 60890ef..ab2cf5c 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -686,27 +686,27 @@ static const struct hda_channel_mode cxt5045_modes[1] = {
 static const struct hda_input_mux cxt5045_capture_source = {
 	.num_items = 2,
 	.items = {
-		{ "IntMic", 0x1 },
-		{ "ExtMic", 0x2 },
+		{ "Internal Mic", 0x1 },
+		{ "Mic",          0x2 },
 	}
 };
 
 static const struct hda_input_mux cxt5045_capture_source_benq = {
 	.num_items = 5,
 	.items = {
-		{ "IntMic", 0x1 },
-		{ "ExtMic", 0x2 },
-		{ "LineIn", 0x3 },
-		{ "CD",     0x4 },
-		{ "Mixer",  0x0 },
+		{ "CD",           0x4 },
+		{ "Internal Mic", 0x1 },
+		{ "Mic",          0x2 },
+		{ "Line",         0x3 },
+		{ "Mixer",        0x0 },
 	}
 };
 
 static const struct hda_input_mux cxt5045_capture_source_hp530 = {
 	.num_items = 2,
 	.items = {
-		{ "ExtMic", 0x1 },
-		{ "IntMic", 0x2 },
+		{ "Mic",          0x1 },
+		{ "Internal Mic", 0x2 },
 	}
 };
 
@@ -826,10 +826,10 @@ static const struct snd_kcontrol_new cxt5045_benq_mixers[] = {
 	HDA_CODEC_VOLUME("CD Playback Volume", 0x17, 0x4, HDA_INPUT),
 	HDA_CODEC_MUTE("CD Playback Switch", 0x17, 0x4, HDA_INPUT),
 
-	HDA_CODEC_VOLUME("Line In Capture Volume", 0x1a, 0x03, HDA_INPUT),
-	HDA_CODEC_MUTE("Line In Capture Switch", 0x1a, 0x03, HDA_INPUT),
-	HDA_CODEC_VOLUME("Line In Playback Volume", 0x17, 0x3, HDA_INPUT),
-	HDA_CODEC_MUTE("Line In Playback Switch", 0x17, 0x3, HDA_INPUT),
+	HDA_CODEC_VOLUME("Line Capture Volume", 0x1a, 0x03, HDA_INPUT),
+	HDA_CODEC_MUTE("Line Capture Switch", 0x1a, 0x03, HDA_INPUT),
+	HDA_CODEC_VOLUME("Line Playback Volume", 0x17, 0x3, HDA_INPUT),
+	HDA_CODEC_MUTE("Line Playback Switch", 0x17, 0x3, HDA_INPUT),
 
 	HDA_CODEC_VOLUME("Mixer Capture Volume", 0x1a, 0x0, HDA_INPUT),
 	HDA_CODEC_MUTE("Mixer Capture Switch", 0x1a, 0x0, HDA_INPUT),
-- 
1.7.9.1

