Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab2BWOYy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 09:24:54 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:34559
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003Ab2BWOYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 09:24:53 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: iwai@suse.de, alsa-devel@alsa-project.org, perex@perex.cz
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
        Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] sound: Fix typo in ctvmem.c
Date: Thu, 23 Feb 2012 23:23:06 +0900
Message-Id: <1330006986-1696-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "virtural" to "virtual" in
sound/pci/ctxfi/ctvmem.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 sound/pci/ctxfi/ctvmem.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/pci/ctxfi/ctvmem.c b/sound/pci/ctxfi/ctvmem.c
index b78f3fc..6109490 100644
--- a/sound/pci/ctxfi/ctvmem.c
+++ b/sound/pci/ctxfi/ctvmem.c
@@ -36,7 +36,7 @@ get_vm_block(struct ct_vm *vm, unsigned int size)
 
 	size = CT_PAGE_ALIGN(size);
 	if (size > vm->size) {
-		printk(KERN_ERR "ctxfi: Fail! No sufficient device virtural "
+		printk(KERN_ERR "ctxfi: Fail! No sufficient device virtual "
 				  "memory space available!\n");
 		return NULL;
 	}
-- 
1.7.6.5

