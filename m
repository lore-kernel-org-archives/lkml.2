Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932960Ab0EJXPK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:15:10 -0400
Received: from kroah.org ([198.145.64.141]:51834 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757468Ab0EJW6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:58:14 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:39 2010
Message-Id: <20100510223539.625589376@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:35:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Daniel T Chen <crimsun@ubuntu.com>, Takashi Iwai <tiwai@suse.de>
Subject: [58/98] ALSA: hda: Use olpc-xo-1_5 quirk for Toshiba Satellite P500-PSPGSC-01800T
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel T Chen <crimsun@ubuntu.com>

commit c53666813813a0ea3d0391e1911eefc05a5e6b4f upstream.

BugLink: https://launchpad.net/bugs/549267

The OR verified that using the olpc-xo-1_5 model quirk allows the
headphones to be audible when inserted into the jack. Capture was
also verified to work correctly.

Reported-by: Richard Gagne
Tested-by: Richard Gagne
Signed-off-by: Daniel T Chen <crimsun@ubuntu.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_conexant.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -2350,6 +2350,7 @@ static struct snd_pci_quirk cxt5066_cfg_
 	SND_PCI_QUIRK(0x1028, 0x02f5, "Dell",
 		      CXT5066_DELL_LAPTOP),
 	SND_PCI_QUIRK(0x152d, 0x0833, "OLPC XO-1.5", CXT5066_OLPC_XO_1_5),
+	SND_PCI_QUIRK(0x1179, 0xff50, "Toshiba Satellite P500-PSPGSC-01800T", CXT5066_OLPC_XO_1_5),
 	SND_PCI_QUIRK(0x1179, 0xffe0, "Toshiba Satellite Pro T130-15F", CXT5066_OLPC_XO_1_5),
 	{}
 };


