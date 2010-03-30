Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100Ab0C3XRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:17:31 -0400
Received: from kroah.org ([198.145.64.141]:51729 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756749Ab0C3XR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:17:27 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:56:02 2010
Message-Id: <20100330225601.843819406@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:54:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Takashi Iwai <tiwai@suse.de>, Daniel T Chen <crimsun@ubuntu.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [009/116] ALSA: hda: enable MSI for Gateway M-6866
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel T Chen <crimsun@ubuntu.com>

BugLink: https://bugs.launchpad.net/bugs/538918

The OR has verified that explicitly enabling MSI is necessary for audio
to be audible by default.

This patch is only applicable to 2.6.32.y; in 2.6.33, MSI is enabled by
default.

Reported-by: Sam Townsend <stownsend42@sbcglobal.net>
Tested-by: Sam Townsend <stownsend42@sbcglobal.net>
Acked-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Daniel T Chen <crimsun@ubuntu.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/hda_intel.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2317,6 +2317,7 @@ static void __devinit check_probe_mask(s
 static struct snd_pci_quirk msi_white_list[] __devinitdata = {
 	SND_PCI_QUIRK(0x103c, 0x30f7, "HP Pavilion dv4t-1300", 1),
 	SND_PCI_QUIRK(0x103c, 0x3607, "HP Compa CQ40", 1),
+	SND_PCI_QUIRK(0x107b, 0x0380, "Gateway M-6866", 1),
 	{}
 };
 


