Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab2GYRma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 13:42:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55674 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab2GYRlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 13:41:55 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 18/19] tools lib traceevent: Ignore TRACEEVENT-CFLAGS file
Date: Wed, 25 Jul 2012 14:41:33 -0300
Message-Id: <1343238094-12481-19-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1343238094-12481-1-git-send-email-acme@infradead.org>
References: <1343238094-12481-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The TRACEEVENT-CFLAGS file is used to detect any change on compiler
flags. Just ignore it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1341559297-25725-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/.gitignore |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)
 create mode 100644 tools/lib/traceevent/.gitignore

diff --git a/tools/lib/traceevent/.gitignore b/tools/lib/traceevent/.gitignore
new file mode 100644
index 0000000..35f56be
--- /dev/null
+++ b/tools/lib/traceevent/.gitignore
@@ -0,0 +1 @@
+TRACEEVENT-CFLAGS
-- 
1.7.1

