Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932598Ab2GASW0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 14:22:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46982 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932289Ab2GASQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:16:39 -0400
Message-Id: <20120701172012.655714726@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 01 Jul 2012 18:20:48 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Richard Crossley <richardcrossley@o2.co.uk>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 42/48] ALSA: hda - Add Realtek ALC280 codec support
In-Reply-To: <20120701172006.535271340@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit befae82e2906cb7155020876a531b0b8c6c8d8c8 upstream.

This chip looks very similar to ALC269 and ALC27* variants. The bug reporter
has verified that sound was working after this patch had been applied.

BugLink: https://bugs.launchpad.net/bugs/1017017
Tested-by: Richard Crossley <richardcrossley@o2.co.uk>
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 41475ae..a5534b3 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6800,6 +6800,7 @@ static const struct hda_codec_preset snd_hda_preset_realtek[] = {
 	{ .id = 0x10ec0272, .name = "ALC272", .patch = patch_alc662 },
 	{ .id = 0x10ec0275, .name = "ALC275", .patch = patch_alc269 },
 	{ .id = 0x10ec0276, .name = "ALC276", .patch = patch_alc269 },
+	{ .id = 0x10ec0280, .name = "ALC280", .patch = patch_alc269 },
 	{ .id = 0x10ec0861, .rev = 0x100340, .name = "ALC660",
 	  .patch = patch_alc861 },
 	{ .id = 0x10ec0660, .name = "ALC660-VD", .patch = patch_alc861vd },


