Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255Ab1KCCNl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 22:13:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50539 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933108Ab1KCBe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:34:59 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:55 2011
Message-Id: <20111102221455.250296092@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:14:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Kailang Yang <kailang@realtek.com>, Takashi Iwai <tiwai@suse.de>
Subject: [056/107] ALSA: HDA: Add new revision for ALC662
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit cc667a72d471e79fd8e5e291ea115923cf44dca0 upstream.

The revision 0x100300 was found for ALC662. It seems to work well
with patch_alc662.

BugLink: http://bugs.launchpad.net/bugs/877373
Tested-by: Shengyao Xue <Shengyao.xue@canonical.com>
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Acked-by: Kailang Yang <kailang@realtek.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -17685,6 +17685,8 @@ static struct hda_codec_preset snd_hda_p
 	  .patch = patch_alc882 },
 	{ .id = 0x10ec0662, .rev = 0x100101, .name = "ALC662 rev1",
 	  .patch = patch_alc662 },
+	{ .id = 0x10ec0662, .rev = 0x100300, .name = "ALC662 rev3",
+	  .patch = patch_alc662 },
 	{ .id = 0x10ec0663, .name = "ALC663", .patch = patch_alc662 },
 	{ .id = 0x10ec0880, .name = "ALC880", .patch = patch_alc880 },
 	{ .id = 0x10ec0882, .name = "ALC882", .patch = patch_alc882 },


