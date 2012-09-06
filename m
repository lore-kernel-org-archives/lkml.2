Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932475Ab2IFAKu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 20:10:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41280 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759956Ab2IFAKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 20:10:48 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH] perf: clean should remove libtraceevent.a too
Date: Wed,  5 Sep 2012 18:10:40 -0600
Message-Id: <1346890240-61205-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's built as part of perf, so it should be cleaned too.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Makefile |    1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 90d8e09..5f0259e 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -1068,6 +1068,7 @@ clean:
 	$(RM) $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-CFLAGS
 	$(RM) $(OUTPUT)util/*-bison*
 	$(RM) $(OUTPUT)util/*-flex*
+	$(RM) $(LIBTRACEEVENT)
 	$(python-clean)
 
 .PHONY: all install clean strip $(LIBTRACEEVENT)
-- 
1.7.10.1

