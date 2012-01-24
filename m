Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932651Ab2AXCrR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:47:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50489 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932599Ab2AXCrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:47:11 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:32 2012
Message-Id: <20120124023932.282116159@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:35:14 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [094/129] ALSA: HDA: Use LPIB position fix for Macbook Pro 7,1
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1182
Lines: 29

From: David Henningsson <david.henningsson@canonical.com>

commit b01de4fb40137fbda7530550ff0cd37171dafb0c upstream.

Several users have reported "choppy" audio under the 3.2 kernel,
and that changing position_fix to 1 has resolved their problem.
The chip is an nVidia Corporation MCP89 High Definition Audio,
[10de:0d94] (rev a2).

BugLink: https://bugs.launchpad.net/bugs/909419
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/hda_intel.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2509,6 +2509,7 @@ static struct snd_pci_quirk position_fix
 	SND_PCI_QUIRK(0x1043, 0x81e7, "ASUS M2V", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1043, 0x83ce, "ASUS 1101HA", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x104d, 0x9069, "Sony VPCS11V9E", POS_FIX_LPIB),
+	SND_PCI_QUIRK(0x10de, 0xcb89, "Macbook Pro 7,1", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1297, 0x3166, "Shuttle", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1458, 0xa022, "ga-ma770-ud3", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1462, 0x1002, "MSI Wind U115", POS_FIX_LPIB),


