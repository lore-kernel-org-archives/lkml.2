Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab1BFXpi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:45:38 -0500
Received: from 1wt.eu ([62.212.114.60]:60276 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754461Ab1BFXpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:45:36 -0500
Message-Id: <20110206232252.618018868@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 07 Feb 2011 00:22:54 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Daniel T Chen <crimsun@ubuntu.com>, Takashi Iwai <tiwai@suse.de>,
        Willy Tarreau <w@1wt.eu>
Subject: [PATCH 02/23] ALSA: hda: Use LPIB for Dell Latitude 131L
In-Reply-To: <4beed4da27f06efb2c13d6ed48850634@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.58-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel T Chen <crimsun@ubuntu.com>

commit 9919c7619c52d01e89103bca405cc3d4a2b1ac31 upstream.

BugLink: https://launchpad.net/bugs/530346

The OR has verified that position_fix=1 is necessary to work around
errors on his machine.

Reported-by: Tom Louwrier
Signed-off-by: Daniel T Chen <crimsun@ubuntu.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>

---
 sound/pci/hda/hda_intel.c |    1 +
 1 file changed, 1 insertion(+)

Index: longterm-2.6.27/sound/pci/hda/hda_intel.c
===================================================================
--- longterm-2.6.27.orig/sound/pci/hda/hda_intel.c	2011-01-23 10:52:41.000000000 +0100
+++ longterm-2.6.27/sound/pci/hda/hda_intel.c	2011-01-29 15:57:30.536067735 +0100
@@ -1966,6 +1966,7 @@
 static struct snd_pci_quirk position_fix_list[] __devinitdata = {
 	SND_PCI_QUIRK(0x1028, 0x01cc, "Dell D820", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1028, 0x01de, "Dell Precision 390", POS_FIX_LPIB),
+	SND_PCI_QUIRK(0x1028, 0x01f6, "Dell Latitude 131L", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1043, 0x813d, "ASUS P5AD2", POS_FIX_LPIB),
 	{}
 };


