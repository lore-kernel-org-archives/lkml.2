Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab2KNGbl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:31:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43064 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab2KNGbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 01:31:39 -0500
Date: Tue, 13 Nov 2012 22:31:09 -0800
From: tip-bot for Joonsoo Kim <js1304@gmail.com>
Message-ID: <tip-cd69ef88a7cbe5ad404454ed8f491e6b16b4e86f@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        penberg@kernel.org, namhyung@kernel.org, jolsa@redhat.com,
        js1304@gmail.com, rostedt@goodmis.org, irina.tirdea@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        penberg@kernel.org, namhyung@kernel.org, jolsa@redhat.com,
        js1304@gmail.com, rostedt@goodmis.org, irina.tirdea@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1351518066-4791-1-git-send-email-js1304@gmail.com>
References: <1351518066-4791-1-git-send-email-js1304@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Add info about cross compiling for Android ARM
Git-Commit-ID: cd69ef88a7cbe5ad404454ed8f491e6b16b4e86f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 22:31:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cd69ef88a7cbe5ad404454ed8f491e6b16b4e86f
Gitweb:     http://git.kernel.org/tip/cd69ef88a7cbe5ad404454ed8f491e6b16b4e86f
Author:     Joonsoo Kim <js1304@gmail.com>
AuthorDate: Mon, 29 Oct 2012 22:41:06 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 31 Oct 2012 12:17:49 -0200

perf tools: Add info about cross compiling for Android ARM

Without defining ARCH=arm, building perf for Android ARM will fail,
because it needs architecture specific files.

So add related relevant information to the android documentation.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Irina Tirdea <irina.tirdea@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1351518066-4791-1-git-send-email-js1304@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/android.txt |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

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
