Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab1KMWGI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 17:06:08 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:13676 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab1KMWGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 17:06:07 -0500
Date: Sun, 13 Nov 2011 23:11:50 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Jiri Kosina <trivial@kernel.org>,
        David Henningsson <david.henningsson@canonical.com>,
        Kailang Yang <kailang@realtek.com>,
        Kailang Yang <kailang@realtek.com.tw>,
        PeiSen Hou <pshou@realtek.com.tw>,
        Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Subject: [PATCH] [Trivial] sound, realtek: remove redundant semicolon
Message-ID: <alpine.LNX.2.00.1111132308530.3681@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having just one semicolon after a break statement is enough.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 sound/pci/hda/patch_realtek.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 308bb57..336d14e 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -1452,7 +1452,7 @@ static void alc_apply_fixup(struct hda_codec *codec, int action)
 		switch (fix->type) {
 		case ALC_FIXUP_SKU:
 			if (action != ALC_FIXUP_ACT_PRE_PROBE || !fix->v.sku)
-				break;;
+				break;
 			snd_printdd(KERN_INFO "hda_codec: %s: "
 				    "Apply sku override for %s\n",
 				    codec->chip_name, modelname);
-- 
1.7.7.3


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

