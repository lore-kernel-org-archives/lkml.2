Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab1HRUMn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 16:12:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:46974 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088Ab1HRUMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 16:12:41 -0400
Date: Thu, 18 Aug 2011 20:12:18 GMT
From: tip-bot for Geunsik Lim <geunsik.lim@samsung.com>
Message-ID: <tip-d53e8365eaacfdb29253b39d186109f5b4fcc08d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, joe@perches.com, trivial@kernel.org,
        a.p.zijlstra@chello.nl, lizf@cn.fujitsu.com, geunsik.lim@samsung.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, trivial@kernel.org,
        joe@perches.com, geunsik.lim@samsung.com, lizf@cn.fujitsu.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1313653497-27263-1-git-send-email-leemgs1@gmail.com>
References: <1313653497-27263-1-git-send-email-leemgs1@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] MAINTAINERS: Fix list of perf events source files
Git-Commit-ID: d53e8365eaacfdb29253b39d186109f5b4fcc08d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (hera.kernel.org [127.0.0.1]); Thu, 18 Aug 2011 20:12:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d53e8365eaacfdb29253b39d186109f5b4fcc08d
Gitweb:     http://git.kernel.org/tip/d53e8365eaacfdb29253b39d186109f5b4fcc08d
Author:     Geunsik Lim <geunsik.lim@samsung.com>
AuthorDate: Thu, 18 Aug 2011 16:44:57 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 18 Aug 2011 07:26:05 -0300

MAINTAINERS: Fix list of perf events source files

Recent changes made kernel/perf_event.c be split and moved to
kernel/events/.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Kosina <trivial@kernel.org>
Cc: Joe Perches <joe@perches.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1313653497-27263-1-git-send-email-leemgs1@gmail.com
Signed-off-by: Geunsik Lim <geunsik.lim@samsung.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1e55e1e..7110675 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4971,7 +4971,7 @@ M:	Paul Mackerras <paulus@samba.org>
 M:	Ingo Molnar <mingo@elte.hu>
 M:	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
 S:	Supported
-F:	kernel/perf_event*.c
+F:	kernel/events/*
 F:	include/linux/perf_event.h
 F:	arch/*/kernel/perf_event*.c
 F:	arch/*/kernel/*/perf_event*.c
