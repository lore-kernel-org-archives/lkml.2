Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354Ab2LMOva (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:51:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44371 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586Ab2LMOGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:06:02 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 086/241] ALSA: hda - Add a missing quirk entry for iMac 9,1
Date: Thu, 13 Dec 2012 11:57:31 -0200
Message-Id: <1355407206-17100-87-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 05193639ca977cc889668718adb38db6d585045b upstream.

This is another variant of iMac 9,1 with a different codec SSID.

Reported-and-tested-by: Everaldo Canuto <everaldo.canuto@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index be2618c..f4f8dcf 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5289,6 +5289,7 @@ static const struct snd_pci_quirk alc882_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x106b, 0x4000, "MacbookPro 5,1", ALC889_FIXUP_IMAC91_VREF),
 	SND_PCI_QUIRK(0x106b, 0x4100, "Macmini 3,1", ALC889_FIXUP_IMAC91_VREF),
 	SND_PCI_QUIRK(0x106b, 0x4200, "Mac Pro 5,1", ALC885_FIXUP_MACPRO_GPIO),
+	SND_PCI_QUIRK(0x106b, 0x4300, "iMac 9,1", ALC889_FIXUP_IMAC91_VREF),
 	SND_PCI_QUIRK(0x106b, 0x4600, "MacbookPro 5,2", ALC889_FIXUP_IMAC91_VREF),
 	SND_PCI_QUIRK(0x106b, 0x4900, "iMac 9,1 Aluminum", ALC889_FIXUP_IMAC91_VREF),
 	SND_PCI_QUIRK(0x106b, 0x4a00, "Macbook 5,2", ALC889_FIXUP_IMAC91_VREF),
-- 
1.7.9.5

