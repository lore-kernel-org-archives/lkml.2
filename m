Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab2GYTdH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 15:33:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58538 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab2GYTdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 15:33:06 -0400
Date: Wed, 25 Jul 2012 12:32:45 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-52f18a2ff9b012a7efdbd520ca0dc0e118a8a837@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1341559297-25725-3-git-send-email-namhyung@kernel.org>
References: <1341559297-25725-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Ignore TRACEEVENT-CFLAGS file
Git-Commit-ID: 52f18a2ff9b012a7efdbd520ca0dc0e118a8a837
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 25 Jul 2012 12:32:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  52f18a2ff9b012a7efdbd520ca0dc0e118a8a837
Gitweb:     http://git.kernel.org/tip/52f18a2ff9b012a7efdbd520ca0dc0e118a8a837
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 6 Jul 2012 16:21:33 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 25 Jul 2012 11:54:44 -0300

tools lib traceevent: Ignore TRACEEVENT-CFLAGS file

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

diff --git a/tools/lib/traceevent/.gitignore b/tools/lib/traceevent/.gitignore
new file mode 100644
index 0000000..35f56be
--- /dev/null
+++ b/tools/lib/traceevent/.gitignore
@@ -0,0 +1 @@
+TRACEEVENT-CFLAGS
