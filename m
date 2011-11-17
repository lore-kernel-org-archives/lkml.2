Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab1KQWi3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 17:38:29 -0500
Received: from mga09.intel.com ([134.134.136.24]:56473 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753693Ab1KQWhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 17:37:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="77077678"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: linux-kernel@vger.kernel.org, kbuild@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "H.J. Lu" <hjl.tools@gmail.com>, David Woodhouse <dwmw2@infradead.org>,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 5/8] trace: Include <asm/asm-offsets.h> in trace_syscalls.c
Date: Thu, 17 Nov 2011 14:37:23 -0800
Message-Id: <1321569446-20433-6-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1321569446-20433-1-git-send-email-hpa@linux.intel.com>
References: <1321569446-20433-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

Include <asm/asm-offsets.h> into trace_syscalls.c, to allow for
NR_syscalls to be automatically generated.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 kernel/trace/trace_syscalls.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index cb65454..5f35f6f 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -6,6 +6,7 @@
 #include <linux/ftrace.h>
 #include <linux/perf_event.h>
 #include <asm/syscall.h>
+#include <asm/asm-offsets.h>
 
 #include "trace_output.h"
 #include "trace.h"
-- 
1.7.6.4

