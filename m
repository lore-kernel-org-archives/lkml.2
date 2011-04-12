Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932557Ab1DLOwv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:52:51 -0400
Received: from kroah.org ([198.145.64.141]:57556 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755614Ab1DLOiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:38:03 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:52 2011
Message-Id: <20110412143552.224457906@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:34:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [040/105] ALSA: HDA: Fix dock mic for Lenovo X220-tablet
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit b2cb1292b1c7c73abbdc0e07ef3aab056fc2615f upstream.

Without the "thinkpad" quirk, the dock mic in
Lenovo X220 tablet edition won't work.

BugLink: http://bugs.launchpad.net/bugs/751033
Tested-by: James Ferguson <james.ferguson@canonical.com>
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_conexant.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -3131,6 +3131,7 @@ static struct snd_pci_quirk cxt5066_cfg_
 	SND_PCI_QUIRK(0x17aa, 0x21c6, "Thinkpad Edge 13", CXT5066_ASUS),
  	SND_PCI_QUIRK(0x17aa, 0x215e, "Lenovo Thinkpad", CXT5066_THINKPAD),
 	SND_PCI_QUIRK(0x17aa, 0x21da, "Lenovo X220", CXT5066_THINKPAD),
+	SND_PCI_QUIRK(0x17aa, 0x21db, "Lenovo X220-tablet", CXT5066_THINKPAD),
 	SND_PCI_QUIRK(0x17aa, 0x38af, "Lenovo G560", CXT5066_ASUS),
 	SND_PCI_QUIRK_VENDOR(0x17aa, "Lenovo", CXT5066_IDEAPAD), /* Fallback for Lenovos without dock mic */
 	{}


