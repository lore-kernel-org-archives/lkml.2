Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965314Ab1C3VnD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:43:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:43212 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933507Ab1C3VHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:07:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="673447680"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: david.henningsson@canonical.com, tiwai@suse.de, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [130/275] ALSA: HDA: Add position_fix quirk for an Asus device
Message-Id: <20110330210610.8FE153E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:06:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: David Henningsson <david.henningsson@canonical.com>

commit b540afc2b3d6e4cd1d1f137ef6d9e9c78d67fecd upstream.

The bug reporter claims that position_fix=1 is needed for his
microphone to work. The controller PCI vendor-id is [1002:4383] (rev 40).

Reported-by: Kjell L.
BugLink: http://bugs.launchpad.net/bugs/718402
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>


---
 sound/pci/hda/hda_intel.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.35.y/sound/pci/hda/hda_intel.c
===================================================================
--- linux-2.6.35.y.orig/sound/pci/hda/hda_intel.c	2011-03-29 22:51:15.809318648 -0700
+++ linux-2.6.35.y/sound/pci/hda/hda_intel.c	2011-03-29 23:03:00.988274883 -0700
@@ -2300,6 +2300,7 @@
 	SND_PCI_QUIRK(0x1043, 0x813d, "ASUS P5AD2", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1043, 0x81b3, "ASUS", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1043, 0x81e7, "ASUS M2V", POS_FIX_LPIB),
+	SND_PCI_QUIRK(0x1043, 0x8410, "ASUS", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x104d, 0x9069, "Sony VPCS11V9E", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1106, 0x3288, "ASUS M2V-MX SE", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1179, 0xff10, "Toshiba A100-259", POS_FIX_LPIB),
