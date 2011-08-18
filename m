Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab1HRTBl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:01:41 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44234 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab1HRTBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:01:40 -0400
Date: Thu, 18 Aug 2011 20:01:39 +0100
To: richard@nod.at
Subject: Subject: [PATCH 16/91] um: kill a couple of useless includes of
 kern_constants.h
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7qV-0007Xh-8M@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/sys-x86_64/shared/sysdep/syscalls.h |    1 -
 arch/um/sys-x86_64/syscall_table.c          |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/um/sys-x86_64/shared/sysdep/syscalls.h b/arch/um/sys-x86_64/shared/sysdep/syscalls.h
index 7cfb0b0..8a7d5e1 100644
--- a/arch/um/sys-x86_64/shared/sysdep/syscalls.h
+++ b/arch/um/sys-x86_64/shared/sysdep/syscalls.h
@@ -9,7 +9,6 @@
 
 #include <linux/msg.h>
 #include <linux/shm.h>
-#include <kern_constants.h>
 
 typedef long syscall_handler_t(void);
 
diff --git a/arch/um/sys-x86_64/syscall_table.c b/arch/um/sys-x86_64/syscall_table.c
index 47d469e..f46de82 100644
--- a/arch/um/sys-x86_64/syscall_table.c
+++ b/arch/um/sys-x86_64/syscall_table.c
@@ -6,7 +6,6 @@
 #include <linux/linkage.h>
 #include <linux/sys.h>
 #include <linux/cache.h>
-#include <kern_constants.h>
 
 #define __NO_STUBS
 
-- 
1.7.2.5


