Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759057Ab2J2NnZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 09:43:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65454 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756749Ab2J2NnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 09:43:24 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>,
        Irina Tirdea <irina.tirdea@intel.com>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] Documentation: insert an additional information to android.txt
Date: Mon, 29 Oct 2012 22:41:06 +0900
Message-Id: <1351518066-4791-1-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without defining ARCH=arm, building a perf for Android ARM will be failed,
because it needs architecture specific files.
So add related information to a document.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>

Cc: Irina Tirdea <irina.tirdea@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>

---
It is based on git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git,
perf-core-for-mingo branch.

diff --git a/tools/perf/Documentation/android.txt b/tools/perf/Documentation/android.txt
index a39dbbb..8484c3a 100644
--- a/tools/perf/Documentation/android.txt
+++ b/tools/perf/Documentation/android.txt
@@ -48,7 +48,10 @@ For x86:
 II. Compile perf for Android
 ------------------------------------------------
 You need to run make with the NDK toolchain and sysroot defined above:
-  make CROSS_COMPILE=${NDK_TOOLCHAIN} CFLAGS="--sysroot=${NDK_SYSROOT}"
+For arm:
+  make ARCH=arm CROSS_COMPILE=${NDK_TOOLCHAIN} CFLAGS="--sysroot=${NDK_SYSROOT}"
+For x86:
+  make ARCH=x86 CROSS_COMPILE=${NDK_TOOLCHAIN} CFLAGS="--sysroot=${NDK_SYSROOT}"
 
 III. Install perf
 -----------------------------------------------
-- 
1.7.9.5

