Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759362Ab1EMOoW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 10:44:22 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50457 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759039Ab1EMOoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 10:44:21 -0400
From: jean.pihet@newoldbits.com
To: linux-kernel@vger.kernel.org
Cc: Thomas Renninger <trenn@suse.de>, Ingo Molnar <mingo@elte.hu>,
        Jean Pihet <j-pihet@ti.com>
Subject: [PATCH] perf: export power_start and power_end tracepoints
Date: Fri, 13 May 2011 16:43:58 +0200
Message-Id: <1305297838-4015-1-git-send-email-j-pihet@ti.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Pihet <j-pihet@ti.com>

If used in a module both tracepoints need to be exported by the
kernel.
Fixed a typo in CONFIG_EVENT_POWER_TRACING_DEPRECATED to really
export the tracepoints.

Signed-off-by: Jean Pihet <j-pihet@ti.com>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/power-traces.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/power-traces.c b/kernel/trace/power-traces.c
index f55fcf6..29b60f2 100644
--- a/kernel/trace/power-traces.c
+++ b/kernel/trace/power-traces.c
@@ -13,8 +13,9 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/power.h>
 
-#ifdef EVENT_POWER_TRACING_DEPRECATED
+#ifdef CONFIG_EVENT_POWER_TRACING_DEPRECATED
 EXPORT_TRACEPOINT_SYMBOL_GPL(power_start);
+EXPORT_TRACEPOINT_SYMBOL_GPL(power_end);
 #endif
 EXPORT_TRACEPOINT_SYMBOL_GPL(cpu_idle);
 
-- 
1.7.1

