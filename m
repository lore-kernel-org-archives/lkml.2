Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933130Ab2GFHmK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 03:42:10 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:57514 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab2GFHmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 03:42:08 -0400
X-AuditID: 9c930179-b7cceae000004195-f0-4ff692eed384
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 2/6] tools lib traceevent: Ignore TRACEEVENT-CFLAGS file
Date: Fri,  6 Jul 2012 16:21:33 +0900
Message-Id: <1341559297-25725-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341559297-25725-1-git-send-email-namhyung@kernel.org>
References: <1341559297-25725-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The TRACEEVENT-CFLAGS file is used to detect any change on compiler
flags. Just ignore it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/.gitignore |    1 +
 1 file changed, 1 insertion(+)
 create mode 100644 tools/lib/traceevent/.gitignore

diff --git a/tools/lib/traceevent/.gitignore b/tools/lib/traceevent/.gitignore
new file mode 100644
index 000000000000..35f56be5a4cd
--- /dev/null
+++ b/tools/lib/traceevent/.gitignore
@@ -0,0 +1 @@
+TRACEEVENT-CFLAGS
-- 
1.7.10.4

