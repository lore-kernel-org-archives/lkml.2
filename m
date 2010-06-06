Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab0FFXKT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 19:10:19 -0400
Received: from mail-pz0-f185.google.com ([209.85.222.185]:63953 "EHLO
	mail-pz0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724Ab0FFXJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 19:09:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=csMXEAMAKFMHQXuZoYqHDYWLnsAvsoO3ip4wUv/JglLaoXj8gTbdt79Z1KwmhIcLMJ
         7EXHp4aNQmwn2UGv7uImzAuM9uayjVMAiWO+SPzbPs12L0+A+NM3Ak9pp2GQ9yatmPc6
         gV0d+bV1OpM7g3NhAwnc08U50x4xvMuiwuVpI=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: alsa-devel@alsa-project.org
Cc: tiwai@suse.de, linux-kernel@vger.kernel.org,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 5/5]alsa:patch_realtek.c Add SSID table for iMac7,1.
Date: Sun,  6 Jun 2010 16:09:53 -0700
Message-Id: <1275865793-7357-5-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
In-Reply-To: <1275865793-7357-4-git-send-email-justinmattock@gmail.com>
References: <1275865793-7357-1-git-send-email-justinmattock@gmail.com>
 <1275865793-7357-2-git-send-email-justinmattock@gmail.com>
 <1275865793-7357-3-git-send-email-justinmattock@gmail.com>
 <1275865793-7357-4-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note: This patch does not work with Patch 4/5
(Add-support-for-the-iMac7-1).

This patch add's the iMac7,1 SSID entry to
patch_realtek.c which adds sound support.
bug entry:
https://bugs.launchpad.net/mactel-support/+bug/360866

Note:I do not have this machine on hand only
codec#0 file for the machine so please
test if you have the appropriate equipment.

 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/sound/alsa/HD-Audio-Models.txt |    1 +
 sound/pci/hda/patch_realtek.c                |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/Documentation/sound/alsa/HD-Audio-Models.txt b/Documentation/sound/alsa/HD-Audio-Models.txt
index 1d38b0d..a9aac53 100644
--- a/Documentation/sound/alsa/HD-Audio-Models.txt
+++ b/Documentation/sound/alsa/HD-Audio-Models.txt
@@ -127,6 +127,7 @@ ALC882/883/885/888/889
   macmini3	Macmini 3,1
   mba21		Macbook Air 2,1
   mbp3		Macbook Pro rev3
+  imac71	iMac 7,1
   imac24	iMac 24'' with jack detection
   imac91	iMac 9,1
   w2jc		ASUS W2JC
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 17d4548..a4f71fb 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9478,6 +9478,7 @@ static struct snd_pci_quirk alc882_ssid_cfg_tbl[] = {
 	SND_PCI_QUIRK(0x106b, 0x2c00, "MacbookPro rev3", ALC885_MBP3),
 	SND_PCI_QUIRK(0x106b, 0x3600, "Macbook 3,1", ALC889A_MB31),
 	SND_PCI_QUIRK(0x106b, 0x3800, "MacbookPro 4,1", ALC885_MBP3),
+	SND_PCI_QUIRK(0x106b, 0x3200, "iMac 7,1 Aluminum", ALC882_ASUS_A7M),
 	SND_PCI_QUIRK(0x106b, 0x3e00, "iMac 24 Aluminum", ALC885_IMAC24),
 	SND_PCI_QUIRK(0x106b, 0x4900, "iMac 9,1 Aluminum", ALC885_IMAC91),
 	SND_PCI_QUIRK(0x106b, 0x3f00, "Macbook 5,1", ALC885_MB5),
-- 
1.6.5.2.180.gc5b3e

