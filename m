Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab1ASGAg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 01:00:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751Ab1ASGAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 01:00:35 -0500
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: WANG Cong <amwang@redhat.com>,
        Arnd Bergmann <arnd@arndb.de> (commit_signer:3/5=60%),
        Andrew Morton <akpm@linux-foundation.org> (commit_signer:2/5=40%),
        Greg Kroah-Hartman <gregkh@suse.de> (commit_signer:2/5=40%),
        Yannick Heneault <yheneaul@matrox.com> (commit_signer:1/5=20%),
        Matthew Garrett <mjg@redhat.com> (commit_signer:1/5=20%),
        linux-fbdev@vger.kernel.org (open list:FRAMEBUFFER LAYER)
Subject: [Patch] video: remove pointless comments in drivers/video/console/vgacon.c
Date: Wed, 19 Jan 2011 14:00:02 +0800
Message-Id: <1295416803-17651-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now vgacon_scrollback_startup() uses slab, not bootmem,
so that comment is obsolete, the rest are useless.

Signed-off-by: WANG Cong <amwang@redhat.com>

---
diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgacon.c
index c97491b..b030aca 100644
--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -202,10 +202,6 @@ static void vgacon_scrollback_init(int pitch)
 	}
 }
 
-/*
- * Called only duing init so call of alloc_bootmen is ok.
- * Marked __init_refok to silence modpost.
- */
 static void __init_refok vgacon_scrollback_startup(void)
 {
 	vgacon_scrollback = kcalloc(CONFIG_VGACON_SOFT_SCROLLBACK_SIZE, 1024, GFP_NOWAIT);
