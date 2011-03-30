Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab1C3AuG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 20:50:06 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:59146 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884Ab1C3AuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 20:50:04 -0400
X-Nat-Received: from [202.181.97.72]:64593 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1301446199.12429
Message-Id: <201103300049.p2U0nxZf068304@www262.sakura.ne.jp>
Subject: [PATCH 2.6.39-rc1] Remove duplicated inline keyword in include/linux/memcontrol.h
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: minchan.kim@gmail.com
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Wed, 30 Mar 2011 09:49:59 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 29032011 #5165127, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In file included from include/linux/swap.h:8,
                 from include/linux/suspend.h:4,
                 from arch/x86/kernel/asm-offsets.c:12:
include/linux/memcontrol.h:220: error: duplicate `inline'
make[1]: *** [arch/x86/kernel/asm-offsets.s] Error 1
make: *** [prepare0] Error 2

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> 
---
 include/linux/memcontrol.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.39-rc1.orig/include/linux/memcontrol.h
+++ linux-2.6.39-rc1/include/linux/memcontrol.h
@@ -216,7 +216,7 @@ static inline void mem_cgroup_del_lru_li
 	return ;
 }
 
-static inline inline void mem_cgroup_rotate_reclaimable_page(struct page *page)
+static inline void mem_cgroup_rotate_reclaimable_page(struct page *page)
 {
 	return ;
 }
