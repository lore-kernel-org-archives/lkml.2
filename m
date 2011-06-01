Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161851Ab1FAJOh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 05:14:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43217 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757273Ab1FAIOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:14:33 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:04:01 2011
Message-Id: <20110601080400.187896979@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:00:29 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [093/146] ALSA: HDA: Add quirk for Lenovo U350
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit d2859fd49200f1f3efd8acdb54b6d51d3ab82302 upstream.

Add model=asus quirk for Lenovo Ideapad U350 to make internal mic
work correctly.

BugLink: http://bugs.launchpad.net/bugs/751681
Reported-by: Kent Baxley <kent.baxley@canonical.com>
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_conexant.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -3132,6 +3132,7 @@ static struct snd_pci_quirk cxt5066_cfg_
  	SND_PCI_QUIRK(0x17aa, 0x215e, "Lenovo Thinkpad", CXT5066_THINKPAD),
 	SND_PCI_QUIRK(0x17aa, 0x21da, "Lenovo X220", CXT5066_THINKPAD),
 	SND_PCI_QUIRK(0x17aa, 0x21db, "Lenovo X220-tablet", CXT5066_THINKPAD),
+	SND_PCI_QUIRK(0x17aa, 0x3a0d, "Lenovo U350", CXT5066_ASUS),
 	SND_PCI_QUIRK(0x17aa, 0x38af, "Lenovo G560", CXT5066_ASUS),
 	SND_PCI_QUIRK_VENDOR(0x17aa, "Lenovo", CXT5066_IDEAPAD), /* Fallback for Lenovos without dock mic */
 	{}


