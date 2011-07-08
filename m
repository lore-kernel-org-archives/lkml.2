Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab1GHFDh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:03:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42189 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754464Ab1GHFDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:03:33 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:58 2011
Message-Id: <20110708001658.364910902@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:16:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [058/107] ALSA: HDA: Add a new Conexant codec ID (506c)
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit f0ca89b031d327b80b612a0608d31b8e13e6dc33 upstream.

Conexant ID 506c was found on Acer Aspire 3830TG. As users report
no playback, sending to stable should be safe.

BugLink: https://bugs.launchpad.net/bugs/783582
Reported-by: andROOM
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_conexant.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -3846,6 +3846,8 @@ static struct hda_codec_preset snd_hda_p
 	  .patch = patch_cxt5066 },
 	{ .id = 0x14f15069, .name = "CX20585",
 	  .patch = patch_cxt5066 },
+	{ .id = 0x14f1506c, .name = "CX20588",
+	  .patch = patch_cxt5066 },
 	{ .id = 0x14f1506e, .name = "CX20590",
 	  .patch = patch_cxt5066 },
 	{ .id = 0x14f15097, .name = "CX20631",
@@ -3874,6 +3876,7 @@ MODULE_ALIAS("snd-hda-codec-id:14f15066"
 MODULE_ALIAS("snd-hda-codec-id:14f15067");
 MODULE_ALIAS("snd-hda-codec-id:14f15068");
 MODULE_ALIAS("snd-hda-codec-id:14f15069");
+MODULE_ALIAS("snd-hda-codec-id:14f1506c");
 MODULE_ALIAS("snd-hda-codec-id:14f1506e");
 MODULE_ALIAS("snd-hda-codec-id:14f15097");
 MODULE_ALIAS("snd-hda-codec-id:14f15098");


