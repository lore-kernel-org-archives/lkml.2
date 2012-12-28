Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004Ab2L1UBz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 15:01:55 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54844 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753979Ab2L1TQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:16:43 -0500
Message-Id: <20121228190331.530702712@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:03:37 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Wu Fengguang <fengguang.wu@intel.com>, Takashi Iwai <tiwai@suse.de>
Subject: [ 007/173] ALSA: hda - add id for Atom Cedar Trail HDMI codec
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wu Fengguang <fengguang.wu@intel.com>

commit 6edc59e602b36cd3c95a426ef6e8cad0344af8c7 upstream.

[the order sorted by tiwai]

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/hda/patch_hdmi.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 1168ebd..540cd13 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1912,6 +1912,7 @@ static const struct hda_codec_preset snd_hda_preset_hdmi[] = {
 { .id = 0x80862804, .name = "IbexPeak HDMI",	.patch = patch_generic_hdmi },
 { .id = 0x80862805, .name = "CougarPoint HDMI",	.patch = patch_generic_hdmi },
 { .id = 0x80862806, .name = "PantherPoint HDMI", .patch = patch_generic_hdmi },
+{ .id = 0x80862880, .name = "CedarTrail HDMI",	.patch = patch_generic_hdmi },
 { .id = 0x808629fb, .name = "Crestline HDMI",	.patch = patch_generic_hdmi },
 {} /* terminator */
 };
@@ -1958,6 +1959,7 @@ MODULE_ALIAS("snd-hda-codec-id:80862803");
 MODULE_ALIAS("snd-hda-codec-id:80862804");
 MODULE_ALIAS("snd-hda-codec-id:80862805");
 MODULE_ALIAS("snd-hda-codec-id:80862806");
+MODULE_ALIAS("snd-hda-codec-id:80862880");
 MODULE_ALIAS("snd-hda-codec-id:808629fb");
 
 MODULE_LICENSE("GPL");


