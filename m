Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab1AFBEC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 20:04:02 -0500
Received: from kroah.org ([198.145.64.141]:35365 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611Ab1AFA2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:28:46 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:22:57 2011
Message-Id: <20110106002257.107394986@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:21:43 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [004/152] ALSA: HDA: Quirk for Dell Vostro 320 to make microphone work
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit 8a96b1e02029aa512199b1b6d281dcede9ed81f1 upstream.

BugLink: http://launchpad.net/497546

Confirmed that the ideapad model works better than the current
quirk for Dell Vostro 320.

Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_conexant.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -3085,8 +3085,7 @@ static const char *cxt5066_models[CXT506
 static struct snd_pci_quirk cxt5066_cfg_tbl[] = {
 	SND_PCI_QUIRK(0x14f1, 0x0101, "Conexant Reference board",
 		      CXT5066_LAPTOP),
-	SND_PCI_QUIRK(0x1028, 0x02f5, "Dell",
-		      CXT5066_DELL_LAPTOP),
+	SND_PCI_QUIRK(0x1028, 0x02f5, "Dell Vostro 320", CXT5066_IDEAPAD),
 	SND_PCI_QUIRK(0x152d, 0x0833, "OLPC XO-1.5", CXT5066_OLPC_XO_1_5),
 	SND_PCI_QUIRK(0x1028, 0x02d8, "Dell Vostro", CXT5066_DELL_VOSTO),
 	SND_PCI_QUIRK(0x1028, 0x0402, "Dell Vostro", CXT5066_DELL_VOSTO),


