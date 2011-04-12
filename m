Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248Ab1DLOiF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:38:05 -0400
Received: from kroah.org ([198.145.64.141]:57550 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932183Ab1DLOiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:38:02 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:52 2011
Message-Id: <20110412143552.120626910@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:34:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [039/105] ALSA: HDA: Add dock mic quirk for Lenovo Thinkpad X220
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit 840126579da56edae8ecc4a0d85198f742982f10 upstream.

This quirk is needed for the docking station mic of
Lenovo Thinkpad X220 to function correctly.

BugLink: http://bugs.launchpad.net/bugs/746259
Tested-by: James Ferguson <james.ferguson@canonical.com>
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_conexant.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -3130,6 +3130,7 @@ static struct snd_pci_quirk cxt5066_cfg_
 	SND_PCI_QUIRK(0x17aa, 0x21c5, "Thinkpad Edge 13", CXT5066_THINKPAD),
 	SND_PCI_QUIRK(0x17aa, 0x21c6, "Thinkpad Edge 13", CXT5066_ASUS),
  	SND_PCI_QUIRK(0x17aa, 0x215e, "Lenovo Thinkpad", CXT5066_THINKPAD),
+	SND_PCI_QUIRK(0x17aa, 0x21da, "Lenovo X220", CXT5066_THINKPAD),
 	SND_PCI_QUIRK(0x17aa, 0x38af, "Lenovo G560", CXT5066_ASUS),
 	SND_PCI_QUIRK_VENDOR(0x17aa, "Lenovo", CXT5066_IDEAPAD), /* Fallback for Lenovos without dock mic */
 	{}


