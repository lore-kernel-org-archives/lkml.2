Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933303Ab0HXXBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:01:31 -0400
Received: from kroah.org ([198.145.64.141]:40823 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933230Ab0HXXBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:01:16 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:02 2010
Message-Id: <20100824224502.227595841@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:44:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [011/114] ALSA: hda - Add quirk for Dell Vostro 1220
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit c3e68fad88143fd1fe8fe640207fb19c0f087dbc upstream.

model=dell-vostro is needed for Dell Vostro 1220 with Coexnat 5067.

Reference: Novell bnc#631066
	https://bugzilla.novell.com/show_bug.cgi?id=631066

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_conexant.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -2970,6 +2970,7 @@ static struct snd_pci_quirk cxt5066_cfg_
 	SND_PCI_QUIRK(0x1028, 0x02f5, "Dell",
 		      CXT5066_DELL_LAPTOP),
 	SND_PCI_QUIRK(0x152d, 0x0833, "OLPC XO-1.5", CXT5066_OLPC_XO_1_5),
+	SND_PCI_QUIRK(0x1028, 0x02d8, "Dell Vostro", CXT5066_DELL_VOSTO),
 	SND_PCI_QUIRK(0x1028, 0x0402, "Dell Vostro", CXT5066_DELL_VOSTO),
 	SND_PCI_QUIRK(0x1028, 0x0408, "Dell Inspiron One 19T", CXT5066_IDEAPAD),
 	SND_PCI_QUIRK(0x1179, 0xff50, "Toshiba Satellite P500-PSPGSC-01800T", CXT5066_OLPC_XO_1_5),


