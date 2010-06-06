Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab0FFXJr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 19:09:47 -0400
Received: from mail-pz0-f185.google.com ([209.85.222.185]:63953 "EHLO
	mail-pz0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab0FFXJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 19:09:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=PeRKf8aEK1PnQXDA27P27d1B/y2gQLsuF9NfrFSXAvmwaRJITxxf6NbTaemKk570Iz
         5/YeOuVu2AB3jy299PtSogSTBbXE+SrvJQpWSpovmWZqijx9ztwfu50d9lF5derlea7v
         tff7f8qWm9rbOptBPL3Flxy4QgCtfkw9PhIU0=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: alsa-devel@alsa-project.org
Cc: tiwai@suse.de, linux-kernel@vger.kernel.org,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 1/5]alsa:patch_realtek.c Add SSID table for MacBookAir2,1
Date: Sun,  6 Jun 2010 16:09:49 -0700
Message-Id: <1275865793-7357-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the SSID number to snd_pci_quirk for the
MacBookAir2,1 taken from codec#0 at:
http://launchpadlibrarian.net/49455483/Card0.Codecs.codec.0.txt
keep in mind I do not have one of these machines on hand
so please if you do have this machine please test for me..
 
 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 17d4548..9b82d28 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9487,6 +9487,7 @@ static struct snd_pci_quirk alc882_ssid_cfg_tbl[] = {
 	SND_PCI_QUIRK(0x106b, 0x4000, "MacbookPro 5,1", ALC885_MB5),
 	SND_PCI_QUIRK(0x106b, 0x4600, "MacbookPro 5,2", ALC885_MB5),
 	SND_PCI_QUIRK(0x106b, 0x4100, "Macmini 3,1", ALC885_MACMINI3),
+	SND_PCI_QUIRK(0x106b, 0x3500, "MacBookAir 2,1", ALC885_MBA21),
 	{} /* terminator */
 };
 
-- 
1.6.5.2.180.gc5b3e

