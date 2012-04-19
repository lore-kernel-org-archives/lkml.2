Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932684Ab2DSVG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:06:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41537 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932669Ab2DSVGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:06:24 -0400
Message-Id: <20120419210304.754401116@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:03:22 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [ 19/75] ALSA: hda/realtek - Add a fixup entry for Acer Aspire 8940G
In-Reply-To: <20120419210322.GA6478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit fe97da1f7001ca0f572358462606eb3d1bde3f23 upstream.

It's compatible with 8930G.
Using the same fixup gives the proper 5.1 sound back.

Reported-and-tested-by: Dany Martineau <dany.luc.martineau@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4649,6 +4649,7 @@ static const struct snd_pci_quirk alc882
 		      ALC882_FIXUP_ACER_ASPIRE_4930G),
 	SND_PCI_QUIRK(0x1025, 0x0155, "Packard-Bell M5120", ALC882_FIXUP_PB_M5210),
 	SND_PCI_QUIRK(0x1025, 0x0259, "Acer Aspire 5935", ALC889_FIXUP_DAC_ROUTE),
+	SND_PCI_QUIRK(0x1025, 0x026b, "Acer Aspire 8940G", ALC882_FIXUP_ACER_ASPIRE_8930G),
 	SND_PCI_QUIRK(0x1025, 0x0296, "Acer Aspire 7736z", ALC882_FIXUP_ACER_ASPIRE_7736),
 	SND_PCI_QUIRK(0x1043, 0x13c2, "Asus A7M", ALC882_FIXUP_EAPD),
 	SND_PCI_QUIRK(0x1043, 0x1873, "ASUS W90V", ALC882_FIXUP_ASUS_W90V),


