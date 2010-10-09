Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760575Ab0JIT7r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 15:59:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50032 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760503Ab0JIT6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 15:58:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Andrea Gelmini <andrea.gelmini@gelma.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4/6] asm-generic: kdebug.h: Checkpatch cleanup
Date: Sat,  9 Oct 2010 21:57:50 +0200
Message-Id: <1286654272-21483-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286654272-21483-1-git-send-email-arnd@arndb.de>
References: <1286654272-21483-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:5DdbmHqmnhclh4lf2BH1PA9gxjrrQ9Fy5zrxSYqAKn8
 V79UVUQgXp4C8KXY0g2x+Qf/Ip3jHmH4k+D2UzGpNKTJh76pXa
 DfCqcf6EzY+b/1VfwGYgqPotuVI7ux8UgKsCaCvujbKbxwWj+K
 rfahQkFtFTL0gkJ42hY0xJRxwzJ9PsNnyyO9rfbPjJJK3jFSIL
 HkMYofcR829vU2Bbma5zQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrea Gelmini <andrea.gelmini@gelma.net>

include/asm-generic/kdebug.h:6: ERROR: spaces required around that '=' (ctx:VxV)

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/asm-generic/kdebug.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/kdebug.h b/include/asm-generic/kdebug.h
index 11e57b6..d181449 100644
--- a/include/asm-generic/kdebug.h
+++ b/include/asm-generic/kdebug.h
@@ -3,7 +3,7 @@
 
 enum die_val {
 	DIE_UNUSED,
-	DIE_OOPS=1
+	DIE_OOPS = 1,
 };
 
 #endif /* _ASM_GENERIC_KDEBUG_H */
-- 
1.7.1

