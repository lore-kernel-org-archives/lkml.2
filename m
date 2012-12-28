Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab2L1Tsw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:48:52 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55140 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754607Ab2L1TRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:17:51 -0500
Message-Id: <20121228190357.227896183@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:05:41 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 131/173] ALSA: hda - Fix pin configuration of HP Pavilion dv7
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 8ae5865ec77c22462c736846a0679947a6953548 upstream.

Fix the quirk entry for HP Pavilion dv7 in order to make the bass
speaker working.

Reported-and-tested-by: Tomas Pospisek <tpo2@sourcepole.ch>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/hda/patch_sigmatel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.c
index df13c0f..a86547c 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -1725,7 +1725,7 @@ static const struct snd_pci_quirk stac92hd83xxx_cfg_tbl[] = {
 	SND_PCI_QUIRK(PCI_VENDOR_ID_HP, 0x1658,
 			  "HP", STAC_92HD83XXX_HP_cNB11_INTQUAD),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_HP, 0x1659,
-			  "HP", STAC_92HD83XXX_HP_cNB11_INTQUAD),
+			  "HP Pavilion dv7", STAC_HP_DV7_4000),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_HP, 0x165A,
 			  "HP", STAC_92HD83XXX_HP_cNB11_INTQUAD),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_HP, 0x165B,


