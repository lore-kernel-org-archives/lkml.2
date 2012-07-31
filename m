Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab2GaEum (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 00:50:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48738 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755179Ab2GaEuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 00:50:39 -0400
Message-Id: <20120731044319.296239685@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 31 Jul 2012 05:44:00 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Ray Chen <ray.chen@canonical.com>, Takashi Iwai <tiwai@suse.de>
Subject: [ 50/73] ALSA: hda - Add support for Realtek ALC282
In-Reply-To: <20120731044310.013763753@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit 4e01ec636e64707d202a1ca21a47bbc6d53085b7 upstream.

This codec has a separate dmic path (separate dmic only ADC),
and thus it looks mostly like ALC275.

BugLink: https://bugs.launchpad.net/bugs/1025377
Tested-by: Ray Chen <ray.chen@canonical.com>
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index a5b0b50..aef3139 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6988,6 +6988,7 @@ static const struct hda_codec_preset snd_hda_preset_realtek[] = {
 	{ .id = 0x10ec0275, .name = "ALC275", .patch = patch_alc269 },
 	{ .id = 0x10ec0276, .name = "ALC276", .patch = patch_alc269 },
 	{ .id = 0x10ec0280, .name = "ALC280", .patch = patch_alc269 },
+	{ .id = 0x10ec0282, .name = "ALC282", .patch = patch_alc269 },
 	{ .id = 0x10ec0861, .rev = 0x100340, .name = "ALC660",
 	  .patch = patch_alc861 },
 	{ .id = 0x10ec0660, .name = "ALC660-VD", .patch = patch_alc861vd },


