Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161606Ab2GLWYz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:24:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55669 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759274Ab2GLWYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:24:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Richard Crossley <richardcrossley@o2.co.uk>,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 003/187] ALSA: hda - Add Realtek ALC280 codec support
Date: Thu, 12 Jul 2012 15:23:31 -0700
Message-Id: <20120712191522.546901471@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.378465973@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.378465973@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit befae82e2906cb7155020876a531b0b8c6c8d8c8 upstream.

This chip looks very similar to ALC269 and ALC27* variants. The bug reporter
has verified that sound was working after this patch had been applied.

BugLink: https://bugs.launchpad.net/bugs/1017017
Tested-by: Richard Crossley <richardcrossley@o2.co.uk>
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6976,6 +6976,7 @@ static const struct hda_codec_preset snd
 	{ .id = 0x10ec0272, .name = "ALC272", .patch = patch_alc662 },
 	{ .id = 0x10ec0275, .name = "ALC275", .patch = patch_alc269 },
 	{ .id = 0x10ec0276, .name = "ALC276", .patch = patch_alc269 },
+	{ .id = 0x10ec0280, .name = "ALC280", .patch = patch_alc269 },
 	{ .id = 0x10ec0861, .rev = 0x100340, .name = "ALC660",
 	  .patch = patch_alc861 },
 	{ .id = 0x10ec0660, .name = "ALC660-VD", .patch = patch_alc861vd },


