Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097Ab3ADQkl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 11:40:41 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:65278 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754974Ab3ADQkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 11:40:39 -0500
Message-ID: <201301041640.r04Gec6W018533@farm-0010.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 4 Jan 2013 11:37:13 -0500
Subject: [PATCH] tile: remove an unused variable in copy_thread()
To: <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/process.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index 0e5661e..caf93ae 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -159,7 +159,7 @@ static void save_arch_state(struct thread_struct *t);
 int copy_thread(unsigned long clone_flags, unsigned long sp,
 		unsigned long arg, struct task_struct *p)
 {
-	struct pt_regs *childregs = task_pt_regs(p), *regs = current_pt_regs();
+	struct pt_regs *childregs = task_pt_regs(p);
 	unsigned long ksp;
 	unsigned long *callee_regs;
 
-- 
1.7.10.3

