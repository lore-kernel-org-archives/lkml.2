Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247Ab1ABILX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 03:11:23 -0500
Received: from mail.windriver.com ([147.11.1.11]:34251 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab1ABHVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:21:50 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 032/260] ALSA: hda - Rename iMic to Int Mic on Lenovo NB0763
Date: Sun,  2 Jan 2011 02:15:28 -0500
Message-Id: <1293952756-15010-33-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:20:41.0163 (UTC) FILETIME=[8FC7C9B0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Henningsson <david.henningsson@canonical.com>

commit 150b432f448281d5518f5229d240923f9a9c5459 upstream.

The non-standard name "iMic" makes PulseAudio ignore the microphone.
BugLink: https://launchpad.net/bugs/605101

Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/pci/hda/patch_realtek.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index aa93b0b..f310f3c 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6898,7 +6898,7 @@ static struct hda_input_mux alc883_lenovo_nb0763_capture_source = {
 	.num_items = 4,
 	.items = {
 		{ "Mic", 0x0 },
-		{ "iMic", 0x1 },
+		{ "Int Mic", 0x1 },
 		{ "Line", 0x2 },
 		{ "CD", 0x4 },
 	},
@@ -8473,8 +8473,8 @@ static struct snd_kcontrol_new alc883_lenovo_nb0763_mixer[] = {
 	HDA_CODEC_MUTE("CD Playback Switch", 0x0b, 0x04, HDA_INPUT),
 	HDA_CODEC_VOLUME("Mic Playback Volume", 0x0b, 0x0, HDA_INPUT),
 	HDA_CODEC_MUTE("Mic Playback Switch", 0x0b, 0x0, HDA_INPUT),
-	HDA_CODEC_VOLUME("iMic Playback Volume", 0x0b, 0x1, HDA_INPUT),
-	HDA_CODEC_MUTE("iMic Playback Switch", 0x0b, 0x1, HDA_INPUT),
+	HDA_CODEC_VOLUME("Int Mic Playback Volume", 0x0b, 0x1, HDA_INPUT),
+	HDA_CODEC_MUTE("Int Mic Playback Switch", 0x0b, 0x1, HDA_INPUT),
 	{ } /* end */
 };
 
-- 
1.7.3.3

