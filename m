Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964897Ab1KJDg3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:36:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43659 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964874Ab1KJDg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:36:26 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:45 2011
Message-Id: <20111109213145.869590145@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:31:24 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Kailang Yang <kailang@realtek.com>, Takashi Iwai <tiwai@suse.de>
Subject: [037/264] ALSA: HDA: Add new revision for ALC662
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5421,6 +5421,8 @@ static const struct hda_codec_preset snd
 	  .patch = patch_alc882 },
 	{ .id = 0x10ec0662, .rev = 0x100101, .name = "ALC662 rev1",
 	  .patch = patch_alc662 },
+	{ .id = 0x10ec0662, .rev = 0x100300, .name = "ALC662 rev3",
+	  .patch = patch_alc662 },
 	{ .id = 0x10ec0663, .name = "ALC663", .patch = patch_alc662 },
 	{ .id = 0x10ec0665, .name = "ALC665", .patch = patch_alc662 },
 	{ .id = 0x10ec0670, .name = "ALC670", .patch = patch_alc662 },


