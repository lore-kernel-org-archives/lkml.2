Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933041Ab0EJXPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:15:54 -0400
Received: from kroah.org ([198.145.64.141]:51821 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932864Ab0EJW6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:58:07 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:39 2010
Message-Id: <20100510223539.100780488@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:35:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Daniel T Chen <crimsun@ubuntu.com>, Takashi Iwai <tiwai@suse.de>
Subject: [52/98] ALSA: hda: Use ALC880_F1734 quirk for Fujitsu Siemens AMILO Xi 1526
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel T Chen <crimsun@ubuntu.com>

commit 3353541fe533350a22a03e2fb7dc085b35912575 upstream.

BugLink: https://launchpad.net/bugs/567494

The OR has verified that the existing model quirk, ALC880_UNIWILL,
is insufficient for audible playback and capture by default. Instead,
the ALC880_F1734 model quirk needs to be used.

This change is necessary for both 2.6.32.11 and 2.6.33.2.

Reported-by: Arnaud Malpeyre <amalpeyre@gmail.com>
Tested-by: Arnaud Malpeyre <amalpeyre@gmail.com>
Signed-off-by: Daniel T Chen <crimsun@ubuntu.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3971,7 +3971,7 @@ static struct snd_pci_quirk alc880_cfg_t
 	SND_PCI_QUIRK(0x1695, 0x4012, "EPox EP-5LDA", ALC880_5ST_DIG),
 	SND_PCI_QUIRK(0x1734, 0x107c, "FSC F1734", ALC880_F1734),
 	SND_PCI_QUIRK(0x1734, 0x1094, "FSC Amilo M1451G", ALC880_FUJITSU),
-	SND_PCI_QUIRK(0x1734, 0x10ac, "FSC", ALC880_UNIWILL),
+	SND_PCI_QUIRK(0x1734, 0x10ac, "FSC AMILO Xi 1526", ALC880_F1734),
 	SND_PCI_QUIRK(0x1734, 0x10b0, "Fujitsu", ALC880_FUJITSU),
 	SND_PCI_QUIRK(0x1854, 0x0018, "LG LW20", ALC880_LG_LW),
 	SND_PCI_QUIRK(0x1854, 0x003b, "LG", ALC880_LG),


