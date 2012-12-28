Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab2L1TWw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:22:52 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55729 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932486Ab2L1TT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:19:58 -0500
Message-Id: <20121228190334.825197123@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:03:53 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Duncan Roe <duncan_roe@acslink.net.au>, Takashi Iwai <tiwai@suse.de>
Subject: [ 023/173] ALSA: hda - Fix missing beep on ASUS X43U notebook
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duncan Roe <duncan_roe@acslink.net.au>

commit 7110005e8d5c3cd418fc4b64f9f124f004422a9a upstream.

Signed-off-by: Duncan Roe <duncan_roe@acslink.net.au>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 8568aee..7bec68c 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4245,6 +4245,7 @@ static void alc_auto_init_std(struct hda_codec *codec)
 	((spec)->beep_amp = HDA_COMPOSE_AMP_VAL(nid, 3, idx, dir))
 
 static const struct snd_pci_quirk beep_white_list[] = {
+	SND_PCI_QUIRK(0x1043, 0x103c, "ASUS", 1),
 	SND_PCI_QUIRK(0x1043, 0x829f, "ASUS", 1),
 	SND_PCI_QUIRK(0x1043, 0x83ce, "EeePC", 1),
 	SND_PCI_QUIRK(0x1043, 0x831a, "EeePC", 1),


