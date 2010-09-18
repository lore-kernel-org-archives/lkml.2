Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642Ab0IRTOs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:14:48 -0400
Received: from kroah.org ([198.145.64.141]:43163 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756610Ab0IRTOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:14:44 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:12:57 2010
Message-Id: <20100918191257.874133793@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:11:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [007/129] ALSA: hda - Add Sony VAIO quirk for ALC269
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit dbbcbc073ad3132bfbc410b11546b2fb4bdf2568 upstream.

The attached patch enables playback on a Sony VAIO machine.

BugLink: http://launchpad.net/bugs/618271

Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -14244,6 +14244,7 @@ static const struct alc_fixup alc269_fix
 
 static struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x104d, 0x9071, "Sony VAIO", ALC269_FIXUP_SONY_VAIO),
+	SND_PCI_QUIRK(0x104d, 0x9077, "Sony VAIO", ALC269_FIXUP_SONY_VAIO),
 	{}
 };
 


