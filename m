Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651Ab2KVWPS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:15:18 -0500
Received: from mail.kernel.org ([198.145.19.201]:49357 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754578Ab2KVSie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:38:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Kailang Yang <kailang@realtek.com>, Takashi Iwai <tiwai@suse.de>
Subject: [ 017/171] ALSA: hda - Add new codec ALC668 and ALC900 (default name ALC1150)
Date: Wed, 21 Nov 2012 16:39:23 -0800
Message-Id: <20121122004035.083309736@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kailang Yang <kailang@realtek.com>

commit 19a62823eae453619604636082085812c14ee391 upstream.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7047,6 +7047,7 @@ static const struct hda_codec_preset snd
 	  .patch = patch_alc662 },
 	{ .id = 0x10ec0663, .name = "ALC663", .patch = patch_alc662 },
 	{ .id = 0x10ec0665, .name = "ALC665", .patch = patch_alc662 },
+	{ .id = 0x10ec0668, .name = "ALC668", .patch = patch_alc662 },
 	{ .id = 0x10ec0670, .name = "ALC670", .patch = patch_alc662 },
 	{ .id = 0x10ec0680, .name = "ALC680", .patch = patch_alc680 },
 	{ .id = 0x10ec0880, .name = "ALC880", .patch = patch_alc880 },
@@ -7064,6 +7065,7 @@ static const struct hda_codec_preset snd
 	{ .id = 0x10ec0889, .name = "ALC889", .patch = patch_alc882 },
 	{ .id = 0x10ec0892, .name = "ALC892", .patch = patch_alc662 },
 	{ .id = 0x10ec0899, .name = "ALC898", .patch = patch_alc882 },
+	{ .id = 0x10ec0900, .name = "ALC1150", .patch = patch_alc882 },
 	{} /* terminator */
 };
 


