Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247Ab1ACQhE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 11:37:04 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52939 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456Ab1ACQhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 11:37:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Qadn0ofa91Wz1nW7Kjk/0JUO7SSC7rRkDwHrkk7xfWiQWXDvrW5aSS/jzetUQm+1gp
         Tf69sWFZ32rrbnqTb/Oku6rTXvnnxBwLhPohQnJCc8VN2w1V1lS2OMF54r5iHgtHMu3+
         /+nrbNAZcENnhTo2nHRNXDgmVi/xWfISnjqgI=
From: Minchan Kim <minchan.kim@gmail.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: [PATCH] writeback: fix typo of global_dirty_limits comment
Date: Tue,  4 Jan 2011 01:36:48 +0900
Message-Id: <1294072608-3172-1-git-send-email-minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change runtime with real-time

Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/page-writeback.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index c340536..98b79e2 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -384,7 +384,7 @@ unsigned long determine_dirtyable_memory(void)
  * - vm.dirty_background_ratio  or  vm.dirty_background_bytes
  * - vm.dirty_ratio             or  vm.dirty_bytes
  * The dirty limits will be lifted by 1/4 for PF_LESS_THROTTLE (ie. nfsd) and
- * runtime tasks.
+ * real-time tasks.
  */
 void global_dirty_limits(unsigned long *pbackground, unsigned long *pdirty)
 {
-- 
1.7.0.4

