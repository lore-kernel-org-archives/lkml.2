Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296Ab1EFAZ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:25:27 -0400
Received: from kroah.org ([198.145.64.141]:36996 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932306Ab1EFAZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:25:20 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:13 2011
Message-Id: <20110506002213.445446107@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:21:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [084/143] ALSA: hda - Add model=mbp55 entry for MacBookPro 7,1
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit f46119b73425df9d1e05c5d5e909a993d95b0218 upstream.

Reference: Novell bnc#645066
	https://bugzilla.novell.com/show_bug.cgi?id=645066

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 sound/pci/hda/patch_cirrus.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_cirrus.c
+++ b/sound/pci/hda/patch_cirrus.c
@@ -1091,6 +1091,7 @@ static const char *cs420x_models[CS420X_
 static struct snd_pci_quirk cs420x_cfg_tbl[] = {
 	SND_PCI_QUIRK(0x10de, 0x0ac0, "MacBookPro 5,3", CS420X_MBP53),
 	SND_PCI_QUIRK(0x10de, 0xcb79, "MacBookPro 5,5", CS420X_MBP55),
+	SND_PCI_QUIRK(0x10de, 0xcb89, "MacBookPro 7,1", CS420X_MBP55),
 	SND_PCI_QUIRK(0x8086, 0x7270, "IMac 27 Inch", CS420X_IMAC27),
 	{} /* terminator */
 };


