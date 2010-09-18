Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab0IRTkV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:40:21 -0400
Received: from kroah.org ([198.145.64.141]:43169 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753989Ab0IRTOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:14:44 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:12:58 2010
Message-Id: <20100918191257.956138243@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:11:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [008/129] ALSA: HDA: Use model=auto for LG R510
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit 81cd3fca642cecb40a1ccef099799dcb5730734b upstream.

Two users report model=auto is needed to make the internal mic work properly.
BugLink: https://bugs.launchpad.net/bugs/495134

Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    1 -
 1 file changed, 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -13305,7 +13305,6 @@ static struct snd_pci_quirk alc268_cfg_t
 	SND_PCI_QUIRK(0x14c0, 0x0025, "COMPAL IFL90/JFL-92", ALC268_TOSHIBA),
 	SND_PCI_QUIRK(0x152d, 0x0763, "Diverse (CPR2000)", ALC268_ACER),
 	SND_PCI_QUIRK(0x152d, 0x0771, "Quanta IL1", ALC267_QUANTA_IL1),
-	SND_PCI_QUIRK(0x1854, 0x1775, "LG R510", ALC268_DELL),
 	{}
 };
 


