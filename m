Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879Ab0LHB3f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:29:35 -0500
Received: from kroah.org ([198.145.64.141]:49159 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932385Ab0LHBCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:02:12 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:38 2010
Message-Id: <20101208005738.175733463@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:59:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel T Chen <crimsun@ubuntu.com>, Takashi Iwai <tiwai@suse.de>
Subject: [167/289] ALSA: hda: Use "alienware" model quirk for another SSID
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel T Chen <crimsun@ubuntu.com>

commit 0defe09ca70daccdc83abd9c3c24cd89ae6a1141 upstream.

BugLink: https://launchpad.net/bugs/683695

The original reporter states that headphone jacks do not appear to
work.  Upon inspecting his codec dump, and upon further testing, it is
confirmed that the "alienware" model quirk is correct.

Reported-and-tested-by: Cody Thierauf
Signed-off-by: Daniel T Chen <crimsun@ubuntu.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_sigmatel.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -1619,6 +1619,8 @@ static struct snd_pci_quirk stac92hd73xx
 static struct snd_pci_quirk stac92hd73xx_codec_id_cfg_tbl[] = {
 	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x02a1,
 		      "Alienware M17x", STAC_ALIENWARE_M17X),
+	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x043a,
+		      "Alienware M17x", STAC_ALIENWARE_M17X),
 	{} /* terminator */
 };
 


