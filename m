Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab1HRTFf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:05:35 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44336 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab1HRTFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:05:30 -0400
Date: Thu, 18 Aug 2011 20:05:29 +0100
To: richard@nod.at
Subject: Subject: [PATCH 39/91] um: shared/process.h is empty now; kill it
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7uD-0007hs-M2@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/include/shared/process.h |    9 ---------
 arch/um/os-Linux/irq.c           |    1 -
 arch/um/os-Linux/process.c       |    1 -
 arch/um/os-Linux/sigio.c         |    1 -
 arch/um/os-Linux/signal.c        |    1 -
 arch/um/os-Linux/skas/process.c  |    1 -
 6 files changed, 0 insertions(+), 14 deletions(-)
 delete mode 100644 arch/um/include/shared/process.h

diff --git a/arch/um/include/shared/process.h b/arch/um/include/shared/process.h
deleted file mode 100644
index 2ba310e..0000000
--- a/arch/um/include/shared/process.h
+++ /dev/null
@@ -1,9 +0,0 @@
-/* 
- * Copyright (C) 2000 - 2008 Jeff Dike (jdike@{addtoit,linux.intel}.com)
- * Licensed under the GPL
- */
-
-#ifndef __PROCESS_H__
-#define __PROCESS_H__
-
-#endif
diff --git a/arch/um/os-Linux/irq.c b/arch/um/os-Linux/irq.c
index 59c592c..9a49908 100644
--- a/arch/um/os-Linux/irq.c
+++ b/arch/um/os-Linux/irq.c
@@ -10,7 +10,6 @@
 #include <string.h>
 #include "irq_user.h"
 #include "os.h"
-#include "process.h"
 #include "um_malloc.h"
 
 /*
diff --git a/arch/um/os-Linux/process.c b/arch/um/os-Linux/process.c
index e08fe30..307f173 100644
--- a/arch/um/os-Linux/process.c
+++ b/arch/um/os-Linux/process.c
@@ -15,7 +15,6 @@
 #include "init.h"
 #include "longjmp.h"
 #include "os.h"
-#include "process.h"
 #include "skas_ptrace.h"
 
 #define ARBITRARY_ADDR -1
diff --git a/arch/um/os-Linux/sigio.c b/arch/um/os-Linux/sigio.c
index 34bb59b..3c16121 100644
--- a/arch/um/os-Linux/sigio.c
+++ b/arch/um/os-Linux/sigio.c
@@ -14,7 +14,6 @@
 #include "kern_util.h"
 #include "init.h"
 #include "os.h"
-#include "process.h"
 #include "sigio.h"
 #include "um_malloc.h"
 
diff --git a/arch/um/os-Linux/signal.c b/arch/um/os-Linux/signal.c
index 9f2c222..4d31688 100644
--- a/arch/um/os-Linux/signal.c
+++ b/arch/um/os-Linux/signal.c
@@ -12,7 +12,6 @@
 #include "as-layout.h"
 #include "kern_util.h"
 #include "os.h"
-#include "process.h"
 #include "sysdep/barrier.h"
 #include "sysdep/mcontext.h"
 
diff --git a/arch/um/os-Linux/skas/process.c b/arch/um/os-Linux/skas/process.c
index 8a1ccc7..514683f 100644
--- a/arch/um/os-Linux/skas/process.c
+++ b/arch/um/os-Linux/skas/process.c
@@ -17,7 +17,6 @@
 #include "kern_util.h"
 #include "mem.h"
 #include "os.h"
-#include "process.h"
 #include "proc_mm.h"
 #include "ptrace_user.h"
 #include "registers.h"
-- 
1.7.2.5


