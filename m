Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966576Ab2FBLIn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 07:08:43 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:55249 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966558Ab2FBLIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 07:08:42 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] frv: Remove bogus closing parenthesis
Date: Sat,  2 Jun 2012 13:08:39 +0200
Message-Id: <1338635319-28226-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduced by commit 6fd84c0831ec78d98736b76dc5e9b849f1dbfc9e
("TIF_RESTORE_SIGMASK can be set only when TIF_SIGPENDING is set")

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Yes, it also failed in linux-next the day before
http://kisskb.ellerman.id.au/kisskb/buildresult/6413279/
---
 arch/frv/kernel/signal.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/frv/kernel/signal.c b/arch/frv/kernel/signal.c
index f3b9064..864c2f0 100644
--- a/arch/frv/kernel/signal.c
+++ b/arch/frv/kernel/signal.c
@@ -518,7 +518,7 @@ asmlinkage void do_notify_resume(__u32 thread_info_flags)
 		clear_thread_flag(TIF_SINGLESTEP);
 
 	/* deal with pending signal delivery */
-	if (thread_info_flags & _TIF_SIGPENDING))
+	if (thread_info_flags & _TIF_SIGPENDING)
 		do_signal();
 
 	/* deal with notification on about to resume userspace execution */
-- 
1.7.0.4

