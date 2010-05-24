Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932817Ab0EXXbd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:31:33 -0400
Received: from kroah.org ([198.145.64.141]:59331 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932352Ab0EXXX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:23:29 -0400
X-Mailbox-Line: From gregkh@clark.site Mon May 24 16:18:13 2010
Message-Id: <20100524231813.739249079@clark.site>
User-Agent: quilt/0.48-8.10
Date: Mon, 24 May 2010 16:15:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Stefan Lippers-Hollmann <s.l-h@gmx.de>, Takashi Iwai <tiwai@suse.de>
Subject: [06/39] ALSA: Revert "ALSA: hda/realtek: quirk for D945GCLF2 mainboard"
In-Reply-To: <20100524231840.GA17857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Stefan Lippers-Hollmann <s.l-h@gmx.de>

commit 482c45331519524e4aeaf8a9084a445500822b85 upstream.

This reverts commit 7aee67466536bbf8bb44a95712c848a61c5a0acd.

As it doesn't seem to be universally valid for all mainboard revisions of
the D945GCLF2 and breaks snd-hda-intel/ snd-hda-codec-realtek on the Intel
Corporation "D945GCLF2" (LF94510J.86A.0229.2009.0729.0209) mainboard.

00:1b.0 Audio device [0403]: Intel Corporation N10/ICH 7 Family High Definition Audio Controller [8086:27d8] (rev 01)

Signed-off-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    1 -
 1 file changed, 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -17348,7 +17348,6 @@ static struct snd_pci_quirk alc662_cfg_t
 					ALC662_3ST_6ch_DIG),
 	SND_PCI_QUIRK_MASK(0x1854, 0xf000, 0x2000, "ASUS H13-200x",
 			   ALC663_ASUS_H13),
-	SND_PCI_QUIRK(0x8086, 0xd604, "Intel mobo", ALC662_3ST_2ch_DIG),
 	{}
 };
 


