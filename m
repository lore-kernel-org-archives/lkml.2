Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933569Ab2GYPMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 11:12:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:34632 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933534Ab2GYPLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 11:11:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="171267794"
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        drbd-dev@lists.linbit.com
Subject: [PATCH 14/16] drbd: nuke pdflush from comments
Date: Wed, 25 Jul 2012 18:12:12 +0300
Message-Id: <1343229134-29487-15-git-send-email-artem.bityutskiy@linux.intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1343229134-29487-1-git-send-email-artem.bityutskiy@linux.intel.com>
References: <1343229134-29487-1-git-send-email-artem.bityutskiy@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

The pdflush thread is long gone, so this patch removes references to pdflush
from drbd comments.

Cc: drbd-dev@lists.linbit.com
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---

I expect this patch to be merged via Al Viro's VFS tree.

 drivers/block/drbd/drbd_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 920ede2..974f2b6 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -3521,9 +3521,9 @@ static void drbd_cleanup(void)
 }
 
 /**
- * drbd_congested() - Callback for pdflush
+ * drbd_congested() - Callback for the flusher thread
  * @congested_data:	User data
- * @bdi_bits:		Bits pdflush is currently interested in
+ * @bdi_bits:		Bits the BDI flusher thread is currently interested in
  *
  * Returns 1<<BDI_async_congested and/or 1<<BDI_sync_congested if we are congested.
  */
-- 
1.7.10

