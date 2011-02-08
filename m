Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab1BHPQ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 10:16:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:43458 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753848Ab1BHPQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 10:16:25 -0500
Date: Tue, 8 Feb 2011 15:16:08 GMT
From: tip-bot for Denis Kirjanov <dkirjanov@kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, dkirjanov@kernel.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, dkirjanov@kernel.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110205203938.GA15328@hera.kernel.org>
References: <20110205203938.GA15328@hera.kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf top: Use pid_t for target_{pid|tid}
Message-ID: <tip-ef4d001d79ac4bab6c2d81e9986a42059f877ec3@git.kernel.org>
Git-Commit-ID: ef4d001d79ac4bab6c2d81e9986a42059f877ec3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 08 Feb 2011 15:16:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ef4d001d79ac4bab6c2d81e9986a42059f877ec3
Gitweb:     http://git.kernel.org/tip/ef4d001d79ac4bab6c2d81e9986a42059f877ec3
Author:     Denis Kirjanov <dkirjanov@kernel.org>
AuthorDate: Sat, 5 Feb 2011 20:39:38 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 7 Feb 2011 09:10:15 -0200

perf top: Use pid_t for target_{pid|tid}

Use pid_t data type for target_{pid|tid} vars.

Cc: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <20110205203938.GA15328@hera.kernel.org>
Signed-off-by: Denis Kirjanov <dkirjanov@kernel.org>
[ committer note: those variables are now in struct perf_top, fixed ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/top.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
index fe44afb..62e3293 100644
--- a/tools/perf/util/top.h
+++ b/tools/perf/util/top.h
@@ -46,8 +46,8 @@ struct perf_top {
 	u64		   exact_samples;
 	u64		   guest_us_samples, guest_kernel_samples;
 	int		   print_entries, count_filter, delay_secs;
-	int		   display_weighted, freq, rb_entries;
-	int		   sym_counter, target_pid, target_tid;
+	int		   display_weighted, freq, rb_entries, sym_counter;
+	pid_t		   target_pid, target_tid;
 	bool		   hide_kernel_symbols, hide_user_symbols, zero;
 	const char	   *cpu_list;
 	struct perf_evsel  *sym_evsel;
