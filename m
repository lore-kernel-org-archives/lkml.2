Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab2JKE1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 00:27:45 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43466 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab2JKEZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 00:25:44 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 1/9] perf python: add ui stubs file
Date: Wed, 10 Oct 2012 22:25:27 -0600
Message-Id: <1349929535-92861-2-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1349929535-92861-1-git-send-email-dsahern@gmail.com>
References: <1349929535-92861-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stderr based implementations of ui_xxxx functions for the python
library. Needed for patch 3 - consolidating open counters method.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 tools/perf/util/python-ext-sources |    1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/python-ext-sources b/tools/perf/util/python-ext-sources
index 2133628..8a45370 100644
--- a/tools/perf/util/python-ext-sources
+++ b/tools/perf/util/python-ext-sources
@@ -19,3 +19,4 @@ util/debugfs.c
 util/rblist.c
 util/strlist.c
 ../../lib/rbtree.c
+util/ui_stubs.c
-- 
1.7.10.1

