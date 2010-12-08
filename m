Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862Ab0LHBae (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:30:34 -0500
Received: from kroah.org ([198.145.64.141]:49124 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932271Ab0LHBCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:02:03 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:37 2010
Message-Id: <20101208005737.423332992@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:58:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Valentine Sinitsyn <valentine.sinitsyn@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [160/289] ALSA: hda - Added fixup for Lenovo Y550P
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Valentine Sinitsyn <valentine.sinitsyn@gmail.com>

commit d41185882b828896ccecac319c9f65f708baaf0d upstream.

Signed-off-by: Valentine Sinitsyn <valentine.sinitsyn@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -18948,6 +18948,7 @@ static const struct alc_fixup alc662_fix
 };
 
 static struct snd_pci_quirk alc662_fixup_tbl[] = {
+	SND_PCI_QUIRK(0x17aa, 0x38af, "Lenovo Ideapad Y550P", ALC662_FIXUP_IDEAPAD),
 	SND_PCI_QUIRK(0x17aa, 0x3a0d, "Lenovo Ideapad Y550", ALC662_FIXUP_IDEAPAD),
 	{}
 };


