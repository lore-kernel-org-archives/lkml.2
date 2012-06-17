Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759141Ab2FQSbc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:31:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50311 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758309Ab2FQSWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:22:50 -0400
Message-Id: <20120617175947.109775177@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Jun 2012 19:00:22 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 41/69] ALSA: hda - add support for Uniwill ECS M31EI notebook
In-Reply-To: <20120617175941.281333656@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaroslav Kysela <perex@perex.cz>

commit 416846d2b31fc740ed9d5a5ec116964fb43c4358 upstream.

This hardware requires same fixup for the node 0x0f like Asus A6Rp.
More information: https://bugzilla.redhat.com/show_bug.cgi?id=785417

Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 485a837..9350f3c 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5627,6 +5627,7 @@ static const struct alc_fixup alc861_fixups[] = {
 
 static const struct snd_pci_quirk alc861_fixup_tbl[] = {
 	SND_PCI_QUIRK_VENDOR(0x1043, "ASUS laptop", PINFIX_ASUS_A6RP),
+	SND_PCI_QUIRK(0x1584, 0x0000, "Uniwill ECS M31EI", PINFIX_ASUS_A6RP),	
 	SND_PCI_QUIRK(0x1584, 0x2b01, "Haier W18", PINFIX_ASUS_A6RP),
 	SND_PCI_QUIRK(0x1734, 0x10c7, "FSC Amilo Pi1505", PINFIX_FSC_AMILO_PI1505),
 	{}


