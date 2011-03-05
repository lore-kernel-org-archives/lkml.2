Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932717Ab1CEBND (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:13:03 -0500
Received: from kroah.org ([198.145.64.141]:50277 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760403Ab1CEBAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:00:21 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:38 2011
Message-Id: <20110305005638.112726383@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:55:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [36/73] ALSA: HDA: Add a new Conexant codec 506e (20590)
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit 6da8b51657a9cd5a87b4e6e4c7bc76b598a95175 upstream.

Conexant 506e/20590 has the same graph as the rest of the 5066 family.

BugLink: http://bugs.launchpad.net/bugs/723672

Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_conexant.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -3890,6 +3890,8 @@ static struct hda_codec_preset snd_hda_p
 	  .patch = patch_cxt5066 },
 	{ .id = 0x14f15069, .name = "CX20585",
 	  .patch = patch_cxt5066 },
+	{ .id = 0x14f1506e, .name = "CX20590",
+	  .patch = patch_cxt5066 },
 	{ .id = 0x14f15097, .name = "CX20631",
 	  .patch = patch_conexant_auto },
 	{ .id = 0x14f15098, .name = "CX20632",
@@ -3916,6 +3918,7 @@ MODULE_ALIAS("snd-hda-codec-id:14f15066"
 MODULE_ALIAS("snd-hda-codec-id:14f15067");
 MODULE_ALIAS("snd-hda-codec-id:14f15068");
 MODULE_ALIAS("snd-hda-codec-id:14f15069");
+MODULE_ALIAS("snd-hda-codec-id:14f1506e");
 MODULE_ALIAS("snd-hda-codec-id:14f15097");
 MODULE_ALIAS("snd-hda-codec-id:14f15098");
 MODULE_ALIAS("snd-hda-codec-id:14f150a1");


