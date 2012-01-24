Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669Ab2AXCrX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:47:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50502 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932655Ab2AXCrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:47:18 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:32 2012
Message-Id: <20120124023932.471150203@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:35:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [096/129] ALSA: HDA: Fix internal microphone on Dell Studio 16 XPS 1645
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1059
Lines: 29

From: David Henningsson <david.henningsson@canonical.com>

commit ffe535edb9a9c5b4d5fe03dfa3d89a1495580f1b upstream.

More than one user reports that changing the model from "both" to
"dmic" makes their Internal Mic work.

Tested-by: Martin Ling <martin-launchpad@earth.li>
BugLink: https://bugs.launchpad.net/bugs/795823
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_sigmatel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -1631,7 +1631,7 @@ static const struct snd_pci_quirk stac92
 	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x02bd,
 				"Dell Studio 1557", STAC_DELL_M6_DMIC),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x02fe,
-				"Dell Studio XPS 1645", STAC_DELL_M6_BOTH),
+				"Dell Studio XPS 1645", STAC_DELL_M6_DMIC),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x0413,
 				"Dell Studio 1558", STAC_DELL_M6_DMIC),
 	{} /* terminator */


