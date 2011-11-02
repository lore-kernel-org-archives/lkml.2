Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934547Ab1KCBlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:41:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51269 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934471Ab1KCBlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:41:07 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:27:45 2011
Message-Id: <20111102222744.954495108@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:26:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Kailang Yang <kailang@realtek.com>, Takashi Iwai <tiwai@suse.de>
Subject: [057/101] ALSA: HDA: Add new revision for ALC662
In-Reply-To: <20111102222755.GA10893@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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
@@ -18117,6 +18117,8 @@ static struct hda_codec_preset snd_hda_p
 	  .patch = patch_alc882 },
 	{ .id = 0x10ec0662, .rev = 0x100101, .name = "ALC662 rev1",
 	  .patch = patch_alc662 },
+	{ .id = 0x10ec0662, .rev = 0x100300, .name = "ALC662 rev3",
+	  .patch = patch_alc662 },
 	{ .id = 0x10ec0663, .name = "ALC663", .patch = patch_alc662 },
 	{ .id = 0x10ec0880, .name = "ALC880", .patch = patch_alc880 },
 	{ .id = 0x10ec0882, .name = "ALC882", .patch = patch_alc882 },


