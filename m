Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab1FTWPV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 18:15:21 -0400
Received: from claw.goop.org ([74.207.240.146]:53587 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755245Ab1FTWPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 18:15:19 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Xen Devel <Xen-devel@lists.xensource.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 01/15] trace/xen: add skeleton for Xen trace events
Date: Mon, 20 Jun 2011 15:14:57 -0700
Message-Id: <c7c4910c2dae234938d944c9dc447591a2770716.1308607697.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/trace/events/xen.h |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)
 create mode 100644 include/trace/events/xen.h

diff --git a/include/trace/events/xen.h b/include/trace/events/xen.h
new file mode 100644
index 0000000..46c170c
--- /dev/null
+++ b/include/trace/events/xen.h
@@ -0,0 +1,13 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM xen
+
+#if !defined(_TRACE_XEN_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_XEN_H
+
+#include <linux/tracepoint.h>
+#include <asm/paravirt_types.h>
+
+#endif /*  _TRACE_XEN_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
1.7.5.4

