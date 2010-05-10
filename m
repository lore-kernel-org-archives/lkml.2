Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933049Ab0EJXBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:01:44 -0400
Received: from kroah.org ([198.145.64.141]:51827 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757472Ab0EJW6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:58:06 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:38 2010
Message-Id: <20100510223538.911121927@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:35:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Daniel T Chen <crimsun@ubuntu.com>, Takashi Iwai <tiwai@suse.de>
Subject: [50/98] ALSA: hda: Use STAC_DELL_M6_BOTH quirk for Dell Studio XPS 1645
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel T Chen <crimsun@ubuntu.com>

commit aac78daf8f37256283f56820ae858add7139c56c upstream.

BugLink: https://launchpad.net/bugs/553002

The OR has verified that the dell-m6 model quirk is necessary for audio
to be audible by default on the Dell Studio XPS 1645.

This change is necessary for 2.6.32.11 and 2.6.33.2 alike.

Reported-by: Robert Chambers
Tested-by: Robert Chambers
Signed-off-by: Daniel T Chen <crimsun@ubuntu.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_sigmatel.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -1592,6 +1592,8 @@ static struct snd_pci_quirk stac92hd73xx
 				"Dell Studio 1555", STAC_DELL_M6_DMIC),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x02bd,
 				"Dell Studio 1557", STAC_DELL_M6_DMIC),
+	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x02fe,
+				"Dell Studio XPS 1645", STAC_DELL_M6_BOTH),
 	{} /* terminator */
 };
 


