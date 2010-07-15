Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934858Ab0GOWGt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 18:06:49 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59259 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934835Ab0GOWGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 18:06:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=alV8Q4HYZ8Wr6V+fDcELMgqSQr611WgsNYoY9cQ/0C4twZg1WLg7CkJlNWtq9SXN3y
         Ec/jO42MT5gwsNQ50Q/nJlLpchWCM0FYZYbUZsprFMHjU6b489yg8BLrhnYZITYHRD34
         En6oQ/sqN1UNaE8wa5xCUmQaHR89HZ+ZXfJXc=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 1/3] tracing: Update tracing branch url
Date: Fri, 16 Jul 2010 00:06:41 +0200
Message-Id: <1279231603-30624-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1279231603-30624-1-git-send-regression-fweisbec@gmail.com>
References: <1279231603-30624-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ftrace and perf events now use the same development branch.
Don't show a stale branch to developers.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9f90de2..99e9b20 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5644,7 +5644,7 @@ TRACING
 M:	Steven Rostedt <rostedt@goodmis.org>
 M:	Frederic Weisbecker <fweisbec@gmail.com>
 M:	Ingo Molnar <mingo@redhat.com>
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing/core
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf/core
 S:	Maintained
 F:	Documentation/trace/ftrace.txt
 F:	arch/*/*/*/ftrace.h
-- 
1.6.2.3

