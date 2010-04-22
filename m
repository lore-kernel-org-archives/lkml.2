Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347Ab0DVT2w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:28:52 -0400
Received: from kroah.org ([198.145.64.141]:40967 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756524Ab0DVT2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:28:47 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:16 2010
Message-Id: <20100422190916.060322829@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:09:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Joerg Schirottke <master@kanotix.com>, Takashi Iwai <tiwai@suse.de>
Subject: [097/197] ALSA: hda - add a quirk for Clevo M570U laptop
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Joerg Schirottke <master@kanotix.com>

commit d1501ea844eefdf925f6b711875b4b2b928fddf8 upstream.

Added the matching model for Clevo laptop M570U.

Signed-off-by: Joerg Schirottke <master@kanotix.com>
Tested-by: Maximilian Gerhard <maxbox@directbox.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8895,6 +8895,7 @@ static struct snd_pci_quirk alc882_cfg_t
 	SND_PCI_QUIRK(0x1462, 0xaa08, "MSI", ALC883_TARGA_2ch_DIG),
 
 	SND_PCI_QUIRK(0x147b, 0x1083, "Abit IP35-PRO", ALC883_6ST_DIG),
+	SND_PCI_QUIRK(0x1558, 0x0571, "Clevo laptop M570U", ALC883_3ST_6ch_DIG),
 	SND_PCI_QUIRK(0x1558, 0x0721, "Clevo laptop M720R", ALC883_CLEVO_M720),
 	SND_PCI_QUIRK(0x1558, 0x0722, "Clevo laptop M720SR", ALC883_CLEVO_M720),
 	SND_PCI_QUIRK(0x1558, 0x5409, "Clevo laptop M540R", ALC883_CLEVO_M540R),


