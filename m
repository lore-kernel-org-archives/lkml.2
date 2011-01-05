Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab1AEXpc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 18:45:32 -0500
Received: from kroah.org ([198.145.64.141]:41115 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753642Ab1AEXp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 18:45:27 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 15:03:28 2011
Message-Id: <20110105230327.987439490@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 15:01:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel T Chen <crimsun@ubuntu.com>, Takashi Iwai <tiwai@suse.de>
Subject: [45/49] ALSA: hda: Use LPIB for Dell Latitude 131L
In-Reply-To: <20110105234415.GA22369@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel T Chen <crimsun@ubuntu.com>

commit 9919c7619c52d01e89103bca405cc3d4a2b1ac31 upstream.

BugLink: https://launchpad.net/bugs/530346

The OR has verified that position_fix=1 is necessary to work around
errors on his machine.

Reported-by: Tom Louwrier
Signed-off-by: Daniel T Chen <crimsun@ubuntu.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>

---
 sound/pci/hda/hda_intel.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2229,6 +2229,7 @@ static struct snd_pci_quirk position_fix
 	SND_PCI_QUIRK(0x1025, 0x009f, "Acer Aspire 5110", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1028, 0x01cc, "Dell D820", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1028, 0x01de, "Dell Precision 390", POS_FIX_LPIB),
+	SND_PCI_QUIRK(0x1028, 0x01f6, "Dell Latitude 131L", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x103c, 0x306d, "HP dv3", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1028, 0x01f6, "Dell Latitude 131L", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1043, 0x813d, "ASUS P5AD2", POS_FIX_LPIB),


