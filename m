Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993155Ab2K3TDN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:03:13 -0500
Received: from mail.kernel.org ([198.145.19.201]:59982 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993111Ab2K3TDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 14:03:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Acelan Kao <acelan.kao@canonical.com>,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 36/54] ALSA: hda - Add support for Realtek ALC292
Date: Fri, 30 Nov 2012 10:56:07 -0800
Message-Id: <20121130185211.571854203@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185207.894301294@linuxfoundation.org>
References: <20121130185207.894301294@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit af02dde8a609d8d071c4b31a82df811a55690a4a upstream.

We found a new codec ID 292, and that just a simple quirk would enable
sound output/input on this ALC292 chip.

BugLink: https://bugs.launchpad.net/bugs/1081466
Tested-by: Acelan Kao <acelan.kao@canonical.com>
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7092,6 +7092,7 @@ static const struct hda_codec_preset snd
 	{ .id = 0x10ec0282, .name = "ALC282", .patch = patch_alc269 },
 	{ .id = 0x10ec0283, .name = "ALC283", .patch = patch_alc269 },
 	{ .id = 0x10ec0290, .name = "ALC290", .patch = patch_alc269 },
+	{ .id = 0x10ec0292, .name = "ALC292", .patch = patch_alc269 },
 	{ .id = 0x10ec0861, .rev = 0x100340, .name = "ALC660",
 	  .patch = patch_alc861 },
 	{ .id = 0x10ec0660, .name = "ALC660-VD", .patch = patch_alc861vd },


