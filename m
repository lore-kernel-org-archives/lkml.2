Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454Ab0IRTHv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:07:51 -0400
Received: from kroah.org ([198.145.64.141]:51881 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235Ab0IRTC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:02:26 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:00:02 2010
Message-Id: <20100918190002.503412237@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:59:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>,
        David Henningsson <david.henningsson@canonical.com>
Subject: [113/123] ALSA: hda - Handle pin NID 0x1a on ALC259/269
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=alsa-hda-handle-pin-nid-0x1a-on-alc259-269.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit b08b1637ce1c0196970348bcabf40f04b6b3d58e upstream.

The pin NID 0x1a should be handled as well as NID 0x1b.
Also added comments.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -12389,7 +12389,8 @@ static int alc268_new_analog_output(stru
 		dac = 0x02;
 		break;
 	case 0x15:
-	case 0x1b:
+	case 0x1a: /* ALC259/269 only */
+	case 0x1b: /* ALC259/269 only */
 	case 0x21: /* ALC269vb has this pin, too */
 		dac = 0x03;
 		break;


