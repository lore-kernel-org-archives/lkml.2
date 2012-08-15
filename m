Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206Ab2HOU3x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:29:53 -0400
Received: from mail.windriver.com ([147.11.1.11]:36575 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756466Ab2HOTtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:49:55 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 043/165] ALSA: HDA: Cirrus - fix "Surround Speaker" volume control name
Date: Wed, 15 Aug 2012 15:46:27 -0400
Message-ID: <1345060109-9187-44-git-send-email-paul.gortmaker@windriver.com>
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

commit 2e1210bc3d065a6e26ff5fef228a9a7e08921d2c upstream.

This patch fixes "Surround Speaker Playback Volume" being cut off.
(Commit b4dabfc452a10 was probably meant to fix this, but it fixed
only the "Switch" name, not the "Volume" name.)

Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/pci/hda/patch_cirrus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_cirrus.c b/sound/pci/hda/patch_cirrus.c
index 5f08464..71855e3 100644
--- a/sound/pci/hda/patch_cirrus.c
+++ b/sound/pci/hda/patch_cirrus.c
@@ -510,7 +510,7 @@ static int add_volume(struct hda_codec *codec, const char *name,
 		      int index, unsigned int pval, int dir,
 		      struct snd_kcontrol **kctlp)
 {
-	char tmp[32];
+	char tmp[44];
 	struct snd_kcontrol_new knew =
 		HDA_CODEC_VOLUME_IDX(tmp, index, 0, 0, HDA_OUTPUT);
 	knew.private_value = pval;
-- 
1.7.12.rc2

