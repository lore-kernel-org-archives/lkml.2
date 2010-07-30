Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759957Ab0G3SzL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:55:11 -0400
Received: from kroah.org ([198.145.64.141]:35548 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759192Ab0G3ReJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:34:09 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:31:04 2010
Message-Id: <20100730173104.763884911@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:29:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Luke Yelavich <luke.yelavich@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [022/140] ALSA: hda - Add Macbook 5,2 quirk
In-Reply-To: <20100730173205.GA22581@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Luke Yelavich <luke.yelavich@canonical.com>

commit 3bfea98ff73d377ffce0d4c7f938b7ef958cdb35 upstream.

BugLink: https://bugs.launchpad.net/bugs/463178

Set Macbook 5,2 (106b:4a00) hardware to use ALC885_MB5

Signed-off-by: Luke Yelavich <luke.yelavich@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9122,6 +9122,7 @@ static struct snd_pci_quirk alc882_ssid_
 	SND_PCI_QUIRK(0x106b, 0x3e00, "iMac 24 Aluminum", ALC885_IMAC24),
 	SND_PCI_QUIRK(0x106b, 0x4900, "iMac 9,1 Aluminum", ALC885_IMAC91),
 	SND_PCI_QUIRK(0x106b, 0x3f00, "Macbook 5,1", ALC885_MB5),
+	SND_PCI_QUIRK(0x106b, 0x4a00, "Macbook 5,2", ALC885_MB5),
 	/* FIXME: HP jack sense seems not working for MBP 5,1 or 5,2,
 	 * so apparently no perfect solution yet
 	 */


