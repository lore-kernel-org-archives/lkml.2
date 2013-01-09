Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933334Ab3AIVhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:37:51 -0500
Received: from mail.kernel.org ([198.145.19.201]:42127 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933218Ab3AIUi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:38:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 26/80] ALSA: hda - Fix pin configuration of HP Pavilion dv7
Date: Wed,  9 Jan 2013 12:35:18 -0800
Message-Id: <20130109201503.715037224@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201500.410171651@linuxfoundation.org>
References: <20130109201500.410171651@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 8ae5865ec77c22462c736846a0679947a6953548 upstream.

Fix the quirk entry for HP Pavilion dv7 in order to make the bass
speaker working.

Reported-and-tested-by: Tomas Pospisek <tpo2@sourcepole.ch>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_sigmatel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -1695,7 +1695,7 @@ static const struct snd_pci_quirk stac92
 	SND_PCI_QUIRK(PCI_VENDOR_ID_HP, 0x1658,
 			  "HP", STAC_92HD83XXX_HP_cNB11_INTQUAD),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_HP, 0x1659,
-			  "HP", STAC_92HD83XXX_HP_cNB11_INTQUAD),
+			  "HP Pavilion dv7", STAC_HP_DV7_4000),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_HP, 0x165A,
 			  "HP", STAC_92HD83XXX_HP_cNB11_INTQUAD),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_HP, 0x165B,


