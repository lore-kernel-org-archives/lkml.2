Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266Ab1KCCS6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 22:18:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50352 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755049Ab1KCBdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:33:17 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:52 2011
Message-Id: <20111102221452.570153911@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:13:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [027/107] ALSA: HDA: Cirrus - fix "Surround Speaker" volume control name
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit 2e1210bc3d065a6e26ff5fef228a9a7e08921d2c upstream.

This patch fixes "Surround Speaker Playback Volume" being cut off.
(Commit b4dabfc452a10 was probably meant to fix this, but it fixed
only the "Switch" name, not the "Volume" name.)

Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_cirrus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_cirrus.c
+++ b/sound/pci/hda/patch_cirrus.c
@@ -509,7 +509,7 @@ static int add_volume(struct hda_codec *
 		      int index, unsigned int pval, int dir,
 		      struct snd_kcontrol **kctlp)
 {
-	char tmp[32];
+	char tmp[44];
 	struct snd_kcontrol_new knew =
 		HDA_CODEC_VOLUME_IDX(tmp, index, 0, 0, HDA_OUTPUT);
 	knew.private_value = pval;


