Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab1HRTHb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:07:31 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47490 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022Ab1HRTHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:07:30 -0400
Date: Thu, 18 Aug 2011 20:07:29 +0100
To: richard@nod.at
Subject: Subject: [PATCH 51/91] um: shared/syscall.h is not even included
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7w9-0007oL-NB@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


... and functions declared in it do not exist

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/include/shared/syscall.h |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)
 delete mode 100644 arch/um/include/shared/syscall.h

diff --git a/arch/um/include/shared/syscall.h b/arch/um/include/shared/syscall.h
deleted file mode 100644
index dda1df9..0000000
--- a/arch/um/include/shared/syscall.h
+++ /dev/null
@@ -1,12 +0,0 @@
-/*
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
- * Licensed under the GPL
- */
-
-#ifndef __SYSCALL_USER_H
-#define __SYSCALL_USER_H
-
-extern int record_syscall_start(int syscall);
-extern void record_syscall_end(int index, long result);
-
-#endif
-- 
1.7.2.5


