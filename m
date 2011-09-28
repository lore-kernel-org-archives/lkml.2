Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab1I1WvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:51:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55144 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756018Ab1I1WvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:51:16 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:49 2011
Message-Id: <20110928220149.403768579@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:03:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [228/244] ALSA: HDA: No power nids on 92HD93
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit 6656b15d675c9c6a049db48d50994b3cd4e76bd6 upstream.

This patch is necessary to make internal speakers work on this chip.

BugLink: http://bugs.launchpad.net/bugs/854468
Tested-by: Alex Wolfson <alex.wolfson@canonical.com>
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_sigmatel.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -5470,6 +5470,7 @@ again:
 	switch (codec->vendor_id) {
 	case 0x111d76d1:
 	case 0x111d76d9:
+	case 0x111d76df:
 	case 0x111d76e5:
 	case 0x111d7666:
 	case 0x111d7667:


