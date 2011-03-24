Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab1CXGHp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 02:07:45 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59749 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab1CXGHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 02:07:44 -0400
From: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
To: linux-cris-kernel@axis.com
Cc: linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Subject: [PATCH] cris: Change function name from alloc_thread_info to alloc_thread_info_node
Date: Thu, 24 Mar 2011 15:00:48 +0900
Message-Id: <1300946448-8468-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By commit b6a84016bd2598e35ead635147fa53619982648d, alloc_thread_info was
replaced by alloc_thread_info_node.
However, the change of the function name was incomplete.

Signed-off-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
CC: Eric Dumazet <eric.dumazet@gmail.com>
---
 arch/cris/include/asm/thread_info.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/cris/include/asm/thread_info.h b/arch/cris/include/asm/thread_info.h
index 29b74a1..6f23eca 100644
--- a/arch/cris/include/asm/thread_info.h
+++ b/arch/cris/include/asm/thread_info.h
@@ -68,7 +68,7 @@ struct thread_info {
 #define init_thread_info	(init_thread_union.thread_info)
 
 /* thread information allocation */
-#define alloc_thread_info(tsk, node) ((struct thread_info *) __get_free_pages(GFP_KERNEL,1))
+#define alloc_thread_info_node(tsk, node) ((struct thread_info *) __get_free_pages(GFP_KERNEL,1))
 #define free_thread_info(ti) free_pages((unsigned long) (ti), 1)
 
 #endif /* !__ASSEMBLY__ */
-- 
1.7.2.3

