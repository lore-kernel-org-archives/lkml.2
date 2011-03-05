Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760439Ab1CEBA2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:00:28 -0500
Received: from kroah.org ([198.145.64.141]:50290 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760384Ab1CEBAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:00:25 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:38 2011
Message-Id: <20110305005638.387425330@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:55:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [39/73] ALSA: HDA: Add ideapad quirk for two Dell machines
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit ebbd224c22a00dbbee95031a0d6d595460f6f2b3 upstream.

These two Dell machines have been reported working well with
the ideapad model.

BugLink: http://bugs.launchpad.net/bugs/723676
Tested-by: David Chen <david.chen@canonical.com>
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_conexant.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -3106,6 +3106,8 @@ static struct snd_pci_quirk cxt5066_cfg_
 	SND_PCI_QUIRK(0x1028, 0x0401, "Dell Vostro 1014", CXT5066_DELL_VOSTRO),
 	SND_PCI_QUIRK(0x1028, 0x0402, "Dell Vostro", CXT5066_DELL_VOSTRO),
 	SND_PCI_QUIRK(0x1028, 0x0408, "Dell Inspiron One 19T", CXT5066_IDEAPAD),
+	SND_PCI_QUIRK(0x1028, 0x050f, "Dell Inspiron", CXT5066_IDEAPAD),
+	SND_PCI_QUIRK(0x1028, 0x0510, "Dell Vostro", CXT5066_IDEAPAD),
 	SND_PCI_QUIRK(0x103c, 0x360b, "HP G60", CXT5066_HP_LAPTOP),
 	SND_PCI_QUIRK(0x1043, 0x13f3, "Asus A52J", CXT5066_HP_LAPTOP),
 	SND_PCI_QUIRK(0x1179, 0xff1e, "Toshiba Satellite C650D", CXT5066_IDEAPAD),


