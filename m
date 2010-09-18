Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980Ab0IRTCL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:02:11 -0400
Received: from kroah.org ([198.145.64.141]:51081 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654Ab0IRTBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:10 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:53 2010
Message-Id: <20100918185953.150912958@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:57:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [004/123] ALSA: hda - Rename iMic to Int Mic on Lenovo NB0763
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=alsa-hda-rename-imic-to-int-mic-on-lenovo-nb0763.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Henningsson <david.henningsson@canonical.com>

commit 150b432f448281d5518f5229d240923f9a9c5459 upstream.

The non-standard name "iMic" makes PulseAudio ignore the microphone.
BugLink: https://launchpad.net/bugs/605101

Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6589,7 +6589,7 @@ static struct hda_input_mux alc883_lenov
 	.num_items = 4,
 	.items = {
 		{ "Mic", 0x0 },
-		{ "iMic", 0x1 },
+		{ "Int Mic", 0x1 },
 		{ "Line", 0x2 },
 		{ "CD", 0x4 },
 	},
@@ -8038,8 +8038,8 @@ static struct snd_kcontrol_new alc883_le
 	HDA_CODEC_MUTE("CD Playback Switch", 0x0b, 0x04, HDA_INPUT),
 	HDA_CODEC_VOLUME("Mic Playback Volume", 0x0b, 0x0, HDA_INPUT),
 	HDA_CODEC_MUTE("Mic Playback Switch", 0x0b, 0x0, HDA_INPUT),
-	HDA_CODEC_VOLUME("iMic Playback Volume", 0x0b, 0x1, HDA_INPUT),
-	HDA_CODEC_MUTE("iMic Playback Switch", 0x0b, 0x1, HDA_INPUT),
+	HDA_CODEC_VOLUME("Int Mic Playback Volume", 0x0b, 0x1, HDA_INPUT),
+	HDA_CODEC_MUTE("Int Mic Playback Switch", 0x0b, 0x1, HDA_INPUT),
 	{ } /* end */
 };
 


