Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676Ab2HOUYO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:24:14 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62903 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756593Ab2HOTub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:50:31 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 068/165] ALSA: HDA: Add new revision for ALC662
Date: Wed, 15 Aug 2012 15:46:52 -0400
Message-ID: <1345060109-9187-69-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Henningsson <david.henningsson@canonical.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit cc667a72d471e79fd8e5e291ea115923cf44dca0 upstream.

The revision 0x100300 was found for ALC662. It seems to work well
with patch_alc662.

BugLink: http://bugs.launchpad.net/bugs/877373
Tested-by: Shengyao Xue <Shengyao.xue@canonical.com>
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Acked-by: Kailang Yang <kailang@realtek.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/pci/hda/patch_realtek.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 2c71de1..94f1a80 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -18657,6 +18657,8 @@ static struct hda_codec_preset snd_hda_preset_realtek[] = {
 	  .patch = patch_alc882 },
 	{ .id = 0x10ec0662, .rev = 0x100101, .name = "ALC662 rev1",
 	  .patch = patch_alc662 },
+	{ .id = 0x10ec0662, .rev = 0x100300, .name = "ALC662 rev3",
+	  .patch = patch_alc662 },
 	{ .id = 0x10ec0663, .name = "ALC663", .patch = patch_alc662 },
 	{ .id = 0x10ec0665, .name = "ALC665", .patch = patch_alc662 },
 	{ .id = 0x10ec0670, .name = "ALC670", .patch = patch_alc662 },
-- 
1.7.12.rc2

