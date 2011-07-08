Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab1GHFDc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:03:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42180 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754464Ab1GHFDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:03:30 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:58 2011
Message-Id: <20110708001658.275230457@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:16:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [057/107] ALSA: HDA: Remove quirk for an HP device
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit 6f2e810ad5d162c2bfa063c1811087277b299e4e upstream.

The reporter, who is running kernel 2.6.38, reports that
he needs to set model=auto for the headphone output to work
correctly.

BugLink: http://bugs.launchpad.net/bugs/761022
Reported-by: Jo
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    1 -
 1 file changed, 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4607,7 +4607,6 @@ static struct snd_pci_quirk alc880_cfg_t
 	SND_PCI_QUIRK(0x1025, 0xe309, "ULI", ALC880_3ST_DIG),
 	SND_PCI_QUIRK(0x1025, 0xe310, "ULI", ALC880_3ST),
 	SND_PCI_QUIRK(0x1039, 0x1234, NULL, ALC880_6ST_DIG),
-	SND_PCI_QUIRK(0x103c, 0x2a09, "HP", ALC880_5ST),
 	SND_PCI_QUIRK(0x1043, 0x10b3, "ASUS W1V", ALC880_ASUS_W1V),
 	SND_PCI_QUIRK(0x1043, 0x10c2, "ASUS W6A", ALC880_ASUS_DIG),
 	SND_PCI_QUIRK(0x1043, 0x10c3, "ASUS Wxx", ALC880_ASUS_DIG),


