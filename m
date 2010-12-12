Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab0LMAJs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:09:48 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36220 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755024Ab0LLXq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:46:59 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: crimsun@ubuntu.com, tiwai@suse.de, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [117/223] ALSA: hda: Add Samsung R720 SSID for subwoofer pin fixup
Message-Id: <20101212234658.714AAB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:58 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Daniel T Chen <crimsun@ubuntu.com>

commit a0e90acc657990511c83bc69965bfd3c63386d45 upstream.

BugLink: https://launchpad.net/bugs/677830

The original reporter states that the subwoofer does not mute when
inserting headphones.  We need an entry for his machine's SSID in the
subwoofer pin fixup list, so add it there (verified using hda_analyzer).

Reported-and-tested-by: i-NoD
Signed-off-by: Daniel T Chen <crimsun@ubuntu.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/sound/pci/hda/patch_realtek.c
===================================================================
--- linux.orig/sound/pci/hda/patch_realtek.c
+++ linux/sound/pci/hda/patch_realtek.c
@@ -18701,6 +18701,7 @@ static const struct alc_fixup alc662_fix
 
 static struct snd_pci_quirk alc662_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1025, 0x038b, "Acer Aspire 8943G", ALC662_FIXUP_ASPIRE),
+	SND_PCI_QUIRK(0x144d, 0xc051, "Samsung R720", ALC662_FIXUP_IDEAPAD),
 	SND_PCI_QUIRK(0x17aa, 0x38af, "Lenovo Ideapad Y550P", ALC662_FIXUP_IDEAPAD),
 	SND_PCI_QUIRK(0x17aa, 0x3a0d, "Lenovo Ideapad Y550", ALC662_FIXUP_IDEAPAD),
 	{}
