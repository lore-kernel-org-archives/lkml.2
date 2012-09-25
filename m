Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab2IYXc0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 19:32:26 -0400
Received: from mail.fetzig.org ([5.9.244.169]:39929 "EHLO mail.fetzig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578Ab2IYXcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 19:32:24 -0400
X-Greylist: delayed 671 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Sep 2012 19:32:24 EDT
From: Felix Kaechele <felix@fetzig.org>
To: tiwai@suse.de
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Felix Kaechele <felix@fetzig.org>
Subject: [PATCH] ALSA: hda - Add inverted internal mic quirk for Lenovo IdeaPad U310
Date: Wed, 26 Sep 2012 01:20:44 +0200
Message-Id: <1348615244-26952-1-git-send-email-felix@fetzig.org>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Lenovo IdeaPad U310 has an internal mic where the right channel
is phase inverted.

Signed-off-by: Felix Kaechele <felix@fetzig.org>
---
 sound/pci/hda/patch_conexant.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 5e22a8f..784017e 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -4462,6 +4462,7 @@ static const struct snd_pci_quirk cxt5066_fixups[] = {
 	SND_PCI_QUIRK(0x17aa, 0x21ce, "Lenovo T420", CXT_PINCFG_LENOVO_TP410),
 	SND_PCI_QUIRK(0x17aa, 0x21cf, "Lenovo T520", CXT_PINCFG_LENOVO_TP410),
 	SND_PCI_QUIRK(0x17aa, 0x3975, "Lenovo U300s", CXT_FIXUP_STEREO_DMIC),
+	SND_PCI_QUIRK(0x17aa, 0x3977, "Lenovo IdeaPad U310", CXT_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x397b, "Lenovo S205", CXT_FIXUP_STEREO_DMIC),
 	{}
 };
-- 
1.7.11.4

