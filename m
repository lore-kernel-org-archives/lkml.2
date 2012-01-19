Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab2ASVzt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 16:55:49 -0500
Received: from mailrelay01.solcon.nl ([212.45.32.107]:54735 "EHLO
	mailrelay01.solcon.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab2ASVzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 16:55:45 -0500
X-Greylist: delayed 2810 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jan 2012 16:55:45 EST
Subject: [PATCH] snd-hda-intel: better Alienware M17x R3 quirk
From: Albert Pool <albertpool@solcon.nl>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Jan 2012 22:08:50 +0100
Message-ID: <1327007330.1980.0.camel@albert-ASUSTeK-P4P800SE>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have been told that this way the rear headphone connector is
working as well; with model=alienware only laptop speakers work.
The subsystem of both controller and codec is 1028:0490.

Signed-off-by: Albert Pool <albertpool@solcon.nl>
---
 sound/pci/hda/patch_sigmatel.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.c
index 87e684f..4071354 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -1608,7 +1608,7 @@ static const struct snd_pci_quirk stac92hd73xx_codec_id_cfg_tbl[] = {
 	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x043a,
 		      "Alienware M17x", STAC_ALIENWARE_M17X),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x0490,
-		      "Alienware M17x", STAC_ALIENWARE_M17X),
+		      "Alienware M17x R3", STAC_DELL_EQ),
 	{} /* terminator */
 };
 
-- 
1.7.4.1


