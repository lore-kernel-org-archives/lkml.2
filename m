Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993227Ab2K3TEo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:04:44 -0500
Received: from mail.kernel.org ([198.145.19.201]:59959 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993124Ab2K3TDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 14:03:03 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Kailang Yang <kailang@realtek.com>, Takashi Iwai <tiwai@suse.de>
Subject: [ 34/54] ALSA: hda - Add new codec ALC283 ALC290 support
Date: Fri, 30 Nov 2012 10:56:05 -0800
Message-Id: <20121130185211.363509127@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185207.894301294@linuxfoundation.org>
References: <20121130185207.894301294@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kailang Yang <kailang@realtek.com>

commit 7ff34ad80b7080fafaac8efa9ef0061708eddd51 upstream.

These are compatible with standard ALC269 parser.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7089,6 +7089,8 @@ static const struct hda_codec_preset snd
 	{ .id = 0x10ec0276, .name = "ALC276", .patch = patch_alc269 },
 	{ .id = 0x10ec0280, .name = "ALC280", .patch = patch_alc269 },
 	{ .id = 0x10ec0282, .name = "ALC282", .patch = patch_alc269 },
+	{ .id = 0x10ec0283, .name = "ALC283", .patch = patch_alc269 },
+	{ .id = 0x10ec0290, .name = "ALC290", .patch = patch_alc269 },
 	{ .id = 0x10ec0861, .rev = 0x100340, .name = "ALC660",
 	  .patch = patch_alc861 },
 	{ .id = 0x10ec0660, .name = "ALC660-VD", .patch = patch_alc861vd },


