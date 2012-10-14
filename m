Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab2JNPIf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 11:08:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46291 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754493Ab2JNOm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:42:28 -0400
Message-Id: <20121014143548.496729030@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:37:22 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 109/147] ALSA: HDA: Add inverted internal mic quirk for Lenovo S205
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit b3c5dce81584391af8b6dedb0647e65c17aab3a2 upstream.

The Lenovo Ideapad S205 has an internal mic where the right channel
is phase inverted.

BugLink: https://bugs.launchpad.net/bugs/884652
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/hda/patch_conexant.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 172370b..2af0868 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -4466,6 +4466,7 @@ static const struct snd_pci_quirk cxt5066_fixups[] = {
 	SND_PCI_QUIRK(0x17aa, 0x21ce, "Lenovo T420", CXT_PINCFG_LENOVO_TP410),
 	SND_PCI_QUIRK(0x17aa, 0x21cf, "Lenovo T520", CXT_PINCFG_LENOVO_TP410),
 	SND_PCI_QUIRK(0x17aa, 0x3975, "Lenovo U300s", CXT_FIXUP_STEREO_DMIC),
+	SND_PCI_QUIRK(0x17aa, 0x397b, "Lenovo S205", CXT_FIXUP_STEREO_DMIC),
 	{}
 };
 


