Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932807Ab0JVTZy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:25:54 -0400
Received: from kroah.org ([198.145.64.141]:33864 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759164Ab0JVSzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:55:49 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:27 2010
Message-Id: <20101022185227.649465734@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:50:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Luke Yelavich <luke.yelavich@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [004/103] ALSA: hda - Add Dell Latitude E6400 model quirk
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Luke Yelavich <luke.yelavich@canonical.com>

commit 0f9f1ee9d1412d45a22bfd69dfd4d4324b506e9e upstream.

BugLink: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/643891

Set the Dell Latitude E6400 (1028:0233) SSID to use AD1984_DELL_DESKTOP

Signed-off-by: Luke Yelavich <luke.yelavich@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_analog.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -3641,6 +3641,7 @@ static struct snd_pci_quirk ad1984_cfg_t
 	/* Lenovo Thinkpad T61/X61 */
 	SND_PCI_QUIRK_VENDOR(0x17aa, "Lenovo Thinkpad", AD1984_THINKPAD),
 	SND_PCI_QUIRK(0x1028, 0x0214, "Dell T3400", AD1984_DELL_DESKTOP),
+	SND_PCI_QUIRK(0x1028, 0x0233, "Dell Latitude E6400", AD1984_DELL_DESKTOP),
 	{}
 };
 


