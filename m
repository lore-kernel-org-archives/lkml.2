Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648Ab2KDFUg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 01:20:36 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50661 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab2KDFU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 01:20:28 -0400
From: Daniel J Blueman <daniel@quora.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Jaroslav Kysela <perex@perex.cz>, linux-kernel@vger.kernel.org,
        Daniel J Blueman <daniel@quora.org>
Subject: [PATCH 2/2] HDA: Mark CS260x immutable structures const
Date: Sun,  4 Nov 2012 13:19:04 +0800
Message-Id: <1352006344-3378-2-git-send-email-daniel@quora.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1352006344-3378-1-git-send-email-daniel@quora.org>
References: <1352006344-3378-1-git-send-email-daniel@quora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark structures that won't change const.

Signed-off-by: Daniel J Blueman <daniel@quora.org>
---
 sound/pci/hda/patch_cirrus.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/sound/pci/hda/patch_cirrus.c b/sound/pci/hda/patch_cirrus.c
index 859a119..d5f3a26 100644
--- a/sound/pci/hda/patch_cirrus.c
+++ b/sound/pci/hda/patch_cirrus.c
@@ -1732,8 +1732,7 @@ static int cs421x_mux_enum_put(struct snd_kcontrol *kcontrol,
 
 }
 
-static struct snd_kcontrol_new cs421x_capture_source = {
-
+static const struct snd_kcontrol_new cs421x_capture_source = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 	.name = "Capture Source",
 	.access = SNDRV_CTL_ELEM_ACCESS_READWRITE,
@@ -1950,7 +1949,7 @@ static int cs421x_suspend(struct hda_codec *codec)
 }
 #endif
 
-static struct hda_codec_ops cs421x_patch_ops = {
+static const struct hda_codec_ops cs421x_patch_ops = {
 	.build_controls = cs421x_build_controls,
 	.build_pcms = cs_build_pcms,
 	.init = cs421x_init,
-- 
1.7.10.4

