Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab1BYGQX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 01:16:23 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44453 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab1BYGQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 01:16:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Ivuh/T4AYOTxJNMm0JC/5c25rrqNL0ny1uI6zE8Fbt2eKgA+k/0RzfgztXqq8tAqH6
         iYGpmeafZKbqsbOyy/HyZxuyaXMo0WIMwQ54agGfOPdALXXKlPO+1FER6r/4kPWPDYnR
         M7reWJO6axgjyT50K0IY+9CryQLtNykaLTmJ4=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 20/21]sound:pci:hda:patch_realtek.c remove one to many l's in the word.
Date: Thu, 24 Feb 2011 22:16:02 -0800
Message-Id: <1298614562-4230-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an extra "l" in the word.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 sound/pci/hda/patch_realtek.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 3328a25..c5208c9 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4705,7 +4705,7 @@ static struct snd_pci_quirk alc880_cfg_tbl[] = {
 	SND_PCI_QUIRK(0x1558, 0x5401, "ASUS", ALC880_ASUS_DIG2),
 	SND_PCI_QUIRK(0x1565, 0x8202, "Biostar", ALC880_5ST_DIG),
 	SND_PCI_QUIRK(0x1584, 0x9050, "Uniwill", ALC880_UNIWILL_DIG),
-	SND_PCI_QUIRK(0x1584, 0x9054, "Uniwlll", ALC880_F1734),
+	SND_PCI_QUIRK(0x1584, 0x9054, "Uniwill", ALC880_F1734),
 	SND_PCI_QUIRK(0x1584, 0x9070, "Uniwill", ALC880_UNIWILL),
 	SND_PCI_QUIRK(0x1584, 0x9077, "Uniwill P53", ALC880_UNIWILL_P53),
 	SND_PCI_QUIRK(0x161f, 0x203d, "W810", ALC880_W810),
-- 
1.7.4.1

