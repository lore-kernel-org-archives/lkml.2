Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757702Ab2C1M7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 08:59:11 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:41288 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab2C1M7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 08:59:07 -0400
Subject: [PATCH] perf: missing export.h file
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>, mingo@elte.hu,
        linux-kernel@vger.kernel.org, acme@infradead.org, ananth@in.ibm.com,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>, rostedt@goodmis.org
In-Reply-To: <20120328114745.GA17936@gmail.com>
References: <4F6AF410.1010400@linux.vnet.ibm.com>
	 <4F6AFD92.4030603@linux.vnet.ibm.com> <4F6C721B.9060807@hitachi.com>
	 <4F703FB9.9020407@linux.vnet.ibm.com> <4F704A1E.2040401@hitachi.com>
	 <20120328114745.GA17936@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Mar 2012 14:59:01 +0200
Message-ID: <1332939541.2325.7.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    CC util/rbtree.o
../../lib/rbtree.c:24:26: error: linux/export.h: No such file or
directory
cc1: warnings being treated as errors

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
I must be missing something, why nobody hits this error ???

diff --git a/tools/perf/util/include/linux/export.h b/tools/perf/util/include/linux/export.h
new file mode 100644
index 0000000..841636d
--- /dev/null
+++ b/tools/perf/util/include/linux/export.h
@@ -0,0 +1,6 @@
+#ifndef PERF_LINUX_EXPORT_H
+#define PERF_LINUX_EXPORT_H
+
+#define EXPORT_SYMBOL(name)
+
+#endif


