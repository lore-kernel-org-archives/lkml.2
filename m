Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914Ab1BPBiZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:38:25 -0500
Received: from kroah.org ([198.145.64.141]:39071 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757069Ab1BPAUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:20:20 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:33 2011
Message-Id: <20110216001433.712153658@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:12:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [086/272] ALSA: hda - Add missing NID 0x19 fixup for Sony VAIO
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 700b65cee958d81b16c48378d5759c46d01e24d0 upstream.

With GPIO2-fixup, another fixup for NID 0x19 was missing because the
fixup is applied only once.  Add the corresponding verb to the entry.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -14824,6 +14824,7 @@ static const struct alc_fixup alc269_fix
 			{0x01, AC_VERB_SET_GPIO_MASK, 0x04},
 			{0x01, AC_VERB_SET_GPIO_DIRECTION, 0x04},
 			{0x01, AC_VERB_SET_GPIO_DATA, 0x00},
+			{0x19, AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_VREFGRD},
 			{ }
 		}
 	},


